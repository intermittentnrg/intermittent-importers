ifneq (,$(wildcard ./.env))
    include .env
    export
endif

TIMESTAMP := $(shell TZ=UTC date +%Y%m%d-%H%M)
export TAG ?= $(TIMESTAMP)

refresh: fetch docker_build helm_apply

## load new data
fetch:
	scripts/sincedb-generation.rb
	scripts/sincedb-load.rb

## build influxdb-preloaded docker image
docker_build:
	docker buildx build \
		--no-cache \
		--platform=linux/arm64 -f Dockerfile.influxdb-preloaded \
		--build-arg INFLUXDB_VERSION \
		--build-arg INFLUX_USERNAME \
		--build-arg INFLUX_PASSWORD \
		--build-arg INFLUX_DATABASE \
		--build-arg INFLUX_HOST \
		-t $(DOCKER_REGISTRY)/influxdb-preloaded:$(TAG) -o type=registry \

## helm apply
helm_apply:
	cd chart && helmfile apply --set image.tag=$(TAG)

## helm diff
helm_diff:
	cd chart && helmfile diff --set image.tag=$(TAG)

## update secret from .env
update_secret:
	kubectl create secret generic -n jenkins intermittency --from-env-file=.env --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic -n intermittency intermittency --from-env-file=.env --dry-run=true -o yaml | kubectl apply -f -

## influxdb client
client:
	influx -host $(INFLUX_HOST) -database $(INFLUX_DATABASE) -username $(INFLUX_USERNAME) -password $(INFLUX_PASSWORD) -precision rfc3339

setup_db:
# CREATE RETENTION POLICY month ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 30d
# CREATE RETENTION POLICY year ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 52w

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
