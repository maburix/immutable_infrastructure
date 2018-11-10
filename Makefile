all: create-packer-infra packer-build create-hello-infra

packer-build: create-packer-infra
	AWS_SUBNET_ID=$(shell cd packer && terraform output subnet-id) && echo $$AWS_SUBNET_ID && \
	packer build -var aws_subnet_id=$$AWS_SUBNET_ID packer/hello.json

create-packer-infra:
	$(MAKE) -C packer create-packer-infra


destroy-packer-infra:
	$(MAKE)  -C packer destroy-packer-infra

create-hello-infra:
	$(MAKE)  -C tf_app create-hello-infra



destroy-hello-infra:
	$(MAKE) -C tf_app destroy-hello-infra