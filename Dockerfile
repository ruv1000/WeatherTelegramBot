FROM quay.io/projectquay/golang:1.21 as builder

WORKDIR /go/src/app
COPY . .
ARG TARGETARCH
RUN make build TARGETARCH=$TARGETARCH

FROM scratch
WORKDIR /go/src/app/
COPY --from=builder /go/src/app/WeatherTelegramBot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./WeatherTelegramBot", "start"]
