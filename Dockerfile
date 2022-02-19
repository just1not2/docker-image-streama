# Copyright: (c) 2022, Justin Béra (@just1not2) <me@just1not2.org>
# Apache License 2.0 (see LICENSE or https://www.apache.org/licenses/LICENSE-2.0.txt)

# Build
FROM openjdk:8-jre-slim as build

WORKDIR /app

RUN apt-get -y update
RUN apt-get -y install wget
RUN wget https://github.com/streamaserver/streama/archive/refs/tags/v1.10.4.tar.gz
RUN tar xvzf /app/v1.10.4.tar.gz

WORKDIR /app/streama-1.10.4

RUN ./gradlew build -Dgrails.env=mysql --no-daemon


# Install
FROM openjdk:8-jre-slim
LABEL maintainer="me@just1not2.org"

WORKDIR /app

COPY --from=build /app/streama-1.10.4/build/libs/streama-1.10.4-1.10.4.jar /app/streama.jar

EXPOSE 8080

ENTRYPOINT [ \
    "java", \
    "-Dmysql_host=${STREAMA_MYSQL_HOST:localhost}", \
    "-Dmysql_port=${STREAMA_MYSQL_PORT:3306}", \
    "-Dmysql_db=${STREAMA_MYSQL_DB:streama}", \
    "-Dmysql_user=${STREAMA_MYSQL_USER:streama}", \
    "-Dmysql_password=${STREAMA_MYSQL_PASSWORD:streama}", \
    "-jar", \
    "/app/streama.jar" \
]
