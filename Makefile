all: build

build:
	crystal build -s src/CrystalIrc.cr

release:
		crystal build --release src/CrystalIrc.cr

doc:
	crystal docs

test:
	crystal spec

# useless, no dependancies
deps:
	shards

# useless, no dependancies
deps_opt:
	[ -d libs/ ] || make deps

clean:
	rm -v CrystalIrc

.PHONY: all doc test clean build release deps deps_opt
