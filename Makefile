.PHONY: setup outdated style test update-deps
all: style compile test
compile:
	mix compile --warnings-as-errors
style:
	mix format --check-formatted
outdated:
	mix hex.outdated
setup:
	mix deps.get
test:
	mix test
update-deps:
	mix deps.update --all
