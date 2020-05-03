# docker-ikiwiki
## Overview
This dockerfile build a dockerized ikiwiki server.
Ikiwiki is a git backend based wiki engine.
You can find more information on ikiwiki [here](https://ikiwiki.info/)

The docker image is based on debian/jessie, the web server used is lighttpd.
A ssh server is also started in order to be able to use the git workflow with ikiwiki.
An user can connect through ssh server with the user www-data.
The public part of a ssh key must be copied to the container in order to be able to reach it
through ssh.
A volume is required to make the initial data import to the container local repository.

## How to build the image
The docker image can be built with this command:

``
docker build -t ikiwiki:latest .
``

## How to run the container
``
docker run -v <local git repository>:/wiki -p 2222:22 -p 8080:80 ikiwiki:latest
``

The container can also be run from the pre-built image
on [docker hub](https://hub.docker.com/r/dgsb/ikiwiki/) with this command:

``
docker run -v <local git repository>:/wiki -p 2222:22 -p 8080:80 dgsb/ikiwiki
``

The wiki server will be accessible through:

``
http://127.0.0.1:8080
``

The container repository can be added as a remote in the local git repository:

``
git remote add docker ssh://www-data@127.0.0.1:2222/var/www/wiki.git
``

## How to setup the ssh key

The following commands makes the remote git repository accessible through ssh.
The key name may need to be updated to your specific usage.

```
docker cp ${HOME}/.ssh/id_rsa.pub "${container}":/tmp/id_rsa.pub
docker exec $container install -d -m 700 -o www-data -g www-data /var/www/.ssh
docker exec $container install /tmp/id_rsa.pub /var/www/.ssh/authorized_keys
```
