#!/bin/bash
USERHOME=/etc/$(whoami)
STARTUP_SCRIPTS=${USERHOME}/.applications/init.d
STARTUP_SCRIPTS_HOME=${HOME}/.applications/init.d
STARTUP_LOGS=${HOME}/.applications/log

# Create startup scripts folder and the applications/init.d folder
mkdir -p ${STARTUP_LOGS} ${STARTUP_SCRIPTS_HOME}

# run startup scripts
run-parts --regex='.*\.sh' ${STARTUP_SCRIPTS} &> ${STARTUP_LOGS}/init.log
#This allows application be created at run time, which is useful for testing etc.
run-parts --regex='.*\.sh' ${STARTUP_SCRIPTS_HOME} &> ${STARTUP_LOGS}/init.log
