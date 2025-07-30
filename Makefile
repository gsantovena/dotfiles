.PHONY: help test lint security install install-dry backup clean

# Default target
help:
	@echo "Available targets:"
	@echo "  test          - Run all tests"
	@echo "  lint          - Run shell script linting"
	@echo "  security      - Run security checks"
	@echo "  install       - Install dotfiles (with backup)"
	@echo "  install-dry   - Dry run installation"
	@echo "  backup        - Create backup of current configs"
	@echo "  clean         - Clean test artifacts"
	@echo "  help          - Show this help message"

# Run all tests
test:
	@echo "Running dotfiles tests..."
	bash scripts/test-install.sh

# Run shell script linting
lint:
	@echo "Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		find . -name "*.sh" -type f -exec shellcheck {} \; ; \
	else \
		echo "shellcheck not installed. Install with: brew install shellcheck (macOS) or apt install shellcheck (Ubuntu)"; \
	fi

# Run security checks
security:
	@echo "Running security checks..."
	bash scripts/security-check.sh

# Install dotfiles with enhanced script
install:
	@echo "Installing dotfiles..."
	bash scripts/install-enhanced.sh --backup --verbose

# Dry run installation
install-dry:
	@echo "Dry run installation..."
	bash scripts/install-enhanced.sh --dry-run --verbose

# Create backup only
backup:
	@echo "Creating backup..."
	bash scripts/install-enhanced.sh --dry-run --backup

# Clean test artifacts
clean:
	@echo "Cleaning test artifacts..."
	rm -rf /tmp/dotfiles-test-*
	rm -rf /tmp/test-home

# Run all quality checks
check: lint security test
	@echo "All quality checks completed!"

# Quick setup for new systems
quick-install: check install
	@echo "Quick installation completed!"