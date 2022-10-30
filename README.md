## Production Ready Materia Server Setups

This project contains a couple different ways to run Materia in production.

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

### Examples

Each example has a Readme of it's own, look for more info there.

* **01-https-and-mysql** - NGINX in docker with a TLS cert, Materia php server in docker, Mysql in docker. This is easily modified for external mysql server.
* **02-https-terminated-loadbalancer-and-external-mysql** - Includes a Load Balancer that simulates an AWS ALB. NGINX in docker w/o TLS, Materia in docker, mysql in docker.


