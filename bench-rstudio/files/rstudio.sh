#!/bin/bash
RSTUDIORUNNING=true

# Terminate function
function rstudio_terminate() {
	USER=ica rstudio-server stop
	RSTUDIORUNNING=false
}

# Catch SIGTERM signal and execute terminate function.
# A workspace will be informed 30s before forcefully being shutdown
trap rstudio_terminate SIGTERM

APPLICATION=/etc/init.d/rstudio-server
APP_FOLDER=/data/.rstudio
mkdir -p $HOME/.rstudio $HOME/.rstudio/run $HOME/.rstudio/log $HOME/.rstudio/conf $HOME/.rstudio/data $HOME/.local/share/rstudio/log

cat<<EOT > $HOME/.Renviron
$(env)
R_LIBS=/data/.R/library
RETICULATE_PYTHON=/usr/bin/python3
EOT


echo "Starting rStudio-server"
while $RSTUDIORUNNING; do
	USER=ica rstudio-server start
done

echo "rstudio-server stopped"
