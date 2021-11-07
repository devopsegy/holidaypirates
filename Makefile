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

create_org:
	curl \
  --header "Authorization: Bearer MrEzqUyuoHov4g.atlasv1.tS1B6fMfD5lbhqqs4G1sw5h6Da5yhKAF9MKEOMkQ4Qpr5JA2HDhSp79arOTzz1yfzZA" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @infrastructure/organization.json \
  https://app.terraform.io/api/v2/organizations

create_workspace:
	curl   --header "Authorization: Bearer MrEzqUyuoHov4g.atlasv1.tS1B6fMfD5lbhqqs4G1sw5h6Da5yhKAF9MKEOMkQ4Qpr5JA2HDhSp79arOTzz1yfzZA"   --header "Content-Type: application/vnd.api+json"   --request POST   --data @infrastructure/workspace.json   https://app.terraform.io/api/v2/organizations/mohamed_ali_test_org/workspaces
create_TF:
	curl   --header "Authorization: Bearer MrEzqUyuoHov4g.atlasv1.tS1B6fMfD5lbhqqs4G1sw5h6Da5yhKAF9MKEOMkQ4Qpr5JA2HDhSp79arOTzz1yfzZA"   --header "Content-Type: application/vnd.api+json"   --request POST   --data @infrastructure/workspace.json   https://app.terraform.io/api/v2/organizations/mohamed_ali_test_org/workspaces	

app_expose:
