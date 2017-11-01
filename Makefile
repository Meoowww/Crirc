all: deps_opt test

test:
	crystal spec
deps:
	crystal deps install
deps_update:
	crystal deps update
deps_opt:
	@[ -d lib/ ] || make deps
doc:
	crystal docs
clean:
	rm $(NAME)

.PHONY: all run build release test deps deps_update clean doc
