.PHONY: help deploy-all commit-all build clean

.DEFAULT_GOAL := help

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

deploy-all: ## Deploy all sub-modules
	bash scripts/deploy-all.sh $(filter-out $@,$(MAKECMDGOALS))

commit-all: ## Commit changes across all sub-modules
	bash scripts/commit-all.sh $(filter-out $@,$(MAKECMDGOALS))

build: ## Run build in each sub-module
	@echo "Run build in each sub-module: make -C <module> build"

clean: ## Run clean in each sub-module
	@echo "Run clean in each sub-module: make -C <module> clean"

%:
	@:
