
include version.env

SERVER_NAME=forge-1.12.2-server

.PHONY: build-server push-server


install:
	bash install.sh

build-server:
	docker build --network=host --progress=plain -t $(SERVER_NAME) .

push-server: build-server
	docker tag $(SERVER_NAME) cake404/forge-1.12.2-server:$(BUILD_VERSION)
	docker push cake404/forge-1.12.2-server:$(BUILD_VERSION)

	docker tag $(SERVER_NAME) cake404/forge-1.12.2-server:latest
	docker push cake404/forge-1.12.2-server:latest

run-server:
	docker run -dp 25565:25565 forge-1.12.2-server:latest -m 6g
