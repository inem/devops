ansible-vaults-encrypt:
	ansible-vault encrypt ansible/production/group_vars/all/vault.yml ansible/development/group_vars/all/vault.yml ansible/group_vars/all/vault.yml

ansible-vaults-decrypt:
	ansible-vault decrypt ansible/production/group_vars/all/vault.yml ansible/development/group_vars/all/vault.yml ansible/group_vars/all/vault.yml --ask-vault-pass

ansible-deps-install:
	ansible-galaxy install -r requirements.yml