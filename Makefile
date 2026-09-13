SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

# Make tools installed earlier in `make all` available to subsequent steps.
export PATH := $(HOME)/.local/bin:$(if $(HOMEBREW_PREFIX),$(HOMEBREW_PREFIX)/bin:)/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:$(HOME)/.linuxbrew/bin:/usr/local/bin:$(PATH)

COMPONENTS := zsh nvim tmux kitty git atuin swift

.PHONY: help all install setup update check validate $(COMPONENTS)

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "%-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf '\nComponents: $(COMPONENTS) (e.g. make zsh)\n'

all: ## Install, configure, and check everything
	@$(MAKE) --no-print-directory install
	@$(MAKE) --no-print-directory setup
	@$(MAKE) --no-print-directory check

install: ## Install Homebrew packages and Zinit
	@./install.sh all

setup: ## Configure all components; back up conflicting files
	@./setup.sh --yes all

$(COMPONENTS):
	@./setup.sh --yes $@

update: ## Update software, plugins, and dotfiles (no setup or compilation)
	@zsh ./bin/dots-update --all

check: ## Check shell syntax, lint, and configuration
	@printf '\n› Configuration checks\n'
	@bash -n install.sh
	@bash -n setup.sh
	@for file in bin/*; do \
		if LC_ALL=C grep -Iq '^#!.*zsh' "$$file"; then zsh -n "$$file" || exit; \
		elif LC_ALL=C grep -Iq '^#!.*bash' "$$file"; then bash -n "$$file" || exit; fi; \
	done
	@zsh -n zsh/.zshrc
	@zsh -n zsh/.p10k.zsh
	@if command -v shellcheck >/dev/null; then shellcheck -x install.sh setup.sh bin/lib.sh; fi
	@git config --file git/.gitconfig --list >/dev/null
	@if command -v brew >/dev/null; then HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --file Brewfile >/dev/null; fi
	@if command -v markdownlint >/dev/null; then markdownlint README.md; fi

	@printf '  ✓ Configuration checks passed\n'

validate: check
