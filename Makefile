ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: backup
backup:
	mkdir -p backup
	influxd backup -host $(INFLUXDB_HOST):8088 -db $(INFLUXDB_DATABASE) \
		-portable backup/"$(date +%Y%m%d%H%M%S)"

docker_backup:
	docker build -t intermittency:latest -f Dockerfile.influx-restore .

client:
	influx -host $(INFLUXDB_HOST) -database $(INFLUXDB_DATABASE) -username $(INFLUXDB_USERNAME) -password $(INFLUXDB_PASSWORD) -precision rfc3339

setup_db:
# CREATE RETENTION POLICY month ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 30d
# CREATE RETENTION POLICY year ON intermittency DURATION 0s REPLICATION 1 SHARD DURATION 52w
