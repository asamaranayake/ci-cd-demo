# Part 1: Running and Managing Containers

## Objective
Learn to run containers from Docker Hub and manage their lifecycle.

## Quick Start

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Run Ubuntu interactively
docker run -it ubuntu bash

# Run Nginx web server
docker run -d -p 8080:80 --name my-nginx nginx

# Visit: http://localhost:8080

# Check logs
docker logs my-nginx

# Stop container
docker stop my-nginx

# Remove container
docker rm my-nginx
```

## Exercises

### Exercise 1: Interactive Containers
```bash
docker run -it ubuntu bash
# Inside container, try:
whoami
hostname
pwd
ls /
exit
```

### Exercise 2: Port Mapping
```bash
# Nginx on port 8080
docker run -d -p 8080:80 --name my-nginx nginx

# Apache on port 8081
docker run -d -p 8081:80 --name my-apache httpd

# Visit both in browser
# http://localhost:8080
# http://localhost:8081

# Clean up
docker stop my-nginx my-apache
docker rm my-nginx my-apache
```

### Exercise 3: Container Management
```bash
# Run multiple containers
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root123 --name my-mysql mysql:8.0

# List all
docker ps -a

# Get detailed info
docker inspect my-mysql

# View logs
docker logs my-mysql

# Execute command in container
docker exec my-mysql mysql -u root -proot123 -e "SHOW DATABASES;"

# Stop and remove
docker stop my-mysql
docker rm my-mysql
```

## Common Commands

```bash
docker ps                    # List running containers
docker ps -a                 # List all containers
docker run -it IMAGE bash    # Run interactively
docker run -d IMAGE          # Run in background
docker logs CONTAINER        # View logs
docker stop CONTAINER        # Stop container
docker start CONTAINER       # Start container
docker rm CONTAINER          # Remove container
docker inspect CONTAINER     # Get detailed info
docker exec CONTAINER CMD    # Run command in container
```

## Tips

- Use `--name` to give containers friendly names
- Use `-d` to run in background
- Use `-p HOST:CONTAINER` for port mapping
- Use `-e KEY=VALUE` for environment variables
- Use `-it` for interactive access
- Type `exit` to leave interactive containers
