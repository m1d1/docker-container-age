# vim: noet:

.SILENT:
.PHONY: all clean install

APP_NAME    := container_age
TMP_NAME    := $(APP_NAME)".go"

VERSION	    := $(shell cat ./VERSION)
GOROOT	    := /usr/local/go/
GO_SDK      := https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz


#
# todo: setup dep / toml

all:	build
	echo "*** all done"

# build go app
build: 
	echo "*** building Go application"
	export CGO_ENABLED=0;\
	#dep ensure	
	cp ./main.go ./$(TMP_NAME)
	sed -i s/\%VERSION\%/$(VERSION)/g $(TMP_NAME)	
	go build -ldflags "-s -w" $(TMP_NAME)
	-rm ./$(TMP_NAME)


# install go sdk, dep and project packages
install:
	#echo "*** install dep"
	#@test -f /usr/local/bin/dep || sudo wget https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 -O /usr/local/bin/dep

	echo "*** installing go sdk"
	@test -f $(GOROOT)/bin/go && { echo "*** it seems like go sdk is already installed!"; exit 1; } || \
	sudo mkdir -p $(GOROOT);\
	cd $(GOROOT);\
	sudo wget -q --show-progress --progress=dot:giga $(GO_SDK) -O - | sudo tar xz;\
	sudo mv go/* .;\
	sudo rmdir go
	#dep init
	go get github.com/docker/docker/client


uninstall:
	echo "*** uninstalling go sdk"
	-sudo rm -rf $(GOROOT)

clean:
	echo "*** cleaning up"
	-rm main
