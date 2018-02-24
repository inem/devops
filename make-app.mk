USER = "$(shell id -u):$(shell id -g)"

app:
	docker-compose up

app-build:
	docker-compose build

app-bash:
	docker-compose run --user=$(USER) app bash

# app-setup: app-build
# 	docker-compose run --user=$(USER) app bin/setup

development-setup-env:
	ansible-playbook ansible/development.yml -i ansible/development -vv

app-setup: development-setup-env app-build
	docker-compose run app bin/setup

ansible-vaults-encrypt:
	ansible-vault encrypt ansible/development/group_vars/all/vault.yml
	ansible-vault encrypt ansible/group_vars/all/vault.yml

ansible-vaults-decrypt:
	ansible-vault decrypt ansible/development/group_vars/all/vault.yml
	ansible-vault decrypt ansible/group_vars/all/vault.yml