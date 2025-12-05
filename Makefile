# Makefile - Generic build commands wrapping npm scripts
#
# This Makefile provides a standard interface for common development tasks.
# All targets delegate to npm scripts defined in package.json.
#
# Usage:
#   make setup    - Install dependencies
#   make lint     - Run linters
#   make format   - Format code
#   make test     - Run tests with coverage
#   make ci       - Run full CI pipeline locally
#   make clean    - Remove generated files
#   make help     - Show this help message

.PHONY: help setup install build build-watch lint lint-fix format format-check test test-watch test-coverage ci clean devcontainer-build devcontainer-rebuild devcontainer-up devcontainer-reup devcontainer-bash

# Default target
.DEFAULT_GOAL := help

## help: Show this help message
help:
	@echo "Available targets:"
	@echo ""
	@echo "  setup          - Install dependencies (npm ci)"
	@echo "  install        - Install dependencies (alias for setup)"
	@echo "  build          - Build TypeScript code"
	@echo "  build-watch    - Build TypeScript code in watch mode"
	@echo "  lint           - Run ESLint"
	@echo "  lint-fix       - Run ESLint with --fix"
	@echo "  format         - Format code with Prettier"
	@echo "  format-check   - Check code formatting"
	@echo "  test           - Run tests with coverage"
	@echo "  test-watch     - Run tests in watch mode"
	@echo "  test-coverage  - Run tests and generate coverage report"
	@echo "  ci             - Run full CI pipeline (lint + format-check + test)"
	@echo "  clean          - Remove node_modules and coverage"
	@echo ""
	@echo "  Devcontainer targets:"
	@echo "  devcontainer-build     - Build devcontainer"
	@echo "  devcontainer-rebuild   - Rebuild devcontainer (--no-cache)"
	@echo "  devcontainer-up        - Start devcontainer"
	@echo "  devcontainer-reup      - Restart devcontainer (--remove-existing-container)"
	@echo "  devcontainer-bash      - Open bash in devcontainer"
	@echo ""

## setup: Install dependencies
setup:
	npm ci

## install: Install dependencies (alias for setup)
install: setup

## build: Build TypeScript code
build:
	npm run build

## build-watch: Build TypeScript code in watch mode
build-watch:
	npm run build:watch

## lint: Run ESLint
lint:
	npm run lint

## lint-fix: Run ESLint with --fix
lint-fix:
	npm run lint:fix

## format: Format code with Prettier
format:
	npm run format

## format-check: Check code formatting
format-check:
	npm run format:check

## test: Run tests with coverage
test:
	npm test

## test-watch: Run tests in watch mode
test-watch:
	npm run test:watch

## test-coverage: Run tests and generate coverage report
test-coverage:
	npm run test:coverage

## ci: Run full CI pipeline (lint + format-check + test)
ci:
	npm run ci

## clean: Remove node_modules and coverage
clean:
	npm run clean

## devcontainer-build: Build devcontainer
devcontainer-build:
	npm run devcontainer:build

## devcontainer-rebuild: Rebuild devcontainer (--no-cache)
devcontainer-rebuild:
	npm run devcontainer:rebuild

## devcontainer-up: Start devcontainer
devcontainer-up:
	npm run devcontainer:up

## devcontainer-reup: Restart devcontainer (--remove-existing-container)
devcontainer-reup:
	npm run devcontainer:reup

## devcontainer-bash: Open bash in devcontainer
devcontainer-bash:
	npm run devcontainer:bash
