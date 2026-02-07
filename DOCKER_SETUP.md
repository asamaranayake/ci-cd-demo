# Docker Containerization Support - Lab Materials

**Branch:** `docker-containerization-support`  
**Instructor:** Dhanushka Akila Samaranayake  
**Module:** Module 5 - Containerization with Docker

---

## 📋 Overview

This branch contains complete Docker support materials and practical examples for the Module 5 Docker Containerization lecture and lab.

---

## 👨‍🏫 Instructor Information

**Dhanushka Akila Samaranayake**  
📧 Email: akilasamaranayake0@gmail.com  
📱 Mobile: 0717147499  
🔗 LinkedIn: [Connect with me](https://www.linkedin.com/in/dhanushka-akila-samaranayake-9bb103112/)

---

> **🔒 CONFIDENTIAL - LAB MATERIAL**  
> © 2025-2026 All Rights Reserved. This material is proprietary and intended for authorized educational use only.

---

## 📁 Directory Structure

```
docker-containerization-support/
├── DOCKER_SETUP.md                    # This file
├── 01-basic-containers/               # Part 1: Running containers
│   ├── README.md
│   ├── docker-commands.sh
│   └── examples/
├── 02-custom-images/                  # Part 2: Creating images
│   ├── python-app/
│   │   ├── Dockerfile
│   │   ├── app.py
│   │   ├── requirements.txt
│   │   ├── .dockerignore
│   │   └── README.md
│   ├── nodejs-app/
│   │   ├── Dockerfile
│   │   ├── app.js
│   │   ├── package.json
│   │   └── README.md
│   └── README.md
├── 03-multi-container/                # Part 3: Docker Compose
│   ├── docker-compose.yml
│   ├── backend/
│   ├── frontend/
│   ├── database/
│   └── README.md
└── docker-compose-examples/           # Additional examples
    ├── wordpress/
    ├── todo-app/
    └── README.md
```

---

## 🎯 Quick Start

### Prerequisites
```bash
docker --version          # Docker must be installed
docker-compose --version  # Docker Compose must be installed
```

### Run Part 1: Basic Containers
```bash
cd 01-basic-containers
bash docker-commands.sh
```

### Run Part 2: Custom Images
```bash
cd 02-custom-images/python-app
docker build -t python-web-app .
docker run -d -p 5000:5000 python-web-app
curl http://localhost:5000
```

### Run Part 3: Multi-Container App
```bash
cd 03-multi-container
docker-compose up -d
curl http://localhost:3000/api/todos
```

---

## 📚 Learning Path

### Session 1: Understanding Containers (2 hours)
- [ ] Read: What containers are and why they matter
- [ ] Practice: Run containers from Docker Hub
- [ ] Do: Exercise 1 in Lab materials

### Session 2: Creating Docker Images (2 hours)
- [ ] Read: Dockerfile syntax and best practices
- [ ] Practice: Build custom Python/Node.js images
- [ ] Do: Exercise 2 in Lab materials

### Session 3: Multi-Container Apps (2 hours)
- [ ] Read: Docker Compose concepts
- [ ] Practice: Multi-service application
- [ ] Do: Exercise 3 in Lab materials

---

## 🚀 Running Examples

### Basic Examples (01-basic-containers/)

**Run Ubuntu container:**
```bash
docker run -it ubuntu bash
```

**Run Nginx web server:**
```bash
docker run -d -p 8080:80 --name my-nginx nginx
# Visit: http://localhost:8080
```

**List and manage containers:**
```bash
docker ps
docker ps -a
docker logs <container>
docker stop <container>
```

### Custom Image Examples (02-custom-images/)

**Python Flask App:**
```bash
cd 02-custom-images/python-app
docker build -t python-web-app:v1 .
docker run -d -p 5000:5000 python-web-app:v1
curl http://localhost:5000
```

**Node.js App:**
```bash
cd 02-custom-images/nodejs-app
docker build -t nodejs-app:v1 .
docker run -d -p 3000:3000 nodejs-app:v1
curl http://localhost:3000
```

### Multi-Container Examples (03-multi-container/)

**Start the complete app:**
```bash
cd 03-multi-container
docker-compose up -d
docker-compose ps
curl http://localhost:3000/api/health
```

**Check logs:**
```bash
docker-compose logs -f backend
```

**Stop everything:**
```bash
docker-compose down
```

---

## 📖 Documentation

### Lab Guide
- **Location:** `mindmapcreator/NVQLevel6/DevOps/LabPractices/Lab_05_Docker_Containerization.md`
- **Covers:** All hands-on exercises with solutions

### Lecture Notes
- **Location:** `mindmapcreator/NVQLevel6/DevOps/LectureNotes/Module_05_Docker_Containerization.md`
- **Covers:** Concepts, best practices, and theory

### Example README Files
Each example directory has detailed README with:
- What you'll learn
- Step-by-step instructions
- Expected output
- Troubleshooting tips

---

## 🎓 What You'll Learn

### Part 1: Basic Containers
- ✅ Running containers from Docker Hub
- ✅ Container lifecycle (start, stop, remove)
- ✅ Port mapping and accessing apps
- ✅ Container logs and debugging
- ✅ Managing multiple containers

### Part 2: Custom Images
- ✅ Writing Dockerfiles
- ✅ Layer caching and optimization
- ✅ Multi-stage builds
- ✅ Best practices
- ✅ Building production-ready images

### Part 3: Multi-Container Apps
- ✅ Docker Compose configuration
- ✅ Service dependencies
- ✅ Container networking
- ✅ Persistent volumes
- ✅ Health checks
- ✅ Environment variables

---

## 🔧 Common Commands

### Container Management
```bash
docker ps                        # List running containers
docker ps -a                     # List all containers
docker run -d IMAGE              # Run in background
docker run -it IMAGE bash        # Run interactively
docker stop CONTAINER            # Stop container
docker start CONTAINER           # Start container
docker rm CONTAINER              # Remove container
docker logs CONTAINER            # View logs
docker exec -it CONTAINER bash   # Execute command
```

### Image Management
```bash
docker images                    # List images
docker build -t NAME .           # Build image
docker rmi IMAGE                 # Remove image
docker tag SOURCE TARGET         # Tag image
docker push IMAGE                # Push to registry
docker pull IMAGE                # Pull from registry
```

### Docker Compose
```bash
docker-compose up -d             # Start services
docker-compose down              # Stop services
docker-compose ps                # List services
docker-compose logs              # View logs
docker-compose build             # Build images
docker-compose exec SERVICE bash # Shell access
```

---

## 💡 Troubleshooting

### Docker daemon not running
```bash
# Mac/Windows: Open Docker Desktop
# Linux:
sudo systemctl start docker
```

### Port already in use
```bash
# Use different port
docker run -p 9000:80 IMAGE

# Or find and stop existing container
docker ps | grep 8080
docker stop <container>
```

### Build fails
```bash
# Check error messages
docker build -t IMAGE . 

# Verify files exist
ls Dockerfile
ls requirements.txt

# Try rebuilding without cache
docker build --no-cache -t IMAGE .
```

### Container exits immediately
```bash
# Check logs
docker logs <container>

# Common causes:
# - Application error
# - Missing dependencies
# - Wrong command in Dockerfile
```

---

## 📊 Lab Exercises by Difficulty

### Beginner (⭐)
- [ ] Run containers from Docker Hub
- [ ] Port mapping and browser access
- [ ] Basic container management

### Intermediate (⭐⭐)
- [ ] Create custom Dockerfile
- [ ] Build and run custom image
- [ ] Multi-container with Docker Compose

### Advanced (⭐⭐⭐)
- [ ] Multi-stage Dockerfile
- [ ] Health checks and logging
- [ ] Container networking
- [ ] Volume management

---

## 🎯 Success Criteria

You've successfully learned Docker when you can:

- [ ] Explain what containers are and why they matter
- [ ] Install and configure Docker
- [ ] Run containers from Docker Hub
- [ ] Create custom Docker images
- [ ] Write effective Dockerfiles
- [ ] Use Docker Compose for multi-container apps
- [ ] Debug and troubleshoot containers
- [ ] Apply Docker best practices

---

## 📞 Getting Help

### If you're stuck:
1. Check the example README in that directory
2. Review the troubleshooting section above
3. Check Docker logs: `docker logs <container>`
4. Check Docker Compose logs: `docker-compose logs -f`
5. Ask in class or office hours

### Resources:
- **Lecture Notes:** Module 5 Docker Containerization
- **Lab Guide:** Lab 5 with full solutions
- **Docker Docs:** https://docs.docker.com/
- **Docker Compose Docs:** https://docs.docker.com/compose/

---

## 🔄 Switching Branches

To access this Docker material:
```bash
git checkout docker-containerization-support
```

To go back to main branch:
```bash
git checkout main
```

---

## 📝 File Checklist

Before running exercises, verify you have:
- [ ] Docker installed and running
- [ ] Docker Compose installed
- [ ] All example files present
- [ ] README files in each directory
- [ ] Sample source code files

---

**Branch Status:** Active  
**Last Updated:** 2026-02-07  
**Instructor:** Dhanushka Akila Samaranayake  
**License:** Educational Use Only

---

## 🔒 Confidentiality Notice

This material is proprietary and confidential. Unauthorized copying, distribution, or sharing is prohibited.

For educational use within authorized institutions only.
