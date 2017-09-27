#!/usr/bin/env bash
PARAMS=""
if [ -z "$*" ]; then
    PARAMS="--build"
fi

# Build containers
echo
echo "Building containers..."
docker-compose pull
if [ -e "docker-custom.yml" ]; then
	docker-compose -f docker-compose.yml -f docker-custom.yml up ${PARAMS} $@
else
    docker-sync start
    docker-compose up ${PARAMS} $@
    sh bin/traefik-helper.sh up $@
fi

echo
echo "Done"

read -r -p "Do you want to install a fresh copy of WordPress? " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sh bin/install-wordpress.sh
else
    echo "Project Initiated."
fi