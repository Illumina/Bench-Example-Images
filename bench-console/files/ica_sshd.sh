#!/bin/bash

# Verify if SSH is enabled on this workspace
if [ -f /etc/workspace-auth/privateKey ]; then
	# Start SSH Daemon in the backgroup using the example sshd_config file
	echo "Starting SSH Daemon"
	/usr/sbin/sshd -o "SetEnv $(env | tr -s '\n' ' ')" -f /etc/ssh/sshd_config
fi
