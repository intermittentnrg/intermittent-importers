ifneq (,$(wildcard ./.env))
    include .env
    export
endif

TIMESTAMP := $(shell TZ=UTC date +%Y%m%d-%H%M)
export TAG ?= $(TIMESTAMP)

## load new data
fetch:
	scripts/sincedb-generation.rb
	scripts/sincedb-load.rb

## update secret from .env
update_secret:
	kubectl create secret generic -n jenkins intermittency --from-env-file=.env --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic -n intermittency intermittency --from-env-file=.env --dry-run=true -o yaml | kubectl apply -f -

psql:
	psql intermittency

pgdump:
	pg_dump -Fc -f intermittency.bak intermittency

psql2:
	psql intermittency
dropdb2:
	dropdb --force intermittency
createdb2:
	createdb intermittency
pgrestore:
	pg_restore -d intermittency intermittency.bak

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
