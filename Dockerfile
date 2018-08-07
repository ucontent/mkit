FROM alpine:latest as build

MAINTAINER Antonio Dell'Elce

ENV BUILDDIR  /app-build
ENV INSTALLDIR  /app/httpd

# gcc             most of the source needs gcc
# bash            busybox does not support some needed features of bash like "typeset"
# wget            builtin wget does not work for us
# perl            I'll pass...
# file            no magic inside
# xz              xz is the "best"
# libc-dev        headers
# linux-headers   more headers
ENV PACKAGES gcc bash ncurses ncurses-libs wget perl file xz make libc-dev linux-headers g++

WORKDIR $BUILDDIR
COPY . $BUILDDIR

RUN  apk add --no-cache  $PACKAGES &&  \
     bash ${BUILDDIR}/docker.sh $INSTALLDIR

# Second Stage
FROM alpine:latest AS final

ENV INSTALLDIR  /app/httpd

RUN mkdir -p ${INSTALLDIR} && \
    apk add --no-cache libgcc ncurses-libs

WORKDIR ${INSTALLDIR}
COPY --from=build ${INSTALLDIR} .
