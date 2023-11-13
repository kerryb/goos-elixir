.PHONY: setup style test update-deps
all: style compile test
setup:
	mix deps.get
style:
	mix format --check-formatted
compile:
	mix compile --warnings-as-errors
test:
	mix test
outdated:
	mix hex.outdated
update-deps:
	mix deps.update --all
