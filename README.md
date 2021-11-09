## Using Terraform to provision ECS to manage containers (docker)
Using Docker as an example to explain containers & images; Docker is a software tool that helps for a single OS to run multiple containers with the help of the container runtime engine. the engine helps allocate system resources through the kernel, which makes running each container seemless as though it was running on its own OS. With docker, you can create an image (an app or code package with all its dependencies). A container then is a running instance of that image.


## You can follow the steps below in order to install the application.

Dependencies:

Docker v19.03.12

Python v3.8.5

AWS cli Tools 

Terraform v0.13.0 AWS CLI

Terraform Cloud Account

## Project Setup

1- Installing AWS cli tools.

You have to install the AWS CLI tools in order to manage your aws account remotly.
Follow the steps in the below link.

[![AWS](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

2- You have to login to your AWS account by the the below command.
```bash
aws configure
```
3- You can follow the link below to install terraform tools.

[![terraform](https://www.terraform.io/downloads.html)](https://www.terraform.io/downloads.html)


4- You have to login to terraform cloud account by the below command.
```bash
terraform login
```


5 - Run the below command to deply the app.
```bash
make create_TF
```
```bash
make build_infr
```
##### Finally, you will have the endpoint, then you can add the endpoint then /hello/

http://myapp-load-balancer-1225161169.us-west-2.elb.amazonaws.com/hello/mohammed
