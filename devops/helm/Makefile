# Helm Makefile for managing applications
# Usage: make <target> APP=<app-name>

# Default app name if not specified
APP ?= backend

# Helm directories
APPS_DIR = apps
CHARTS_DIR = charts
VALUES_FILE = $(APPS_DIR)/$(APP)/values.yaml

# Kubernetes namespace
NAMESPACE ?= default

# Helm release name (defaults to app name)
RELEASE ?= $(APP)

# Show this help message
.PHONY: help
help:
	@echo "Usage: make <target> APP=<app-name> [NAMESPACE=<namespace>]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Template the helm chart without installing
.PHONY: template
template:
	@helm template $(RELEASE) $(CHARTS_DIR)/generic-app \
		-f $(VALUES_FILE) \
		--namespace $(NAMESPACE)

# Install or upgrade the helm chart
.PHONY: install
install:
	@helm upgrade --install $(RELEASE) $(CHARTS_DIR)/generic-app \
		-f $(VALUES_FILE) \
		--namespace $(NAMESPACE) \
		--create-namespace

# Uninstall the helm chart
.PHONY: uninstall
uninstall:
	@helm uninstall $(RELEASE) --namespace $(NAMESPACE)

# Lint the helm chart
.PHONY: lint
lint:
	@helm lint $(CHARTS_DIR)/generic-app -f $(VALUES_FILE)

# Show the status of the helm release
.PHONY: status
status:
	@helm status $(RELEASE) --namespace $(NAMESPACE)
