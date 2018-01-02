FROM python:3.6.4-slim-stretch

WORKDIR /application/devpi

ADD requirements.txt /application/devpi/requirements.txt

RUN pip install wheel && \
    pip install -r requirements.txt --src /usr/local/src --no-cache-dir

ADD . /application/devpi

ENV DEVPI_MIRROR_CACHE_EXPIRY=86400 \
    DEVPI_CLIENTDIR=/application/client \
    DEVPI_SERVERDIR=/application/server \
    DEVPI_LOGGER_CFG=/application/devpi/logger_cfg.json \
    DEVPI_PASSWORD=ChaNgeMEPleaseLOL771 \
    PYTHONUNBUFFERED=1

RUN mkdir -vp $DEVPI_CLIENTDIR $DEVPI_SERVERDIR && \
    adduser --uid 1000 --home /application --disabled-password --gecos "" devpi && \
    chown -hR devpi: /application

VOLUME /application/server

USER devpi
EXPOSE 3141

ENTRYPOINT ["/application/devpi/entrypoint.sh"]
