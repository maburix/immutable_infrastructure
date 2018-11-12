all: create-packer-infra packer-build create-hello-infra

packer-build:
	#$(MAKE) -C packer packer-build
	packer build packer/hello.json

create-packer-infra:
	$(MAKE) -C terraform/tf_dev create-packer-infra


destroy-packer-infra:
	$(MAKE)  -C terraform/tf_dev destroy-packer-infra


create-hello-infra:
	$(MAKE)  -C terraform/tf_prod create-hello-infra


destroy-hello-infra:
	$(MAKE) -C terraform/tf_prod destroy-hello-infra

destroy-all: destroy-hello-infra destroy-packer-infra

ansible-test:
	cd ansible && molecule test
