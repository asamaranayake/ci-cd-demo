# Python Flask Docker Example

## Build and Run

```bash
# Build image
docker build -t python-web-app:v1 .

# Run container
docker run -d -p 5000:5000 --name my-python-app python-web-app:v1

# Test it
curl http://localhost:5000
curl http://localhost:5000/api/data
curl http://localhost:5000/health

# View logs
docker logs my-python-app

# Stop and remove
docker stop my-python-app
docker rm my-python-app
docker rmi python-web-app:v1
```

## Files Explained

- **Dockerfile** - Instructions to build the image
- **app.py** - Flask application code
- **requirements.txt** - Python dependencies
- **.dockerignore** - Files to exclude from build

## What This Example Teaches

✅ Base image selection (python:3.9-slim)
✅ Working directory setup
✅ Dependency installation
✅ Application code copying
✅ Port exposure
✅ Health checks
✅ Environment variables
