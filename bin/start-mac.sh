#!/usr/bin/env bash

# Build containers
echo
echo "Building containers..."
echo

docker-compose pull

docker-compose up -d
sh bin/traefik-helper.sh up -d

echo
echo "Containers started."
echo

if [ "$1" != "-no-install" ]; then
    read -r -p "Do you want to install a fresh copy of WordPress?: " response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sh bin/install-wordpress.sh
    else
        echo "Project Initiated."
    fi
fi