SHELL=/bin/bash

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

TIMESTAMP := $(shell TZ=UTC date +%Y%m%d-%H%M)
export TAG ?= $(TIMESTAMP)

## load new data
fetch:
	scripts/sincedb-entsoe-generation.rb
	scripts/sincedb-entsoe-load.rb
	scripts/sincedb-elexon-generation.rb
	scripts/sincedb-elexon-load.rb

fetch2:
	. ./.env-production ; scripts/sincedb-entsoe-generation.rb
	. ./.env-production ; scripts/sincedb-entsoe-load.rb
	. ./.env-production ; scripts/sincedb-elexon-generation.rb
	. ./.env-production ; scripts/sincedb-elexon-load.rb

BRANCH ?= master
## Update jenkins/intermittency-$(BRANCH) secret from .env
update_secret:
	grep -v export .env | kubectl create secret generic -n jenkins intermittency-$(BRANCH) --from-env-file=/dev/stdin --dry-run=true -o yaml | kubectl apply -f -

## Update jenkins/intermittency-production secret from .env-production
update_secret2:
	grep -v export .env-production | kubectl create secret generic -n jenkins intermittency-production --from-env-file=/dev/stdin --dry-run=true -o yaml | kubectl apply -f -
psql:
	psql postgres
psql2:
	psql intermittency_prod

## Dump db to intermittency.bak
pgdump:
	pg_dump -Fc -f intermittency.bak postgres

TARGETDB=intermittency_prod
## Restore db to intermittency_prod and drop telegraf schema
pgrestore:
	psql $(TARGETDB) -c "ALTER EXTENSION timescaledb UPDATE;"
	psql $(TARGETDB) -c "SELECT timescaledb_pre_restore();"
	pg_restore -Fc -d $(TARGETDB) intermittency.bak
	psql $(TARGETDB) -c "SELECT timescaledb_post_restore();"
	psql $(TARGETDB) -c "DROP SCHEMA telegraf CASCADE;"
	psql $(TARGETDB) -c "DELETE FROM prices WHERE area_id IN (SELECT id FROM areas WHERE source='nordpool_sek');"
	psql $(TARGETDB) -c "DELETE FROM areas WHERE source='nordpool_sek';"

dropdb2:
	dropdb --force intermittency
createdb2:
	createdb intermittency

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
