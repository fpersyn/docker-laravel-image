# docker-laravel-image
(work in progress)

## Introduction
It was intended as an easy way to containerise laravel apps to host them on Google Container Engine (Kubernetes). It can also be used for running a local test/staging server.

## Installation

### Fresh build
The Dockerfile will generate a fresh Laravel install (latest version) by default.

```shell
cd directory_with_clone_of_this_repo
docker build -t laravel-project-image .
docker run -P --name your-project-name -d your-project-name-image
# run docker ps -a to get the address
```

You can run the app with SSL support like so:
```shell
docker run -p 80:80 -p 443:443 --name your-project-name -d your-project-name-image
```

You can use the image as your local dev server:
```shell
docker run -p 80:80 -p 443:443 --name your-project-name -v /var/www/laravel:/your_project_root_directory/ -d your-project-name-image
```

### Existing Laravel project
Add the files in this repo to your laravel project & put the following in your .gitignore:
* /vendor
* /public
* composer.lock

You now have the option to build the image with your own laravel project repository using `--build-arg repo=`:
```shell
cd your_project_directory
docker build --build-arg repo=https://username:pass@github.com/username/project.git -t laravel-project-image .
docker run -d --name your-project-name your-project-name-image
```

### Custom config
You can run the image & shell into the instance to run any commands :
```shell
# run the image first
docker exec -it your-project-name bash
cd var/www/laravel
# you can run artisan and composer from here
```

In case you customize the Dockerfile , make sure you have the following code in your `/public/.htaccess` file for your routes to work:
```shell
Options +FollowSymLinks
RewriteEngine On

RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^ index.php [L]
```

-Fred
