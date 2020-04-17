FROM alpine:edge
LABEL maintainer "Randy McMillan<randy.lee.mcmillan@gmail.com>"

# add community and testing repo
RUN echo "@main http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    mkdir /var/log/supervisor

# install the packges we need
RUN apk add --no-cache bash bitcoin@testing bitcoin-cli@testing shadow supervisor tor

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY bitcoin.conf /root/.bitcoin/bitcoin.conf
EXPOSE 8332 8333
WORKDIR /root
CMD ["supervisord","-c","/etc/supervisor/supervisord.conf"]
CMD ["bitcoind"]

#TODO: Build bitcoin on host and test signature
## Install all build dependencies
## Add bash for debugging purposes
#RUN apk update \
#    && apk add --virtual build-dependencies \
#        build-base \
#        gcc \
#        wget \
#        git \
#    && apk add \
#        bash bash-completion
#
#WORKDIR /bitcoin.ish
#
## Copy entire app over
#COPY . /bitcoin.ish
#
#EXPOSE 3000
#
#CMD ["node", "index.js"]
