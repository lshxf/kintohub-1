FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git bash curl
WORKDIR /go/src/V2/core
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM alpine
ENV CONFIG=https://raw.githubusercontent.com/lshxf/kintohub-1/master/config.json
COPY --from=builder /tmp/ray.tgz /tmp
RUN apk update && apk add --no-cache tor ca-certificates && \
    tar xvfz /tmp/ray.tgz -C /usr/bin && \
    rm -rf /tmp/ray.tgz
    
CMD nohup tor & \
    v2ray -config $CONFIG
