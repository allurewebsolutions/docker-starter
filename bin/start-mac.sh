#!/usr/bin/env bash

# Build containers
echo
echo "Building containers..."
docker-compose pull
if [ -e "docker-custom.yml" ]; then
	docker-compose -f docker-compose.yml -f docker-custom.yml up $1
else
    docker-compose up $1
    sh bin/traefik-helper.sh up $1
fi

echo
echo "Containers started"

if [ "$2" != "-no-install" ]; then
    read -r -p "Do you want to install a fresh copy of WordPress? " response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sh bin/install-wordpress.sh
    else
        echo "Project Initiated."
    fi
fi