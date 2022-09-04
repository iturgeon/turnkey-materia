## Production Ready Materia Server


### Resources
* [Official Docs](https://ucfopen.github.io/Materia-Docs/)
* [Official Docker Images](https://github.com/ucfopen/Materia/pkgs/container/materia)
* [Official Github Source](https://github.com/ucfopen/Materia)

### Materia Architecture

* App Server - The php server that runs the server side of Materia
* Web Server
* Database
* Optional Cache
* Optional Media Storage
* Optional CDN

###

1. Start a Database Server
   For example purposes, let's start a local docker db. Note I'm setting the platform because I'm running on an M1 mac and MYSQL is missing the amd version of this container.  I'm setting a couple env vars for the users and db names, and finally hooking up port 3306 to make it easy to reach
   ```bash
   $ docker run --name materia-db -e MYSQL_ROOT_PASSWORD=drRoots -e MYSQL_USER=materia -e MYSQL_PASSWORD=odin -e MYSQL_DATABASE=materia --platform linux/amd64 -p 3306:3306 -d mysql:5.7.34
   ```
2. Setup webserver
   Note that this install assumes you'll have a load balancer in front of the webserver that is responsible for https, but will talk to the webserver over port 80.  We'll use the [nginx config built into the docker image](https://github.com/ucfopen/Materia/blob/v9.0.1/docker/config/nginx/nginx-production.conf).  If you want to the webserver to handle secure connections, you may find some useful hints in nginx-dev.conf
3. Migrate database and basic setup.
   We need to set up the database so that it has the required tables and data to run.  Materia uses database migration files handled by our PHP framework for this.  This command will also initialize a few settings and users to get you started - keep track of the output!
   ```bash
   docker-compose run --rm app composer oil-install-quiet
   ```
4. Run
   ```
   docker-compose up
   ```
5. Install Widgets
   There are no widgets installed in Materia yet, so we'll want to do that now. To get started, it probably makes sense to install the default widgets.
   ```bash
   docker-compose exec app bash -c 'php oil r widget:install_from_config'
   ```
