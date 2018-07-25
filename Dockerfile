# multi-stage Docker build with testing node_modules and Cypress binary
# discarded before serving in production
# https://glebbahmutov.com/blog/making-small-docker-image/

# for testing - copy everything
FROM cypress/base:10 as TEST
WORKDIR /app
COPY . .

# install dependencies, needed for testing
# RUN npm ci
RUN ls -la
# run e2e tests
# RUN npm test
RUN echo "running tests... (fake)"

# production image - without Cypress and node modules!
FROM busybox as PROD
COPY --from=TEST /app/public /public
# nothing to do - Zeit should take care of serving static content
# we would only need a command if we want to use this image locally
