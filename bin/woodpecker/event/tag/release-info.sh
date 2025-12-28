#!/usr/bin/env bash

set -eo pipefail

${0%/*}/ENV.sh

echo '(repo git "'"$CI_REPO_CLONE_URL"')"' | tee $CI_REPO_NAME.release-info
echo '(uri targz "'"$CI_REPO_URL/archive/{egg-release}.tar.gz"'")' | tee -a $CI_REPO_NAME.release-info

curl -sSL \
	-X 'GET' \
	-H 'accept: application/json' \
	"$API_URL/repos/$CI_REPO/releases" \
| jq '.[].tag_name' | xargs -I__ -d"\n" echo '(release __)' | tee -a $CI_REPO_NAME.release-info

id="$(curl -sSL \
	-X 'GET' \
	-H 'accept: application/json' \
	"$API_URL/repos/$CI_REPO/releases/tags/$CI_COMMIT_TAG" \
	| jq '.id')"

curl -u :$TOKEN -X 'POST' \
	-H 'accept: application/json' \
	--data-binary "@$CI_REPO_NAME.release-info" \
	"$API_URL/repos/$CI_REPO/releases/$id/assets?name=$CI_REPO_NAME.release-info"
