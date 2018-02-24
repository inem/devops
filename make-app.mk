USER = "$(shell id -u):$(shell id -g)"

app:
	docker-compose up

app-build:
	docker-compose build

app-bash:
	docker-compose run --user=$(USER) app bash

app-setup: development-setup-env app-build
	docker-compose run app bin/setup

test:
	docker-compose run --user=$(USER) app bin/rails test