FROM alpine:3.18 as verified

ARG VERSION
ARG ARCH x86_64
ARG VARIANT linux-gnu

ADD https://download.litecoin.org/litecoin-${VERSION}/SHA256SUMS.asc .
ADD https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz.asc .
ADD https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz .

# Verify downloaded archive
RUN apk add --no-cache gnupg && \
    gpg --keyserver keyserver.ubuntu.com --recv-key 3620e9d387e55666 && \
    gpg --verify litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz.asc && \
    grep litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz SHA256SUMS.asc | sha256sum -c && \
    tar xzf litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz && \
    rm -f litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz litecoin-${VERSION}-${ARCH}-${VARIANT}.tar.gz.asc SHA256SUMS.asc

#FROM frolvlad/alpine-glibc:latest as prepare
FROM frolvlad/alpine-glibc:latest as prepare

ARG VERSION

COPY --from=verified /litecoin-${VERSION}/bin/litecoin*  /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENV USER litecoin

RUN adduser -D $USER && \
    mkdir -p /data /home/$USER && \
    ln -sf /data /home/$USER/.litecoin && \
    chown ${USER} /home/$USER/.litecoin /data && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

USER $USER
WORKDIR /home/$USER
VOLUME /data

# REST interface
EXPOSE 8080

# P2P network (mainnet, testnet & regnet respectively)
EXPOSE 9333 18333 18444

# RPC interface (mainnet, testnet & regnet respectively)
EXPOSE 9332 18332 18443

# ZMQ ports (for transactions & blocks respectively)
EXPOSE 28332 28333

ENTRYPOINT ["docker-entrypoint.sh"]