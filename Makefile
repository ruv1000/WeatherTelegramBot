APP=$(shell basename $(shell git remote get-url origin | tr '[:upper:]' '[:lower:]') | sed 's/\.git//')
# REGISTRY=ruv1000
REGISTRY=ghcr.io/ruv1000
.DEFAULT_GOAL=build
VERSION=$(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")-$(shell git rev-parse --short HEAD)
TARGETOS=$(shell uname | tr '[:upper:]' '[:lower:]' | tr -d ' \t\n\r')#linux darwin windows
TARGETARCH=$(shell dpkg --print-architecture | tr -d ' \t\n\r')#amd64 arm64

debug:
	@echo "Building Docker image with the following parameters:"
	@echo "APP=${APP}"
	@echo "REGISTRY=${REGISTRY}"
	@echo "VERSION=${VERSION}"
	@echo "TARGETOS=${TARGETOS}"
	@echo "TARGETARCH=${TARGETARCH}"

format:
	gofmt -s -w ./
	go fmt ./...

lint:
	go vet ./...

test:
	go test -v

get:
	go mod tidy
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o WeatherTelegramBot -ldflags "-X="github.com/ruv1000/WeatherTelegramBot/cmd.appVersion=${VERSION} || true

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf WeatherTelegramBot
	go clean
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}