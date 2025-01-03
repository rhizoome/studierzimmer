TS_FILES := $(shell find src -type f -name '*.ts')

.PHONY: all
all: node_modules \
		build/index.html \
		build/style.css
	rsync -a static/ build/

node_modules:
	npm ci

build/index.html: src/index.html | \
		build/main.js
	cp $< $@

temp/studierzimmer.json: studierzimmer.ink
	npx inkjs $< -o $@

build/style.css: src/style.css
	cp $< $@

build/main.js: $(TS_FILES) \
		temp/studierzimmer.json
	npx webpack
	cp dist/main.js* build/

.PHONY: clean
clean:
	rm -rf build/* temp/* dist/* node_modules
