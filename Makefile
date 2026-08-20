SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help install setup update validate all

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Install Homebrew, command-line tools, and Zinit
	./install.sh all

setup: ## Configure everything; conflicting files are backed up
	./setup.sh --yes all

update: ## Pull latest dotfiles and re-apply
	git pull --rebase
	$(MAKE) setup

validate: ## Run syntax checks and linters
	./validate.sh

all: install setup validate ## Install everything and validate
