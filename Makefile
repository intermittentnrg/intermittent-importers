ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: backup
backup:
	rm -rf backup
	influxd backup -portable -host $(INFLUXDB_HOST):8088 -database $(INFLUXDB_DATABASE) backup

docker_restore:
	docker-compose down
	rm -rf docker/data
	docker-compose up -d influxdb
	docker-compose exec influxdb influxd restore -portable -host localhost:8088 /backup
	docker-compose exec influxdb influx -host localhost -database intermittency -execute "CREATE USER grafana WITH PASSWORD 'grafana'"
	docker-compose exec influxdb influx -host localhost -database intermittency -execute "GRANT READ ON intermittency TO grafana"
	docker-compose down
	sudo chmod -R a+rwX docker/data/

docker_build:
#	docker-compose build influxdb-preloaded
	cd docker && docker buildx build --platform=linux/arm64 -f Dockerfile.influxdb-preloaded \
		--build-arg INFLUXDB_VERSION \
		-t $(DOCKER_REGISTRY)/influxdb-preloaded:latest -o type=registry \
		.

client:
	influx -host $(INFLUXDB_HOST) -database $(INFLUXDB_DATABASE) -username $(INFLUXDB_USERNAME) -password $(INFLUXDB_PASSWORD) -precision rfc3339

setup_db:
# CREATE RETENTION POLICY month ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 30d
# CREATE RETENTION POLICY year ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 52w
