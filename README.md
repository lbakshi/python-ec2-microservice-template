# Python EC2 Flask Microservice Template

Template repo for quickly spinning up microservices with github workflows & terraform setup. Deploys a container to ECR as well as a t2.micro EC2 instance with docker installed. Exposes a singular endpoint on port 8080.

Assuming everything is setup correctly, on merge to main, the workflow will deploy the new container to ECR and make the EC2 instance pull the new image.

## Requirements
- Make
- Terraform
- Docker

## Usage
- In AWS
    - Create a Access Key Pair by going to AWS > Profile Menu in the top right > Security Credentials > Scroll down to access keys > Create Key
        - This creates an access key you will need for both AWS cli (e.g. terraform deploys) and for github workflows to change AWS resources. Store this value and use it for aws cli config.
    - Create a Key Pair in EC2 with the name ```[your project name]-test-key```. This creates a ssh key pair that will be used both by you to access your ec2 instance and by terraform to give access.
        - Follow [these instructions](https://sudoedit.com/convert-a-pem-to-rsa-key/) to parse the RSA key value from the downloaded ```.pem``` file and store it into your machine. You'll need the decoded value for your github workflows.
- In ```variable.tf```
    - Define
        - ```instance_key``` should be the ```[your project name]-test-key```, mapping to the key pair for EC2
        - ```project_name``` will be the prefix on most of the specific resources (security groups, instances, etc) 
        - ```region``` if you don't want to be in Oregon :(
- Run ```make apply``` to deploy the ec2 terraform
- In your github repo settings, setup
    - Environmental Variables
        - ```Instance ID```. Now that you've deployed the terraform resources, this value should be retrievable in the AWS EC2 UI, and generally begins by ```i-.....```.
        - ```AWS_ACCESS_KEY_ID```. Key from your access key created in AWS earlier.
        - ```AWS_SECRET_ACCESS_KEY```. Secret value from your access key created in AWS earlier.
        - ```SSH_PRIVATE_KEY```. From the decoded pem file, include the lines ```----BEGIN RSA KEY.....END RSA KEY-----```.
- Change ```Makefile```
    - Update all of the variables for docker 
- Change ```.github/workflows/build_and_deploy.yaml```
    - Change ```env.IMAGE-NAME``` to your desired image name. This is unrelated to whatever name you use for the makefile
- Change your code and merge to main. This will automatically deploy your code to a new container and run it in your ec2 instance. To hit your server, get your ec2 instance's Public IPv4 and curl that address as ```[your host name]:8080/api/hello```

## IaC to add
- Run on EKS instead
- Add endpoint & api key guards
- Load balancer and more narrow port range
