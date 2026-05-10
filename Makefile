SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

INSTALL_SCRIPT := scripts/install-enhanced.sh
TEST_SCRIPT := scripts/test-install.sh
SECURITY_SCRIPT := scripts/security-check.sh
TMUX_OPEN_URL_SCRIPT := tmux/open-url.sh
SHELL_SCRIPTS := $(INSTALL_SCRIPT) $(TEST_SCRIPT) $(SECURITY_SCRIPT) $(TMUX_OPEN_URL_SCRIPT)
BATS_TESTS := tests/test_dotfiles.bats

.PHONY: help syntax lint security test test-bats check install install-dry install-no-backup quick-install backup brew clean

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"; printf "Available targets:\n"} /^[a-zA-Z0-9_-]+:.*##/ {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

syntax: ## Check shell script syntax
	@echo "Checking shell script syntax..."
	bash -n $(SHELL_SCRIPTS)

lint: syntax ## Run shellcheck when available
	@echo "Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(SHELL_SCRIPTS); \
	else \
		echo "shellcheck not installed; syntax checks passed."; \
		echo "Install with: brew install shellcheck"; \
	fi

security: ## Run security checks
	@echo "Running security checks..."
	bash $(SECURITY_SCRIPT)

test: syntax ## Run safe install behavior tests
	@echo "Running installation tests..."
	bash $(TEST_SCRIPT)

test-bats: ## Run Bats test suite when bats is available
	@echo "Running Bats tests..."
	@if command -v bats >/dev/null 2>&1; then \
		bats $(BATS_TESTS); \
	else \
		echo "bats not installed; skipping $(BATS_TESTS)."; \
		echo "Install with: brew install bats-core"; \
	fi

check: lint security test test-bats ## Run all quality checks
	@echo "All quality checks completed!"

install-dry: ## Preview install without modifying your home directory
	@echo "Dry run installation..."
	bash $(INSTALL_SCRIPT) --dry-run --verbose

install: ## Install dotfiles with backup and verbose output
	@echo "Installing dotfiles..."
	bash $(INSTALL_SCRIPT) --backup --verbose

install-no-backup: ## Install only if no existing targets need backup
	@echo "Installing dotfiles without backup..."
	bash $(INSTALL_SCRIPT) --no-backup --verbose

quick-install: check install ## Run checks, then install
	@echo "Quick installation completed!"

backup: install-dry ## Preview files that would be backed up during install

brew: ## Install Homebrew-managed tools
	brew bundle --file=Brewfile

clean: ## Remove local test artifacts
	@echo "Cleaning test artifacts..."
	rm -rf /tmp/dotfiles-test-* /tmp/dotfiles-bats-* /tmp/test-home
