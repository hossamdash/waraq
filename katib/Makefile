.PHONY: help build run test clean

help:
	@echo "Available targets:"
	@echo "  build  - Build the Katib binary"
	@echo "  run    - Run Katib"
	@echo "  test   - Run tests"
	@echo "  clean  - Clean build artifacts and test cache"

build:
	@echo "Building Katib..."
	go build -o bin/katib .

run: build
	@echo "Running Katib..."
	./bin/katib

test:
	@echo "Running Katib tests..."
	go test -v ./tests/

clean:
	@echo "Cleaning..."
	rm -rf bin/
	go clean -testcache
