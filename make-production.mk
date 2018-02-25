production-setup:
	ansible-playbook ansible/site.yml -i ansible/production -u ubuntu -vv

production-deploy:
	ansible-playbook ansible/deploy.yml -i ansible/production -u ubuntu -vv
