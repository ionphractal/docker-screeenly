
docker-screeenly
===

Screenshot as a service in a Docker container.

# Usage

You can use the docker-compose.yml, just update it to suit your environment.
Start up the db first with `docker-compose up -d db` and wait until its ready (check `docker-compose logs -f db`).

At the moment, I still have Apache running all the time so that I can manually go into the container for debugging.

Start the rest with `docker-compose up -d`.

Once the containers are started, go into the container with
```
docker exec -it -u www-data <screeenly container name> bash
```

Run the server with:
```
php artisan serve --host=0.0.0.0 --port=8000
```

If you have any questions about starting it with docker, please let me know.
