#GOPATH:=$(PWD):${GOPATH}
#export GOPATH
OS := $(shell uname)
ifeq ($(OS),Darwin)
flags=-ldflags="-s -w"
else
flags=-ldflags="-s -w -extldflags -static"
endif
TAG := $(shell git tag | sort -r | head -n 1)

all: build

build:
	sed -i -e "s,{{VERSION}},$(TAG),g" main.go
	go clean; rm -rf pkg dasgoclient*; go build ${flags}
	sed -i -e "s,$(TAG),{{VERSION}},g" main.go

build_all: build_osx build_linux build_power8 build_arm64 build_windows

build_osx:
	sed -i -e "s,{{VERSION}},$(TAG),g" main.go
	go clean; rm -rf pkg dasgoclient_osx; GOOS=darwin go build ${flags}
	sed -i -e "s,$(TAG),{{VERSION}},g" main.go
	mv dasgoclient dasgoclient_osx

build_linux:
	sed -i -e "s,{{VERSION}},$(TAG),g" main.go
	go clean; rm -rf pkg dasgoclient_linux; GOOS=linux go build ${flags}
	sed -i -e "s,$(TAG),{{VERSION}},g" main.go
	mv dasgoclient dasgoclient_linux

build_power8:
	sed -i -e "s,{{VERSION}},$(TAG),g" main.go
	go clean; rm -rf pkg dasgoclient_power8; GOARCH=ppc64le GOOS=linux go build ${flags}
	sed -i -e "s,$(TAG),{{VERSION}},g" main.go
	mv dasgoclient dasgoclient_power8

build_arm64:
	sed -i -e "s,{{VERSION}},$(TAG),g" main.go
	go clean; rm -rf pkg dasgoclient_arm64; GOARCH=arm64 GOOS=linux go build ${flags}
	sed -i -e "s,$(TAG),{{VERSION}},g" main.go
	mv dasgoclient dasgoclient_arm64

build_windows:
	go clean; rm -rf pkg dasgoclient.exe; GOARCH=amd64 GOOS=windows go build ${flags}

install:
	go install

clean:
	go clean; rm -rf pkg

test : test1

test1:
	go test -exe=$(PWD)/dasgoclient -timeout 20m
