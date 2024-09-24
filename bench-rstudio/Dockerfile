ARG BASE_CONTAINER=ubuntu:22.04

FROM $BASE_CONTAINER

# Docker file configuration
ARG SNOWFLAKE_DRIVER=3.2.0
ARG FILES_BASE="files"

# Configure environment
ENV SHELL=/bin/bash \
    HOME="/data"
ENV PATH=${HOME}/.local/bin:${HOME}/.software:$PATH


## System level packages
# Update and upgrade base image
RUN apt update && \
    apt-get upgrade -y

# Install R packages
RUN apt install --no-install-recommends software-properties-common dirmngr wget curl vim -y && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt install --no-install-recommends r-base r-cran-base64enc -y && \
    apt-get install gdebi-core gcc git libcurl4-openssl-dev make libgit2-dev zlib1g-dev pandoc libfreetype6-dev libjpeg-dev libpng-dev libtiff-dev libicu-dev libfontconfig1-dev libfribidi-dev libharfbuzz-dev libxml2-dev -y 

# Install rStudio OSS
RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.2-764-amd64.deb && \
    gdebi -n rstudio-server-2024.04.2-764-amd64.deb && rm rstudio-server-2024.04.2-764-amd64.deb

# Build packages
RUN apt-get install build-essential libcurl4-gnutls-dev libssl-dev -y

# Install Nginx
RUN apt-get install nginx -y

# Clean up
RUN apt-get clean

# Install ODBC/Snowflake drivers 
RUN apt-get update -y && apt-get install unixodbc-dev unixodbc -y \
    && ln -s /usr/lib/x86_64-linux-gnu/libodbcinst.so.2 /usr/lib/x86_64-linux-gnu/libodbcinst.so.1
RUN wget --no-verbose https://sfc-repo.snowflakecomputing.com/odbc/linux/${SNOWFLAKE_DRIVER}/snowflake-odbc-${SNOWFLAKE_DRIVER}.x86_64.deb -O /tmp/snowflake-odbc-${SNOWFLAKE_DRIVER}.x86_64.deb \
    && dpkg -i /tmp/snowflake-odbc-${SNOWFLAKE_DRIVER}.x86_64.deb \
    && rm /tmp/snowflake-odbc-${SNOWFLAKE_DRIVER}.x86_64.deb

## Startup scripts
# Init script invoked at start of a bench workspace
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_start.sh /usr/local/bin/ica_start.sh

# Script to setup and start nginx daemon
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_nginx.sh /usr/local/bin/ica_nginx.sh

# Script to setup and start rstudio
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/rstudio.sh /usr/local/bin/rstudio.sh

# Script to simulate init.d 
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/ica_applications.sh /usr/local/bin/ica_applications.sh

## Custom configuration
# Rstudio config
RUN useradd --system --home-dir=${HOME} -m -s /bin/bash -N -u 1000 ica && \
    usermod -a -G users ica && usermod -a -G rstudio-server ica
COPY --chmod=0644 --chown=root:root ${FILES_BASE}/rserver.conf /etc/rstudio/rserver.conf
COPY --chmod=0644 --chown=root:root ${FILES_BASE}/logging.conf /etc/rstudio/logging.conf
COPY --chmod=0644 --chown=root:root ${FILES_BASE}/database.conf /etc/rstudio/database.conf

# Web config
COPY --chmod=0755 --chown=root:root ${FILES_BASE}/nginx.conf /etc/nginx/nginx.conf

# Default user
USER ica
