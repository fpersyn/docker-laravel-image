# docker-laravel-image
(work in progress)

## Introduction
It was intended as an easy way to containerise laravel apps to host them on Google Container Engine (Kubernetes). It can also be used for running a local test/staging server.

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

Rather than including your source code in the image (see how below). You can also mount a local volume to the image dev server:
```shell
docker run -p 80:80 -p 443:443 --name project_name -v /var/www/laravel:/your_project_root_directory/ -d project_name-image
```

### Build with existing Laravel project (Git repo)

Check if you have the following in your project repository's root `.gitignore` file:
* /vendor
* /public
* composer.lock

You now have the option to build the image with your own laravel project repository using `--build-arg repo=`:
```shell
cd your_project_directory
docker build --build-arg repo=https://username:pass@github.com/username/project.git -t project_name-image .
docker run -d --name project_name project_name-image
```

You have the option to map your ports to localhost with SSL support (see 'Fresh build' section above).

You have the option to point to your laravel `.env` file `--build-arg env=`. It will assume it is in the same directory as the Dockerfile by default:
```shell
docker run -d --build-arg env=/path_to_env_file/.env --name project_name project_name-image
```

You have the option to point to your laravel `.htaccess` file `--build-arg htaccess=`. It will assume use the file in this repo by default:
```shell
docker run -d --build-arg htaccess=/path_to_htaccess/.htaccess --name project_name project_name-image
```

### Custom config
You can run the image & shell into the instance to run any commands :
```shell
# run the image first
docker exec -it project_name bash
cd var/www/laravel
# you can run artisan and composer commands from here
```

-Fred
