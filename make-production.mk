production-setup:
	ansible-playbook ansible/site.yml -i ansible/production -u ubuntu -vv --ask-vault-pass

production-deploy:
	ansible-playbook ansible/deploy.yml -i ansible/production -u ubuntu -vv

docker-image-build:
	docker build -t inemation/workshop-devops-app:v$(V) -f services/app/Dockerfile.production services/app

docker-image-push:
	docker push inemation/workshop-devops-app:v$(V)

docker-image-run:
	docker run -it inemation/workshop-devops-app:v$(V) bash