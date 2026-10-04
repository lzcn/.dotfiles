SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

# Make tools installed during installation available to subsequent steps.
export PATH := $(HOME)/.local/bin:$(if $(HOMEBREW_PREFIX),$(HOMEBREW_PREFIX)/bin:)/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:$(HOME)/.linuxbrew/bin:/usr/local/bin:$(PATH)

.PHONY: help install setup update check

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "%-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies, apply configuration, and check
	@./install.sh
	@$(MAKE) --no-print-directory setup
	@$(MAKE) --no-print-directory check

setup: ## Apply configuration; back up conflicts
	@./setup.sh --yes

update: ## Update configuration Git repos (use dots-update all for software/plugins)
	@./bin/dots-update

check: ## Check shell syntax, lint, and configuration
	@printf '\n› Configuration checks\n'
	@bash -n install.sh
	@bash -n setup.sh
	@for file in bin/*; do \
		if [[ ! -f "$$file" ]]; then continue; fi; \
		if LC_ALL=C grep -Iq '^#!.*zsh' "$$file"; then zsh -n "$$file" || exit; \
		elif LC_ALL=C grep -Iq '^#!.*bash' "$$file"; then bash -n "$$file" || exit; fi; \
	done
	@python3 -B -c 'import ast, pathlib; [ast.parse(p.read_text(), filename=str(p)) for p in pathlib.Path("bin").iterdir() if p.is_file() and (p.suffix == ".py" or p.read_bytes().startswith(b"#!/usr/bin/env python3"))]'
	@zsh -n zsh/.zshrc
	@zsh -n zsh/.p10k.zsh
	@if command -v shellcheck >/dev/null; then shellcheck -x install.sh setup.sh bin/lib.sh; fi
	@git config --file git/.gitconfig --list >/dev/null
	@if command -v brew >/dev/null; then HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --file Brewfile >/dev/null; fi
	@if command -v markdownlint >/dev/null; then markdownlint README.md; fi

	@printf '  ✓ Configuration checks passed\n'
