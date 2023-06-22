SHELL=/bin/sh

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
	pg_dump --clean --no-privileges -Fc -f intermittency.bak $(DUMPARGS) postgres

TARGETDB=intermittency_prod_new
.ONESHELL:
createdb_copy:
	psql <<EOF
	SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity
	WHERE pg_stat_activity.datname = 'postgres' AND pid <> pg_backend_pid();

	CREATE DATABASE $(TARGETDB) WITH TEMPLATE postgres OWNER postgres;
	EOF

## Restore db to $TARGETDB (intermittency_prod)
pgrestore: pgrestore_import pgrestore_clean
pgrestore_import:
	createdb $(TARGETDB)
	psql $(TARGETDB) -c "ALTER EXTENSION timescaledb UPDATE;"
	psql $(TARGETDB) -c "SELECT timescaledb_pre_restore();"
	pg_restore --clean -Fc -d $(TARGETDB) intermittency.bak
	psql $(TARGETDB) -c "SELECT timescaledb_post_restore();"

.ONESHELL:
## Clean $TARGETDB (intermittency_prod)
pgrestore_clean:
	psql $(TARGETDB) <<EOF
	DROP SCHEMA IF EXISTS telegraf CASCADE;
	DROP SCHEMA IF EXISTS ellevio CASCADE;
	DELETE FROM prices WHERE area_id IN (SELECT id FROM areas WHERE source='nordpool_sek');
	DELETE FROM areas WHERE source='nordpool_sek';

	ALTER DATABASE intermittency_prod SET search_path TO intermittency, public;

	GRANT CONNECT ON DATABASE intermittency_prod TO intermittency_prod;

	GRANT USAGE ON SCHEMA intermittency TO PUBLIC;

	GRANT SELECT ON TABLE intermittency.areas TO intermittency_prod;
	GRANT SELECT ON TABLE intermittency.generation TO intermittency_prod;
	GRANT SELECT ON TABLE intermittency.load TO intermittency_prod;
	GRANT SELECT ON TABLE intermittency.prices TO intermittency_prod;
	GRANT SELECT ON TABLE intermittency.production_types TO intermittency_prod;
	GRANT SELECT ON TABLE intermittency.transmission TO intermittency_prod;

	EOF

.ONESHELL:
## Rename intermittency_prod to _prod_old and swap in $(TARGETDB)
pgrestore_swap:
	psql --single-transaction <<EOF
	ALTER DATABASE intermittency_prod RENAME TO intermittency_prod_old;
	ALTER DATABASE $(TARGETDB) RENAME TO intermittency_prod;
	SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'intermittency_prod';
	EOF

pgrestore_deleteold:
	dropdb intermittency_prod_old

#GRANTS for intermittency_prod
#ALTER DATABASE intermittency_prod SET search_path = intermittency, public;

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
