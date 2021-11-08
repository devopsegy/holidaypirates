DOCKER_REGISTRY     := $(or ${DOCKER_REGISTRY}, "kimo")
APP_NAME            := $(or ${APP_NAME}, holidaypirates_task)
VERSION             := $(shell cat VERSION)
DATABASE_URL	    := postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_SERVER}/${DB_NAME}

# Docker image.
ifeq ($(strip $(DOCKER_REGISTRY)),"")
  IMAGE_NAME_LATEST := ${APP_NAME}
else
  IMAGE_NAME_LATEST := ${DOCKER_REGISTRY}/${APP_NAME}
endif
IMAGE_NAME_TAGGED   := ${IMAGE_NAME_LATEST}:${VERSION}

# Targets.

tag:
	git tag "v${VERSION}" -m "Version ${VERSION}"

tag_push:
	git push --tags

image_build:
	docker build -t ${IMAGE_NAME_LATEST} -t ${IMAGE_NAME_TAGGED} .

image_push:
	docker push ${IMAGE_NAME_LATEST}
	docker push ${IMAGE_NAME_TAGGED}

create_TF:
	bash setup.sh 

build_infr:
	cd infrastructure; terraform init && terraform plan && terraform apply
