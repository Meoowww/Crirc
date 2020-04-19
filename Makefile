all: deps_opt test

test:
	crystal spec
deps:
	shards install
deps_opt:
	@[ -d lib/ ] || make deps
doc:
	crystal docs
clean:
	rm $(NAME)

.PHONY: all run build release test deps deps_update clean doc
