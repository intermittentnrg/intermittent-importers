ifneq (,$(wildcard ./.env))
    include .env
    export
endif

refresh: fetch backup docker_restore docker_build helm_apply

fetch:
	scripts/sincedb-generation.rb
	scripts/sincedb-load.rb

.PHONY: backup
backup:
	rm -rf backup
	influxd backup -portable -host $(INFLUX_HOST):8088 -database $(INFLUX_DATABASE) backup

docker_restore:
	docker-compose down
	sudo rm -rf docker/data
	docker-compose up -d influxdb
	docker-compose exec influxdb influxd restore -portable -db $(INFLUX_DATABASE) -newdb $(INFLUX_DATABASE) -host localhost:8088 /backup
	docker-compose exec influxdb influx -host localhost -database intermittency -execute "CREATE USER $(INFLUX_USERNAME) WITH PASSWORD '$(INFLUX_PASSWORD)' WITH ALL PRIVILEGES"
	docker-compose exec influxdb influx -host localhost -database intermittency -execute "CREATE USER grafana WITH PASSWORD 'grafana'"
	docker-compose exec influxdb influx -host localhost -database intermittency -execute "GRANT READ ON intermittency TO grafana"

TAG ?= $(shell TZ=UTC date +%Y%m%d-%H%M)
docker_build:
	docker-compose down
	sudo chmod -R a+rwX docker/data/
	cd docker && docker buildx build --platform=linux/arm64 -f Dockerfile.influxdb-preloaded \
		--build-arg INFLUXDB_VERSION \
		-t $(DOCKER_REGISTRY)/influxdb-preloaded:$(TAG) -o type=registry \
		.

helm_apply:
	cd chart && helmfile apply --set image.tag=$(TAG)

helm_diff:
	cd chart && helmfile diff --set image.tag=$(TAG)

client:
	influx -host $(INFLUX_HOST) -database $(INFLUX_DATABASE) -username $(INFLUX_USERNAME) -password $(INFLUX_PASSWORD) -precision rfc3339

setup_db:
# CREATE RETENTION POLICY month ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 30d
# CREATE RETENTION POLICY year ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 52w
