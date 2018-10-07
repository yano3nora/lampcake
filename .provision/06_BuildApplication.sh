#!/bin/bash

cd /var/www/app
expect -c "
  set timeout -1
  spawn composer install
  expect \"Set Folder Permissions ?*\"
  send \"\n\"
  expect eof exit 0
"
cp -f config/app.development.php config/app.php
bin/cake drop -f
bin/cake migrations migrate
bin/cake migrations seed
bin/cake cache clear_all
