ansible-vaults-encrypt:
	ansible-vault encrypt ansible/production/group_vars/all/vault.yml
	ansible-vault encrypt ansible/development/group_vars/all/vault.yml
	ansible-vault encrypt ansible/group_vars/all/vault.yml

ansible-vaults-decrypt:
	ansible-vault decrypt ansible/production/group_vars/all/vault.yml --ask-vault-pass
	ansible-vault decrypt ansible/development/group_vars/all/vault.yml --ask-vault-pass
	ansible-vault decrypt ansible/group_vars/all/vault.yml --ask-vault-pass

ansible-deps-install:
	ansible-galaxy install -r requirements.yml