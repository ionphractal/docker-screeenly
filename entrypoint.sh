#!/bin/bash

envsub .env.template .env
php artisan key:generate --force
php artisan migrate --force
#yarn hot

apache2-foreground
#php artisan serve -vvv --host=0.0.0.0 --port=8000
