# multi-stage Docker build with testing node_modules and Cypress binary
# discarded before serving in production
# https://glebbahmutov.com/blog/making-small-docker-image/

# testing image - we really want to cache AS MUCH AS POSSIBLE
# so we build like this
#   - copy package files
#   - run "npm ci"
#   - copy spec files
# this way Cypress and node_modules are cached as long as package files stay same
# Docker build looks at the file checksums during each "COPY ..." command
# and if the copied files were the same, the image layer is cached and not recomputed
# https://docs.docker.com/v17.09/engine/userguide/eng-image/dockerfile_best-practices/#build-cache
# every other command like "RUN npm ci" is cached by default unless the command itself has been changed
FROM cypress/base:10 as TEST
WORKDIR /app
COPY package.json .
# TEMP remove package lock to install custom Cypress NPM module
# COPY package-lock.json .
# RUN npm ci
ENV CYPRESS_INSTALL_BINARY=https://cdn.cypress.io/beta/binary/3.0.3/linux64/circle-render-without-terminal-in-cli-1243-970b9c75822e22c802f913221281d33e97bd7673-30290/cypress.zip
RUN npm install
# copy tests
COPY cypress cypress
COPY cypress.json .
# copy what to test
COPY public public
RUN ls -la
RUN ls -la public
# run e2e Cypress tests
RUN npm test

# production image - without Cypress and node modules!
FROM busybox as PROD
COPY --from=TEST /app/public /public
# nothing to do - Zeit should take care of serving static content
# we would only need a command if we want to use this image locally

# show the size of the current folder so we know
RUN ls -la
RUN du -sh
