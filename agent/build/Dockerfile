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
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /src/bin/agent -ldflags "$GO_LDFLAGS" /src/agent/cmd/agent/main.go

# Final image
FROM ubuntu:22.04
LABEL maintainer="modelz-support@tensorchord.ai"

COPY --from=builder /src/bin/agent /usr/bin/agent
ENTRYPOINT ["/usr/bin/agent"]

