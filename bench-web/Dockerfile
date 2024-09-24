ARG BASE_CONTAINER=alpine:3.20

FROM $BASE_CONTAINER

LABEL maintainer="Illumina <info@illumina.com>"

# Base directory for the misc files
ARG FILES_BASE="files"

# Configure environment
ENV SHELL=/bin/bash \
    HOME="/data"
ENV PATH=${HOME}/.local/bin:${HOME}/.software:$PATH

# Install required system level packages
RUN apk update && \
    apk add --no-cache shadow vim wget unzip bzip2 tar bash curl nginx nginx-mod-http-lua

# Bench workspaces need to run as user with uid 1000 and be part of group with gid 100
RUN adduser -H -D -s /bin/bash -h ${HOME} -u 1000 -G users ica

## Startup scripts
# Init script invoked at start of a bench workspace
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_start.sh /usr/local/bin/ica_start.sh

# Script to setup and start nginx daemon
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_nginx.sh /usr/local/bin/ica_nginx.sh

# Script to simulate init.d 
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_applications.sh /usr/local/bin/ica_applications.sh

## Custom Configuration
# Web config
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/nginx.conf /etc/nginx/nginx.conf

# Default user
USER ica
