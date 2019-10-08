# @author Laurent Krishnathas
# @year 2019

# Uncomment make_init first, run it to get the files, then uncomment all the include to get all the common makefiles
MAKE_FILE_DIR=../../../../makefile
include $(MAKE_FILE_DIR)/common.mk


VARS:=$(VARS)

NAME=$(shell jq -r '.name.value+"-"+.environment.value'< $(TERRAFORM_OUPUT))

debug:
	@echo "NAME = $(NAME)"


#WARNING slow due to terraform, take 2s per call to terraform output
#ssh_sample_via_terraform_output:
#	ssh ec2-user@$(shell terraform output ec2_public_ip) -i ~/.ssh/$(shell terraform output key_name).pem


#//TODO check for git ignore
#//TODO check for docker ignore


