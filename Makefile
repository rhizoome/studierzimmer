TS_FILES := $(shell find src -type f -name '*.ts')
DIR := $(shell pwd)

.PHONY: all
all: \
		build/main.js \
		build/attribution.html \
		README.md
	rsync -a static/ build/

node_modules:
	npm ci

attribution_cli:
	cd src/attribution/ && poetry install --without dev,lsp

attribution.json: | attribution_cli
	cd src/attribution/ && poetry run attribution_cli read $(DIR)/static $(DIR)/attribution.json

build/attribution.html: attribution.json | attribution_cli
	cd src/attribution/ && poetry run attribution_cli template $(DIR)/templates attribution.html $(DIR)/attribution.json $(DIR)/build/attribution.html

README.md: attribution.json | attribution_cli
	cd src/attribution/ && poetry run attribution_cli template $(DIR)/templates README.md $(DIR)/attribution.json $(DIR)/README.md

temp/studierzimmer.json: studierzimmer.ink | node_modules
	npx inkjs $< -o $@

build/main.js: $(TS_FILES) \
		temp/studierzimmer.json \
		| node_modules
	npx webpack
	cp dist/main.js* build/

.PHONY: clean
clean:
	rm -rf build/* temp/* dist/* node_modules

.PHONY: clean_all
clean_all:
	rm -rf build/* temp/* dist/* README.md attribution.json node_modules
