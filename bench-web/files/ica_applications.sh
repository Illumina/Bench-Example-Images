#!/bin/bash

# Folder located in the workspace image containing init scripts.
# This folder is a Read only folder at runtime.
USERHOME=/etc/$(whoami)
STARTUP_SCRIPTS=${USERHOME}/.applications/init.d

# Folder on the workspace volume containing init scripts.
# This folder is Read/Write at runtime
STARTUP_SCRIPTS_HOME=${HOME}/.applications/init.d

# Folder containing init script outputs.
STARTUP_LOGS=${HOME}/.applications/log

# Create startup scripts folder and the applications/init.d folder
mkdir -p ${STARTUP_LOGS} ${STARTUP_SCRIPTS_HOME}

# Run startup scripts matching a regex
run-parts --regex='.*\.sh' ${STARTUP_SCRIPTS} &> ${STARTUP_LOGS}/init.log
run-parts --regex='.*\.sh' ${STARTUP_SCRIPTS_HOME} &> ${STARTUP_LOGS}/init.log
