FROM cypress/base:10
RUN mkdir /public
COPY public/* /public
