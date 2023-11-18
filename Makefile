APP=$(shell basename $(shell git remote get-url origin | tr '[:upper:]' '[:lower:]') | sed 's/\.git//')
REGISTRY=ruv1000
.DEFAULT_GOAL=build
VERSION=$(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")-$(shell git rev-parse --short HEAD)
TARGETOS=$(shell uname | tr '[:upper:]' '[:lower:]')
TARGETARCH=$(shell dpkg --print-architecture)

format:
	gofmt -s -w ./
	go fmt ./...

lint:
	go vet ./...
	golint

test:
	go test -v

get:
	go mod tidy
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o WeatherTelegramBot -ldflags "-X="github.com/ruv1000/WeatherTelegramBot/cmd.appVersion=${VERSION} || true

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf WeatherTelegramBot
	go clean
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}