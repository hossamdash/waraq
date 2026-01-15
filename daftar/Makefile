.PHONY: help dev build clean serve deploy

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Note: Hugo doesn't support reading .env files directly."
	@echo "Export environment variables before running commands:"
	@echo "  export \$$(cat .env | xargs)"

PORT ?= 1313
BASE_URL ?= http://localhost:$(PORT)/
HUGO_PARAMS_API_URL ?= http://localhost:8081/api/v1
dev: ## Start Hugo development server with drafts
	hugo server -D -p $(PORT) -b $(BASE_URL)

serve: ## Start Hugo development server
	hugo server -p $(PORT) -b $(BASE_URL)

clean: ## Remove generated files
	rm -rf public resources

build: clean ## Clean and build for production
	hugo --gc --minify -b $(BASE_URL)

# deploy: build ## Build and deploy (customize based on your deployment method)
# 	@echo "Build complete. Deploy the 'public' folder to your hosting provider."
