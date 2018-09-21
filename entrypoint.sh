#!/bin/bash

envsub env.template .env
if [ -z "${APP_KEY:-}" ]; then
  echo "WARNING: APP_KEY not set. Using random generated key."
  php artisan key:generate --force
fi

# TODO: should wait for DB to come up
php artisan migrate --force

php-fpm -F
