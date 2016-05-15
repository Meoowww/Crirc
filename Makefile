all:
	crystal build -s src/CrystalIrc.cr

doc:
	crystal docs

test:
	crystal spec

clean:
	rm -fv CrystalIrc

.PHONY: all doc test clean
