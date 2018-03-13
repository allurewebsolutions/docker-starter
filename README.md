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
| .env    	            | sets variables             	|
| docker.mk    	        | defines make commands        	|

## Getting Started
#### Setting up your project
1. Open the `.env` file and replace `<<project-name>>` with a name for your project

#### Fresh Installation
1. Setup `.env`
1. Run the Install WordPress or Start Mac scripts (see "Helper Scripts" section below)

#### Cloning Existing Site
1. Setup `.env`
1. Place the database export into `init/db`
1. Run the Install WordPress or Start Mac scripts (see "Helper Scripts" section below)
1. Copy plugins/themes/media into `www/wp-content`

## Features
This repo comes with a few helper bash scripts to make it easier to accomplish certain functions. Run all of them using this format from the project root: `sh bin/script.sh COMMAND`

### Helper scripts

##### Start Project Scripts (Mac only for now)
One single script that starts up your project. It will ask you if you want to install WordPress as well, which will then run the both the Install WordPress and Traefik Help scripts below.

Usage: 

- Start containers (default): `sh bin/start-mac.sh`
- Start containers (skip WordPress prompt): `sh bin/start-mac.sh -no-install`

##### Install WordPress
Install WordPress with a few different options. The script will check if WordPress is already installed (www/wp-config.php file found). If it is, you will be asked if you want to reinstall. If WordPress isn't installed, it will proceed with the installation and then ask you whether you want to setup the DB or not.

Example: `sh bin/install-wordpress.sh`

##### WP
Execute WP CLI commands on the PHP container

Example: `sh bin/wp.sh plugin list`

##### SSH
Shell into the PHP container

Usage: `sh bin/ssh.sh` or `make shell`

##### Composer
Execute composer commands on the root of the project in the PHP container

Example: `sh bin/composer.sh install`

##### Traefik Helper
Initiate Traefik on all projects defined in your docker-compose.yml file

Usage: `sh bin/traefik-helper.sh up -d`

##### Delete all containers
This will remove all container, but data will not be lost because it's stored on your hard drive

Usage: `make prune`

## WordPress Multisites
To make multsites work, use a subdomain install and list subdomains in the docker-compose.yml frontend rule for nginx. For example:
`- 'traefik.frontend.rule=Host:viasatdealer.docker.localhost,test.viasatdealer.docker.localhost'`

Alternatively, if you want to target all possible subdomains, you can comment out line 47 and uncomment line 48 in the docker-compose.yml. This will make other containers such as the phpmyadmin not work.

## BrowserSync
If you are using some sort of build workflow (Gulp/Webpack/Grunt) with BrowserSync, you have to use a temporary workaround. I'm still working on a viable solution to this.

In your BrowserSync config remove and reference to proxy/server. Then add the following code right before your closing `</body>` tag:
```
<script id="__bs_script__">//<![CDATA[
    document.write("<script async src='http://HOST:3000/browser-sync/browser-sync-client.js?v=2.18.13'><\/script>".replace("HOST", location.hostname));
//]]></script>
```

## Troubleshooting
If traefik won't start, make sure nothing is bound to port 80, such as Mac's internal apache, which can be stopped with `sudo /usr/sbin/apachectl stop`