FROM busybox
RUN mkdir /public
COPY public/* /public
