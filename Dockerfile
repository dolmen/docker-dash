# Docker image for static DASH ("the Debian Almquist Shell")
#
# @see http://gondor.apana.org.au/~herbert/dash/
# @see http://www.in-ulm.de/~mascheck/various/ash/
# @see http://man7.org/linux/man-pages/man7/signal.7.html
#


FROM ubuntu:disco AS builder

# install toolchain for building...
RUN DEBIAN_FRONTEND=noninteractive  \
    apt-get update  &&  \
    apt-get -f -y install git build-essential automake



WORKDIR /src
COPY    build-rootfs  /src
RUN     ./build.sh

# pull base image
FROM scratch
MAINTAINER Olivier Mengué <dolmen@cpan.org>

HEALTHCHECK NONE
ENV PATH=/bin

COPY --from=builder /src/dash/rootfs /

CMD ["/bin/sh"]
