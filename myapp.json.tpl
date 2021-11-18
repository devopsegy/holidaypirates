
[
  {
    "name": "myapp",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/myapp",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  },
  {
    "name": "postgress",
    "image": "${db_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/mydb",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${db_port}
      }
    ],
    "environment": [
        {
          "name": "POSTGRES_USER",
          "value": "hello_user"
        },
        {
          "name": "POSTGRES_PASSWORD",
          "value": "edrJHf1eqeQ"
        },
        {
          "name": "POSTGRES_DB",
          "value": "hello_db"
        }
    ]
  }
]
