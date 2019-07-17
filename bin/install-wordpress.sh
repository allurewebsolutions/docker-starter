#!/bin/bash

read_var() {
  if [ -z "$1" ]; then
    echo "environment variable name is required"
    return
  fi

  local ENV_FILE='.env'
  if [ ! -z "$2" ]; then
    ENV_FILE="$2"
  fi

  local VAR=$(grep $1 "$ENV_FILE" | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo ${VAR[1]}
}

project_name=$(read_var PROJECT_NAME)
wp_site=$(read_var WP_SITE)
wp_user=$(read_var WP_USER)
wp_pass=$(read_var WP_PASS)
wp_email=$(read_var WP_EMAIL)

db_host=$(read_var DB_HOST)
db_user=$(read_var DB_USER)
db_root_pass=$(read_var DB_ROOT_PASSWORD)

if [ -f "./www/wp-config.php" ]; then
	read -r -p "WordPress seems to already be installed. Do you want to install or reinstall the database? " reinstall

	if [[ "$reinstall" =~ ^([yY][eE][sS]|[yY])$ ]]; then

        docker-compose exec --user 82 php wp core install --url="${project_name}.docker.localhost" --title="${wp_site}" --admin_name=${wp_user} --admin_password=${wp_pass} --admin_email=${wp_email}

        find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
        find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
	else
	    echo "WordPress installed."
	fi
else
	echo "WordPress is not installed. Installing..."
	docker-compose exec --user 82 php  wp core download

    read -p "Waiting for database to be initialized..." -t 15

	docker-compose exec --user 82 php wp core config --dbhost=${db_host} --dbname=${project_name} --dbuser=root --dbpass=${db_root_pass}

#    docker-compose exec --user 82 php wp core config --dbhost=${db_host} --dbname=${project_name} --dbuser=root --dbpass=${db_root_pass} --extra-php <<PHP
#    define( 'WP_DEBUG', true );
#    define( 'WP_DEBUG_LOG', true );
#    PHP

	read -r -p "Is your database already setup? " response

	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
	    echo "WordPress installed."
	else

	    docker-compose exec --user 82 php wp core install --url="${project_name}.docker.localhost" --title="${wp_site}" --admin_name=${wp_user} --admin_password=${wp_pass} --admin_email=${wp_email}

        find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
        find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--

        echo "WordPress installed."
	fi
fi
