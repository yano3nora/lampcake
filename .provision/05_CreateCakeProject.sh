#!/bin/bash

if [ ! -e /var/www/app ]; then
  expect -c "
    set timeout -1
    cd /var/www
    spawn /bin/sh -c \"sudo composer create-project --prefer-dist -s dev cakephp/app app\"
    expect \"Set Folder Permissions ?\"
    send \"\n\"
    expect eof exit 0
  "
  cd /var/www/app
  sudo composer require phpunit/phpunit
  sudo composer require cakephp/cakephp-codesniffer
  cp -f /var/www/.provision/robots.txt /var/www/app/webroot/robots.txt
  cp -f /var/www/.provision/DropShell.php /var/www/app/src/Shell/DropShell.php
  cp -u /var/www/.provision/app.initialize.php /var/www/app/config/app.development.php
  cp -u /var/www/.provision/bootstrap.initialize.php /var/www/app/config/bootstrap.php
fi