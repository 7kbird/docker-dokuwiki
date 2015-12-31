#!/bin/sh

set -e

if [ -z "$(ls -A $STORAGE_DIR)" ]; then
  cp -r $TEMPLATE_DIR/* $STORAGE_DIR/ 
fi

chown -R www-data:www-data /var/www
chown -R www-data:www-data $STORAGE_DIR

exec /usr/bin/supervisord -c /etc/supervisord.conf
