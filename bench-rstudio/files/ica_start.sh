#!/bin/bash

# Terminate function
function terminate() {
        # Send SIGTERM to child processes
        kill -SIGTERM $(jobs -p)

        # Send SIGTERM to waitpid
        echo "Stopping ..."
        kill -SIGTERM ${WAITPID}
}

# Catch SIGTERM signal and execute terminate function.
# A workspace will be informed 30s before forcefully being shutdown
trap terminate SIGTERM

# Print out Workspace ID
echo "Starting workspace with Id ${ICA_WORKSPACE}"

# Start Nginx Daemon
/usr/local/bin/ica_nginx.sh &

# Start rStudio Server
/usr/local/bin/rstudio.sh &

# Start init scripts
/usr/local/bin/ica_applications.sh &

tail -f /dev/null &
WAITPID=$!
wait $WAITPID
