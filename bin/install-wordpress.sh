#!/bin/bash

if [ -f "./www/wp-config.php" ]; then
	read -r -p "WordPress config file found. Do you want to install or reinstall the database? " reinstall

	if [[ "$reinstall" =~ ^([yY][eE][sS]|[yY])$ ]]; then

        read -r -p "Development URL (must match what you set in your docker-compose.yml; ie. test.docker.localhost): " url
        read -r -p "Site Name: " name
        read -r -p "Username: " username
        read -r -p "Password: " password
        read -r -p "Email: " email

        docker-compose exec --user 82 php wp core install --url=${url} --title="${name}" --admin_name=${username} --admin_password=${password} --admin_email=${email}

        find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
        find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
	else
	    echo "Exiting."
	fi
else
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user 82 php wp core download

    echo "Setting up config file..."

	read -r -p "Database name (must match what you set in docker-compose.yml or press enter to use default): " database

	database=${database:-wordpress}

    docker-compose exec --user 82 php wp core config --dbhost=mariadb --dbname=${database} --dbuser=root --dbpass=password

	read -r -p "Is your database already setup? " response

	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
	    echo "Exiting."
	else
	    read -r -p "Development URL (must match what you set in your docker-compose.yml; ie. test.docker.localhost): " url
	    read -r -p "Site Name: " name
	    read -r -p "Username: " username
	    read -r -p "Password: " password
	    read -r -p "Email: " email

	    docker-compose exec --user 82 php wp core install --url=${url} --title="${name}" --admin_name=${username} --admin_password=${password} --admin_email=${email}

        find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
        find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
	fi
fi