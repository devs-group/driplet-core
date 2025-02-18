#!/bin/bash
if [ "$1" == "dev" ]; then
  ENV="dev"
elif [ "$1" == "prod" ]; then
  ENV="prod"
elif [ "$1" == "sandbox" ]; then
  ENV="sandbox"
else
  echo "Invalid environment: $1"
  exit 1
fi

docker buildx build --platform linux/amd64 -t europe-west1-docker.pkg.dev/driplet-core-$ENV/driplet-repository/driplet:latest .
docker push europe-west1-docker.pkg.dev/driplet-core-$ENV/driplet-repository/driplet:latest
