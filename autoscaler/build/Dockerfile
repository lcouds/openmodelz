# Build the manager binary
FROM --platform=$BUILDPLATFORM golang:1.20.10-bullseye AS builder

ARG GO_LDFLAGS=""

COPY . /src
WORKDIR /src
ENV GOPROXY=https://goproxy.cn,direct
RUN export GO111MODULE=on  && \
    go mod tidy

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /src/bin/autoscaler -ldflags "$GO_LDFLAGS" /src/autoscaler/cmd/autoscaler/main.go

# Final image
FROM ubuntu:22.04
LABEL maintainer="modelz-support@tensorchord.ai"

COPY --from=builder /src/bin/autoscaler /usr/bin/autoscaler
ENTRYPOINT ["/usr/bin/autoscaler"]

