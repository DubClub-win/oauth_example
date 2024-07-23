SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := help
.PHONY: help
help: ## Display this help section
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z\$$/]+.*:.*?##\s/ {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: static
static: ## Install depenedencies
	python example/manage.py collectstatic --no-input

.PHONY: migrate
migrate: ## Install depenedencies
	python example/manage.py migrate

.PHONY: run
run: ## Install depenedencies
	python example/manage.py runserver
