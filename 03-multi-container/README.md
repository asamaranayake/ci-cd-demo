# Multi-Container Application with Docker Compose

## Quick Start

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Test backend
curl http://localhost:3000/api/health
curl http://localhost:3000/api/todos

# Visit frontend
# Open: http://localhost

# Stop everything
docker-compose down
```

## Architecture

```
Frontend (Nginx on port 80)
    ↓
Backend API (Node.js on port 3000)
    ↓
Database (PostgreSQL)
```

## Services

- **Frontend**: Nginx serving HTML/CSS/JS
- **Backend**: Node.js Express API
- **Database**: PostgreSQL for data persistence

## What This Example Teaches

✅ Multi-service orchestration with Docker Compose
✅ Service dependencies and startup order
✅ Environment variables and configuration
✅ Networking between containers
✅ Health checks
✅ Data persistence with volumes
✅ Inter-service communication

## Testing

```bash
# Get all todos
curl http://localhost:3000/api/todos

# Add a todo
curl -X POST http://localhost:3000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"My new todo"}'

# Check health
curl http://localhost:3000/api/health
```

## Stopping and Removing

```bash
# Stop services (data persists)
docker-compose stop

# Start again
docker-compose start

# Stop and remove containers (data persists)
docker-compose down

# Stop, remove, and delete volumes
docker-compose down -v
```
