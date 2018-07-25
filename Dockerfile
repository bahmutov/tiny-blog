# multi-stage Docker build with testing node_modules and Cypress binary
# discarded before serving in production
# https://glebbahmutov.com/blog/making-small-docker-image/

# testing image - we really want to cache AS MUCH AS POSSIBLE
# so we build like this
#   - copy package files
#   - run "npm ci"
#   - copy spec files
# this way Cypress and node_modules are cached as long as package files stay same
FROM cypress/base:10 as TEST
WORKDIR /app
COPY package.json .
COPY package-lock.json .
# RUN npm ci
# copy tests
COPY cypress.json .
COPY cypress cypress
# copy what to test
COPY public public
RUN ls -la
# run e2e Cypress tests
RUN npm test

# production image - without Cypress and node modules!
FROM busybox as PROD
COPY --from=TEST /app/public /public
# nothing to do - Zeit should take care of serving static content
# we would only need a command if we want to use this image locally
