#!/usr/bin/env bash

set -e

${0%/*}/ENV.sh

set -x
body="$1"
set +x

curl -sSL \
	-u :$TOKEN \
	-X 'POST' \
	-H 'accept: application/json' \
	-H 'Content-Type: application/json' \
	-d '{''"body": '"\"$body\" , "'"name": "0.0.0" ,  "tag_name": "0.0.0"''}' \
	"$API_URL/repos/$CI_REPO/releases"
