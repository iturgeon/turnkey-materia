## Production Ready Materia Server


### Resources
* [Official Docs](https://ucfopen.github.io/Materia-Docs/)
* [Official Docker Images](https://github.com/ucfopen/Materia/pkgs/container/materia)
* [Official Github Source](https://github.com/ucfopen/Materia)

### Materia Architecture

* App Server - The php server that runs the server side of Materia
* Web Server - An Nginx server that can host dynamic and static assets.
* Database - Mysql server that
* Optional Load Balancer - Opens up a lot of options for hosting, updates, failover etc.
* Optional Cache - Memcache server used to optimize and speed up the server.
* Optional Media Storage - Media can be stored in the file system, database, or on aws s3
* Optional CDN - Static assets can be hosted on a CDN to speed up your user's experience and reduce server load.

###

1. Start a Database Server
   For example purposes, let's start a local docker db. Note I'm setting the platform flag because I'm running on an M1 mac and MYSQL is missing the ARM version of this container.  I'm setting a couple env vars for the users and db names, and finally hooking up port 3306 to make it easy to reach.  This could be your on-prem db server or one in the cloud instead of a local Docker container.
   ```bash
   $ docker run --name materia-db -e MYSQL_ROOT_PASSWORD=drRoots -e MYSQL_USER=materia -e MYSQL_PASSWORD=odin -e MYSQL_DATABASE=materia --platform linux/amd64 -p 3306:3306 -d mysql:5.7.34
   ```

2. Setup Webserver
   Note that this install assumes there is a load balancer in front of the webserver that is responsible for https, but will talk to the webserver over port 80.  We'll use the [nginx config built into the docker image](https://github.com/ucfopen/Materia/blob/v9.0.1/docker/config/nginx/nginx-production.conf).  If you want to the webserver to handle secure connections directly, you may find some useful hints in nginx-dev.conf.  You'll need a cert, and you'll need to provide it to the container in one way or another.

3. Migrate Database and Initialize.
   Set up the database so that it has the required tables and data.  Materia uses database migration files handled by our PHP framework for this.  This command will also initialize a few settings and users to get you started. Watch the output so you can log in with a randomized password!
   ```bash
   docker-compose run --rm app composer oil-install-quiet
   ```

4. Generate a few random keys
   FuelPHP asks for some randomized seeds to do some of it's internal hashing and encryption.  Set these by providing values for AUTH_SALT, AUTH_SIMPLEAUTH_SALT, and CIPHER_KEY defined in the docker-compose file.

   Generate your 3 random id using the output from:
	```bash
	docker-compose run --rm app php -r "echo(sodium_bin2hex(random_bytes(SODIUM_CRYPTO_STREAM_KEYBYTES)));"
	```

5. Run Materia
   Now we can rely on docker compose to download a few containers and start Materia.
   ```
   docker-compose up
   ```

6. Install Widgets
   There are no widgets installed in Materia yet, so we'll want to do that now. To get started, it probably makes sense to install the default widgets.
   ```bash
   docker-compose exec app bash -c 'php oil r widget:install_from_config'
   ```
