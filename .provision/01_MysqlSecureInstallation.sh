#!/bin/bash

PW="password"

expect -c "
  set timeout -1
  spawn mysql_secure_installation
  expect \"Enter current password for root (enter for none):\"
  send \"\n\"
  expect \"Set root password?\"
  send \"y\n\"
  expect \"New password:\"
  send \"${PW}\n\"
  expect \"Re-enter new password:\"
  send \"${PW}\n\"
  expect \"Remove anonymous users?\"
  send \"y\n\"
  expect \"Disallow root login remotely?\"
  send \"y\n\"
  expect \"Remove test database and access to it?\"
  send \"y\n\"
  expect \"Reload privilege tables now?\"
  send \"y\n\"
  expect eof exit 0
"