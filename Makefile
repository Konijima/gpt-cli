# === Virtual Environment ===
venv: ## Create virtualenv and install in editable mode with dev dependencies
	python3 -m venv .venv && .venv/bin/pip install -e ".[dev]"

# === Formatting ===
fmt: ## Run Ruff to auto-fix lint issues
	ruff check core gpt.py --fix

format: ## Run autopep8 aggressive formatting
	autopep8 --in-place --aggressive --aggressive gpt.py core/*.py

# === Clean, Build, Publish ===
clean: ## Remove build artifacts
	rm -rf dist build *.egg-info

build: clean ## Build sdist and wheel into dist/
	python -m build

lint: ## Run Pylint on main entrypoint and core
	pylint core gpt.py

test: ## Run pytest on the tests/ directory
	pytest tests

check: lint test build ## Lint, test, build, and validate distributions
	twine check dist/*

publish: check ## Run all checks then upload to PyPI
	twine upload dist/*

inspect: ## List contents of built source distribution tar.gz
	tar -tzf dist/*.tar.gz

# === Help ===
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
