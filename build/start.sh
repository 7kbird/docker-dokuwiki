#!/bin/bash
set -e

source ${DOKUWIKI_BUILD_DIR}/env-defaults
source ${DOKUWIKI_BUILD_DIR}/functions

if [ -z "$(ls -A $STORAGE_DIR)" ]; then
  cp -r $TEMPLATE_DIR/* $STORAGE_DIR/ 
fi

cp ${DOKUWIKI_BUILD_DIR}/nginx.conf ${NGINX_DOKUWIKI_CONFIG}

doku_config_update_userewrite

chown -R www-data:www-data /var/www
chown -R www-data:www-data $STORAGE_DIR

exec /usr/bin/supervisord -c /etc/supervisord.conf
