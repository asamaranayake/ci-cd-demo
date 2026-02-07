# Node.js Express Docker Example

## Build and Run

```bash
# Build image
docker build -t nodejs-app:v1 .

# Run container
docker run -d -p 3000:3000 --name my-nodejs-app nodejs-app:v1

# Test it
curl http://localhost:3000
curl http://localhost:3000/api/data
curl http://localhost:3000/health

# View logs
docker logs my-nodejs-app

# Stop and remove
docker stop my-nodejs-app
docker rm my-nodejs-app
docker rmi nodejs-app:v1
```

## Files Explained

- **Dockerfile** - Instructions to build the image
- **app.js** - Express application code
- **package.json** - Node.js dependencies

## What This Example Teaches

✅ Node.js base image (Alpine variant for size)
✅ npm dependency installation
✅ Express.js framework
✅ Port exposure
✅ Health check endpoint
✅ Environment variables
✅ Production-ready configuration
