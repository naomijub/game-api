.PHONY: run
run: stop
	 docker-compose up web

.PHONY: setup
setup:
	mix deps.get && mix deps.compile && mix compile

.PHONY: lint
lint: format
	mix credo --strict

.PHONY: format
format:
	mix format

.PHONY: deps-outdated
deps-outdated:
	mix hex.outdated

.PHONY: dialyzer
dialyzer:
	 mix dialyzer --format dialyxir

.PHONY: test
test: stop
	docker-compose up test

.PHONY: stop
stop:
	docker-compose stop
