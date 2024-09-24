#!/bin/bash
# Variables

WWWPATH=${ICA_NAMESPACE}-n-${ICA_WORKSPACE}-i${ICA_WORKSPACE}

# Create Nginx folders
mkdir -p ${HOME}/.nginx ${HOME}/.nginx/html/${WWWPATH} $HOME/.nginx/log ${HOME}/.nginx/conf.d ${HOME}/.nginx/run


cat <<EOT > ${HOME}/.nginx/conf.d/rstudio-server.conf
    location /${WWWPATH} {
      return 302 https://\$host/${WWWPATH}/;
    }

    location /${WWWPATH}/ {
      rewrite ^/${WWWPATH}/(.*)\$ /\$1 break;
      proxy_pass http://127.0.0.1:8787/;
      proxy_set_header X-RStudio-Root-Path "/${WWWPATH}";

      # websocket headers
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection \$connection_upgrade;
      proxy_read_timeout 20d;
      proxy_set_header X-Forwarded-Host \$host;
      proxy_http_version 1.1;

      # Iframe
      proxy_hide_header X-Frame-Options;
      add_header Content-Security-Policy "default-src 'self' 'unsafe-inline' 'unsafe-eval' data: ws: wss: https://*.illumina.com; frame-ancestors 'self' https://*.illumina.com";
    }
EOT

#Start Nginx

echo "Serving application at URL https://${ICA_BENCH_URL}/${WWWPATH}"
while true; do
  /usr/sbin/nginx -c /etc/nginx/nginx.conf -p ${HOME}/.nginx
done
