#!/bin/bash

if [ -f "./www/wp-config.php" ];
then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user 82 php wp core download
	docker-compose exec --user 82 php wp core config --dbhost=mariadb --dbname=wordpress --dbuser=root --dbpass=password
fi