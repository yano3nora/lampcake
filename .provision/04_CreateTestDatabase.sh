#!/bin/bash

DB_ROOT="root"
DB_ROOT_PW="password"
DB_NAME="app_test"
DB_USER="app"
DB_PASS="password"

mysql -u ${DB_ROOT} --password=${DB_ROOT_PW} <<EOF
  create database ${DB_NAME} default character set utf8mb4;
  grant all on ${DB_NAME}.* to '${DB_USER}'@'localhost' identified by '${DB_PASS}';
EOF