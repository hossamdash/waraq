.PHONY: help dev build clean serve deploy

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

PORT ?= 1313

dev: ## Start Hugo development server with drafts
	hugo server -D -p $(PORT)

serve: ## Start Hugo development server
	hugo server -p $(PORT)

clean: ## Remove generated files
	rm -rf public resources

build: clean ## Clean and build for production
	hugo --gc --minify

# deploy: build ## Build and deploy (customize based on your deployment method)
# 	@echo "Build complete. Deploy the 'public' folder to your hosting provider."
