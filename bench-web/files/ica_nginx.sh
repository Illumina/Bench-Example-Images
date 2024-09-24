#!/bin/bash

# Construct Workspace External URL Path.
WWWPATH=${ICA_NAMESPACE}-n-${ICA_WORKSPACE}-i${ICA_WORKSPACE}

# Create Nginx folders at runtime.
mkdir -p ${HOME}/.nginx ${HOME}/.nginx/html/${WWWPATH} $HOME/.nginx/log ${HOME}/.nginx/conf.d ${HOME}/.nginx/run

# Create a static example HTML page at runtime.
cat <<EOT > ${HOME}/.nginx/html/${WWWPATH}/index.html
<!DOCTYPE html>
<html>
<body>
<h1>Bench - Web - ${TYPE} - ${ICA_WORKSPACE}</h1>
</body>
</html>
EOT

# Create Nginx Configuration at runtime to expose the example HTML page.
cat <<EOT > ${HOME}/.nginx/conf.d/default.conf

    absolute_redirect off;

    location = /${WWWPATH} {
        return 302 /${WWWPATH}/\$is_args\$args;
    }

    location /${WWWPATH}/ {
      root html/;
      try_files \$uri \$uri/ /index.html;
    }
EOT

# Start Nginx Daemon.
echo "Serving application at path ${WWWPATH}"
while true; do
  /usr/sbin/nginx -c /etc/nginx/nginx.conf -p ${HOME}/.nginx -e ${HOME}/.nginx/log/error.log
done
