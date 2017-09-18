@echo off

if exist "./www/wp-config.php" (
	echo "WordPress config file found."
) else (
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user 82 php wp core download
	docker-compose exec --user 82 php wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
)