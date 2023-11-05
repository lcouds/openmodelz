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
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /src/bin/ingress-operator -ldflags "$GO_LDFLAGS" /src/ingress-operator/cmd/ingress-operator/main.go

# Final image
FROM ubuntu:22.04
LABEL maintainer="modelz-support@tensorchord.ai"

COPY --from=builder /src/bin/ingress-operator /usr/bin/ingress-operator
ENTRYPOINT ["/usr/bin/ingress-operator"]

