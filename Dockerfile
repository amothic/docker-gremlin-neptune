FROM openjdk:8-jre-alpine
ENV GREMLIN_VERSION 3.3.2

RUN set -ex \
    && apk add --no-cache --virtual .build-deps wget unzip \
    && apk add --no-cache bash gettext \
    && wget https://archive.apache.org/dist/tinkerpop/$GREMLIN_VERSION/apache-tinkerpop-gremlin-console-$GREMLIN_VERSION-bin.zip -O gremlin.zip \
    && unzip gremlin.zip \
    && rm gremlin.zip \
    && mv apache-tinkerpop-gremlin-console-$GREMLIN_VERSION gremlin \
    && cd gremlin \
    && wget https://www.amazontrust.com/repository/SFSRootCAG2.pem \
    && apk del .build-deps

COPY neptune-remote.yaml.template /gremlin/conf/
COPY neptune.groovy /gremlin/

WORKDIR /gremlin

CMD envsubst < conf/neptune-remote.yaml.template > conf/neptune-remote.yaml \
    && bin/gremlin.sh -i neptune.groovy
