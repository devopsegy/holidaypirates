Terraform-AWS-ECS

Terraform modules for creating a production ready ECS Cluster in AWS.

Features:
Amazon Elastic Compute Cloud (ECS) 
High-availability (Multi-AZ)
Loadbalanced (ALB)
Isolated in a VPC
Private -> Public access (NAT'd)
Auto-scaling


ECS infra

As stated above, ECS needs EC2 instances that are used to run Docker containers on. To do so you need infrastructure for this. Here is an ECS production-ready infrastructure diagram.

What are we creating:

VPC with a /16 ip address range and an internet gateway
We are choosing a region and a number of availability zones we want to use. For high-availability we need at least two
In every availability zone we are creating a private and a public subnet with a /24 ip address range
Public subnet convention is 10.x.0.x and 10.x.1.x etc..
Private subnet convention is 10.x.50.x and 10.x.51.x etc..
In the public subnet we place a NAT gateway and the LoadBalancer
The private subnets are used in the autoscale group which places instances in them
We create an ECS cluster where the instances connect to

Must know
SSH access to the instances
You should not put your ECS instances directly on the internet. You should not allow SSH access to the instances directly but use a bastion server for that. Having SSH access to the acceptance environment is fine but you should not allow SSH access to production instances. You don't want to make any manual changes in the production environment.

This ECS module allows you to use an AWS SSH key to be able to access the instances, for quick usage purposes the ecs.tf creates a new AWS SSH key. The private key can be found in the root of this repository with the name 'ecs_fake_private'.

For a new method see issue #1.

ECS configuration
ECS is configured using the /etc/ecs/ecs.config file as you can see here. There are two important configurations in this file. One is the ECS cluster name so that it can connect to the cluster, this should be specified from terraform because you want this to be variable. The other one is access to Docker Hub to be able to access private repositories. To do this safely use an S3 bucket that contains the Docker Hub configuration. See the ecs_config variable in the ecs_instances module for an example.

Logging
All the default system logs like Docker or ECS agent should go to CloudWatch as configured in this repository. The ECS container logs can be pushed to CloudWatch as well but it is better to push these logs to a service like ElasticSearch. CloudWatch does support search and alerts but with ElasticSearch or other log services you can use more advanced search and grouping. See issue #5.

The ECS configuration as described here allows configuration of additional Docker log drivers to be configured. For example fluentd as shown in the ecs_logging variable in the ecs_instances module.

Be aware when creating two clusters in one AWS account on CloudWatch log group collision, read the info.

ECS instances
Normally there is only one group of instances like configured in this repository. But it is possible to use the ecs_instances module to add more groups of different type of instances that can be used for different deployments. This makes it possible to have multiple different types of instances with different scaling options.

LoadBalancer
It is possible to use the Application LoadBalancer and the Classic LoadBalancer with this setup. The default configuration is Application LoadBalancer because that makes more sense in combination with ECS. There is also a concept of Internal and External facing LoadBalancer.

Using default
The philosophy is that the modules should provide as much as possible of sane defaults. That way when using the modules it is possible to quickly configure them but still change when needed. That is also why we introduced something like a name 'default' as the default value for some of the components. Another reason behind it is that you don't need to come up with names when you probably might only have one cluster in your environment.

Looking at ecs.tf might give you a different impression, but there we configure more things than needed to show it can be done.

ECS deployment strategies
ECS has a lot of different ways to deploy or place a task in the cluster. You can have different placement strategies like random and binpack, see here for full documentation. Besides the placement strategies, it is also possible to specify constraints, as described here. The constraints allow for a more fine-grained placement of tasks on specific EC2 nodes, like instance type or custom attributes.

What ECS does not have is a possibility to run a task on every EC2 node on boot, that's where System containers and custom boot commands comes into place.

System containers and custom boot commands
In some cases, it is necessary to have a system 'service' running that does a particular task, like gathering metrics. It is possible to add an OS specific service when booting an EC2 node but that means you are not portable. A better option is to have the 'service' run in a container and run the container as a 'service', also called a System container.

ECS has different deployment strategies but it does not have an option to run a system container on every EC2 node on boot. It is possible to do this via ECS workaround or via Docker.

ECS workaround
The ECS workaround is described here Running an Amazon ECS Task on Every Instance. It basically means use a Task definition and a custom boot script to start and register the task in ECS. This is awesome because it allows you to see the system container running in ECS console. The bad thing about it is that it does not restart the container when it crashes. It is possible to create a Lambda to listen to changes/exits of the system container and act on it. For example, start it again on the same EC2 node. See issue #2.

Docker
It is also possible to do the same thing by just running a docker run command on EC2 node on boot. To make sure the container keeps running we tell docker to restart the container on exit. The great thing about this method is that it is simple and you can use the 'errors' that can be caught in CloudWatch to alert when something bad happens.

Note: Both of these methods have one big flaw and that is that you need to change the launch configuration and restart every EC2 node one by one to apply the changes. Most of the time this does not have to be a problem because the system containers don't change that often but is still an issue. It is possible to fix this in a better way with Blox, but this also introduces more complexity. So it is a choice between simplicity and an explicit update flow or advanced usage with more complexity.

Regardless which method you pick you will need to add a custom command on EC2 node on boot. This is already available in the module ecs_instances by using the custom_userdata variable. An example for Docker would look like this:
