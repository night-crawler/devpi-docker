#!/usr/bin/env bash

docker build -t docker.force.fm/msa/devpi:latest \
             -t docker.force.fm/msa/devpi:4.3.2 \
             -t ncrawler/devpi:latest \
             -t ncrawler/devpi:4.3.2 \
             .
