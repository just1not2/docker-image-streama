# Quick reference

-	**Maintained by**:
	Justin BÉRA ([just1not2](https://github.com/just1not2))

-	**Where to get help**:
	[the Streama official website](https://docs.streama-project.com/help/) or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)


# Supported tags

-	`1.10.4`, `1.10`, `latest`


# Quick references

-	**Where to file issues**:
	[https://github.com/just1not2/docker-image-streama/issues](https://github.com/just1not2/docker-image-streama/issues)

-	**Supported architecture**:
	`amd64`

-	**Source of this description**:
	[documentation on the Streama Docker image repository](https://github.com/just1not2/docker-image-streama/tree/main/docs/README.md)


# What is Streama?

Streama is a self-hosted streaming media server. It provides a real alternative to video-on-demand services such as Netflix.

This dockerized version of Streama permits the use of MySQL to store all data (except the media themselves).

![logo](https://raw.githubusercontent.com/streamaserver/streama/master/design/banner2.png)


# How to use this image?

## Start a `streama` server instance

Starting a Streama instance is simple:

```bash
docker run -p 8080:8080 \
           -e STREAMA_MYSQL_HOST=<MySQL host> \
           -e STREAMA_MYSQL_PASSWORD=<password of the Streama MySQL user> \
           just1not2/streama:latest
```

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `streama`:

```yaml
version: "3"

volumes:
  database_data:
  media_data:

services:
  mysql:
    image: mysql:5.7
    container_name: mysql
    hostname: mysql
    restart: always
    volumes:
      - database_data:/var/lib/mysql
    environment:
      MYSQL_DATABASE: streama
      MYSQL_USER: streama
      MYSQL_PASSWORD: streama
      MYSQL_RANDOM_ROOT_PASSWORD: true

  streama:
    image: just1not2/streama:latest
    container_name: streama
    hostname: streama
    restart: always
    volumes:
      - media_data:/data/streama
    ports:
      - "8080:8080"
    environment:
      STREAMA_MYSQL_HOST: mysql
      STREAMA_MYSQL_PORT: 3306
      STREAMA_MYSQL_DB: streama
      STREAMA_MYSQL_USER: streama
      STREAMA_MYSQL_PASSWORD: password
    depends_on:
      - mysql
```

Run `docker stack deploy -c stack.yml streama` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://localhost:8080`.

## Container shell access and viewing Streama logs

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `streama` container:

```bash
docker exec -it streama /bin/bash
```

The log is available through Docker's container log:

```bash
docker logs streama
```

## Environment Variables

When you start the `streama` image, you can adjust the configuration of the Streama instance by passing one or more optional environment variables on the `docker run` command line or in the Docker-compose file.

### `STREAMA_MYSQL_HOST`

MySQL host on which the data (except the media) will be stored. Default value is `localhost`.

### `STREAMA_MYSQL_PORT`

Port on which the MySQL instance listens. Default value is `3306`.

### `STREAMA_MYSQL_DB`

Database name on the MySQL instance. Default value is `streama`.

### `STREAMA_MYSQL_USER`

MySQL user on the MySQL instance. Default value is `streama`.

### `STREAMA_MYSQL_PASSWORD`

Password of the MySQL user on the MySQL instance. Default value is `streama`.
