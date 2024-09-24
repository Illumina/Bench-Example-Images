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

# Start SSH Setup
/usr/local/bin/ica_sshd.sh &

# Start init scripts
/usr/local/bin/ica_applications.sh &

# Hold init process until TERM signal is received
tail -f /dev/null &
WAITPID=$!
wait $WAITPID
