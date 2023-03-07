# Define variables
DOCKER_IMAGE_NAME := #insert your desired image name for local dev here
DOCKER_CONTAINER_NAME := #insert your desired container name for local dev here
EC2_INSTANCE := #insert ec2 instance IPv4 Public IP here
KEY_PEM_PATH := #insert your desired path to your key.pem file here

.PHONY: build run clean

# Build the Docker image
build:
	docker build -t $(DOCKER_IMAGE_NAME) .

# Run the Docker container
run:
	docker run -d --name $(DOCKER_CONTAINER_NAME) -p 8080:8080 $(DOCKER_IMAGE_NAME)

# Clean up the Docker container and image
clean:
	docker stop $(DOCKER_CONTAINER_NAME) || true
	docker rm $(DOCKER_CONTAINER_NAME) || true
	docker rmi $(DOCKER_IMAGE_NAME) || true

#ssh into the ec2 instance
ssh:
	ssh -i $(KEY_PEM_PATH) ec2-user@$(EC2_INSTANCE)

# Initialize Terraform
init:
	terraform init

# Plan the infrastructure changes to be made
plan:
	terraform plan

# Apply the infrastructure changes
apply: plan
	terraform apply

# Destroy the infrastructure
destroy:
	terraform destroy
