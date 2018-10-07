#!/bin/bash

PW="password"

expect -c "
  set timeout -1
  spawn bash -c \"mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql -p\"
  expect \"Enter password:\"
  send \"${PW}\n\"
  expect eof exit 0
"