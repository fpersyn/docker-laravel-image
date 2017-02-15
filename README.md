# docker-laravel-image

## Introduction
This Dockerfile is intended as an easy way to containerise laravel apps to then host them on Google Container Engine (Kubernetes). It can also be used for running a local dev and staging server.

## Build your image

### Requirements
* Docker installed on your machine (read more: https://docs.docker.com/engine/installation/)

### Fresh build
By default the Dockerfile will generate an image with a fresh install of Laravel (latest). Be sure to have all the files in this repo present in the directory where you execute the build.

```shell
docker build -t project_name-image .
docker run -P --name project_name -d project_name-image
docker ps -a
# open the address mapped to port 80 in your browser  
```

You can run the image on localhost with SSL support like so:
```shell
docker run -p 80:80 -p 443:443 --name project_name -d project_name-image
```

Rather than including your own Git repository in the image (see how below). You can also mount a volume to the image. Ideal if you want to run the image as your localhost or use shared storage.
```shell
docker run -p 80:80 -p 443:443 --name project_name -v /var/www/laravel:/your_project_root_directory/ -d project_name-image
```

### Build with existing Laravel project (Git repo)

Check if you have the following in your project repository's root `.gitignore` file:
* /vendor
* /public
* composer.lock

To build the image with your own laravel project repository you can use `--build-arg repo=`:
```shell
cd your_project_directory
docker build --build-arg repo=https://username:pass@github.com/username/project.git -t project_name-image .
```

You have the option to point to your laravel `.env` file `--build-arg env=`. It will assume it is in the same directory as the Dockerfile by default:
```shell
docker build --build-arg env=/path_to_env_file/.env -t project_name-image .
```

You have the option to point to your laravel `.htaccess` file `--build-arg htaccess=`. It will assume use the file in this repo by default:
```shell
docker build --build-arg htaccess=/path_to_htaccess/.htaccess -t project_name-image .
```

See 'Fresh build' for instructions on how to map your ports to localhost with SSL support.

## Executing laravel commands
You can run the image & shell into the instance to run any commands :
```shell
# run the image first
docker exec -it project_name bash
cd var/www/laravel
# you can run artisan, composer, git, etc. commands from here
```

You can alter the Dockerfile to run additional artisan/composer commands to suit your project's needs.

-Fred
