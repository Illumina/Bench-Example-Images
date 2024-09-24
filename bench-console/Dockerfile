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
    apk add --no-cache shadow openssh vim wget unzip bzip2 tar bash curl

# Bench workspaces need to run as user with uid 1000 and be part of group with gid 100
RUN adduser -H -D -s /bin/bash -h ${HOME} -u 1000 -G users ica

## Startup scripts
# Init script invoked at start of a bench workspace
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_start.sh /usr/local/bin/ica_start.sh

# Script to setup and start sshd daemon
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_sshd.sh /usr/local/bin/ica_sshd.sh

# Script to simulate init.d 
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_applications.sh /usr/local/bin/ica_applications.sh

## Custom Configuration
# SSHD Configuration file
COPY --chmod=0644 --chown=root:root ${FILES_BASE}/sshd_config /etc/ssh/sshd_config

# SSH Configuration file
COPY --chmod=0644 --chown=root:root ${FILES_BASE}/ssh_config /etc/ssh/ssh_config

# Default user
USER ica
