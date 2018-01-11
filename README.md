# WordPress Docker Starter

## Introduction

This is a docker starter specifically tailored for WordPress projects. The goal of the repo is to help you efficiently setup a local development environment with either a fresh installation of WordPress, or cloning another site.

Read the documention from which this repo is forked: [**Getting Started**](http://docker4wordpress.readthedocs.io)

## Repo Structure
| Files/Folders      	| Description                  	|
|--------------------	|------------------------------	|
| bin                	| helper scripts               	|
| config             	| config files (php)           	|
| data               	| db saved here                	|
| init               	| init scripts (sql)           	|
| www                	| wordpress files located here 	|
| docker-compose.yml 	|                              	|
| docker-sync.yml    	|                              	|

## Getting Started
#### Setting up `docker-compose.yml` and `docker-sync.yml`
1. Find/replace **<project-name>** with a handle for your project
1. Find/replace **/absolute/path/to/project** with the absolute path to your project root

#### Fresh Installation
1. Setup docker-compose.yml and docker-sync.yml
1. Run the Install WordPress or Start Mac scripts (see "Helper Scripts" section below)

#### Cloning Existing Site
1. Setup docker-compose.yml and docker-sync.yml
1. Place the database export into `init/db`
1. Run the Install WordPress or Start Mac scripts (see "Helper Scripts" section below)
1. When the script asks you whether the database is already installed, say yes
1. Copy plugins/themes/media in `www/wp-content`

## Features
This repo comes with a few helper bash scripts to make it easier to accomplish certain functions. Run all of them using this format from the project root: `sh bin/script.sh COMMAND`

### Helper scripts

##### Start Project Scripts (Mac only for now)
One single script that starts up your project. It will ask you if you want to install WordPress as well, which will then run the both the Install WordPress and Traefik Help scripts below.

Usage: 

- Start containers (default): `sh bin/start-mac.sh -d`
- Start containers (skip WordPress prompt): `sh bin/start-mac.sh -d -s`

##### Install WordPress
Install WordPress with a few different options. The script will check if WordPress is already installed (www/wp-config.php file found). If it is, you will be asked if you want to reinstall. If WordPress installed installed, it will proceed with the installation and then ask you whether you want to setup the DB or not.

Example: `sh bin/install-wordpress.sh`

##### WP
Execute WP CLI commands on the PHP container

Example: `sh bin/wp.sh plugin list`

##### SSH
Shell into the PHP container

##### Composer
Execute composer commands on the root of the project in the PHP container

Example: `sh bin/composer.sh install`

##### Traefik Helper
Initiate Traefik on all projects defined in your docker-compose.yml file

Usage: `sh bin/traefik-helper.sh up -d`


## WordPress Multisites
To make multsites work, use a subdomain install and stack subdomains in the docker-compose.yml frontend rule for nginx. For example:
`- 'traefik.frontend.rule=Host:viasatdealer.docker.localhost,test.viasatdealer.docker.localhost'`

Alternatively, if you want to target all possible subdomains, you can comment out line 47 and uncomment line 48 in the docker-compose.yml. This will make other containers such as the phpmyadmin not work.

## Troubleshooting
If traefik won't start, make sure nothing is bound to port 80, such as Mac's internal apache, which can be stopped with `sudo /usr/sbin/apachectl stop`