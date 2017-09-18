#!/bin/sh

YML_FILE_LOCATION="/tmp/traefik.yml";
TRAEFIC_COMMAND="docker-compose -f $YML_FILE_LOCATION";

if [ "$1" = "" ] || [ "$1" = "-h" ] || [ "$1" = "help" ]; then
  echo "Manage Traefik Docker container with docker-compose.

Usage:
$0 [ARGS...]

[ARGS...] will be passed directly to docker-compose.

Examples:
$0 up -d  # Bring up Traefik Docker container.
$0 start  # Start Traefik Docker container.
$0 stop   # Stop Traefik Docker container.
$0 down   # Bring down Traefik Docker container.";
  exit 0;
fi

# Get all networks.
NETWORKS=`docker network ls | grep '_default' | awk "{print \\$2}"`;

if [ "$NETWORKS" = "" ]; then
  echo "**Error: No networks found. Start Docker containers first.";
  exit 0;
fi

# Build yml file.
NETWORK_LIST='';
NETWORK_SECTION='';
for n in $NETWORKS
do
  NETWORK_LIST="$NETWORK_LIST      - $n
";
  NETWORK_SECTION="$NETWORK_SECTION  $n:
    external:
      name: $n
";
done

echo "Networks found:";
echo "---------------";
echo "$NETWORKS";
echo "";

cat <<EOF > "$YML_FILE_LOCATION"
version: '2'

services:
  traefik:
    image: traefik
    command: -c /dev/null --web --docker --logLevel=DEBUG
    networks:
${NETWORK_LIST}
    ports:
      - '80:80'
      - '443:443'
      - '8080:8080'
      - '1025:1025'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

networks:
${NETWORK_SECTION}
EOF

# Run the docker-compose command with passed arguments.
$TRAEFIC_COMMAND $@;