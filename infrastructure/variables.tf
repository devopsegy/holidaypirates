# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "kimo/holidaypirates_task"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "dynamodb_table_name" {
  description = "Daynamodb_table_name"
  default     = "hello_name"
}

variable "hash_key" {
  default = "first_name"
}

variable "attributes" {
  default = [
        {
            name = "first_name",
            type = "S"
        }
    ]
}
