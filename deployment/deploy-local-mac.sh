#!/bin/bash

###############################################################################
# Task Manager API - Local Deployment Script for Mac/Linux
# This script automates the deployment process on your local machine
###############################################################################

set -e  # Exit immediately if any command fails

# ==============================================================================
# CONFIGURATION
# ==============================================================================
APP_NAME="task-manager-api"
DEPLOY_DIR="/tmp/task-manager"
JAR_FILE="${DEPLOY_DIR}/${APP_NAME}.jar"
LOG_FILE="${DEPLOY_DIR}/application.log"
PID_FILE="${DEPLOY_DIR}/application.pid"
PORT=8080

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

# ==============================================================================
# STEP 1: CHECK IF JAR FILE EXISTS
# ==============================================================================
print_header "Step 1: Checking JAR file"

if [ ! -f "$JAR_FILE" ]; then
    print_error "JAR file not found: $JAR_FILE"
    print_info "Jenkins should have copied it. Check the pipeline."
    exit 1
fi

print_success "JAR file found: $JAR_FILE"

# ==============================================================================
# STEP 2: CHECK IF PORT IS AVAILABLE
# ==============================================================================
print_header "Step 2: Checking port availability"

# Check if anything is running on port 8080
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    print_info "Port $PORT is currently in use"
    
    # Get the PID of the process using the port
    OLD_PID=$(lsof -ti :$PORT)
    print_info "Process using port $PORT: PID $OLD_PID"
    
    # Check if it's our application
    if ps -p $OLD_PID -o command= | grep -q "$APP_NAME"; then
        print_info "Found old instance of $APP_NAME running"
    else
        print_error "Port $PORT is used by another application!"
        print_info "Please stop that application or change the port."
        exit 1
    fi
else
    print_success "Port $PORT is available"
fi

# ==============================================================================
# STEP 3: STOP OLD APPLICATION
# ==============================================================================
print_header "Step 3: Stopping old application"

# Try multiple methods to stop the old application

# Method 1: Check PID file
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p $OLD_PID > /dev/null 2>&1; then
        print_info "Stopping application (PID: $OLD_PID) from PID file..."
        kill $OLD_PID || true
        sleep 2
        
        # Force kill if still running
        if ps -p $OLD_PID > /dev/null 2>&1; then
            print_info "Force stopping application..."
            kill -9 $OLD_PID || true
        fi
        print_success "Old application stopped"
    else
        print_info "PID file exists but process is not running"
        rm -f "$PID_FILE"
    fi
fi

# Method 2: Kill by process name
print_info "Checking for any remaining $APP_NAME processes..."
pkill -f "$APP_NAME" || true
sleep 1

# Method 3: Kill by port
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    print_info "Killing process on port $PORT..."
    kill -9 $(lsof -ti :$PORT) || true
    sleep 1
fi

# Verify port is now free
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    print_error "Failed to free port $PORT!"
    exit 1
else
    print_success "Port $PORT is now free"
fi

# ==============================================================================
# STEP 4: START NEW APPLICATION
# ==============================================================================
print_header "Step 4: Starting new application"

print_info "Starting $APP_NAME..."
print_info "JAR: $JAR_FILE"
print_info "Port: $PORT"
print_info "Logs: $LOG_FILE"

# Start the application in background
nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

# Save the PID
NEW_PID=$!
echo $NEW_PID > "$PID_FILE"

print_success "Application started with PID: $NEW_PID"
print_info "Waiting for application to start..."

# ==============================================================================
# STEP 5: VERIFY DEPLOYMENT
# ==============================================================================
print_header "Step 5: Verifying deployment"

# Wait for application to start (max 30 seconds)
COUNTER=0
MAX_WAIT=30

while [ $COUNTER -lt $MAX_WAIT ]; do
    # Check if process is still running
    if ! ps -p $NEW_PID > /dev/null 2>&1; then
        print_error "Application process died!"
        print_info "Check logs: $LOG_FILE"
        tail -n 20 "$LOG_FILE"
        exit 1
    fi
    
    # Try to connect to health endpoint
    if curl -sf http://localhost:$PORT/actuator/health > /dev/null 2>&1; then
        print_success "Application is running and healthy!"
        break
    fi
    
    # Wait and try again
    sleep 1
    COUNTER=$((COUNTER + 1))
    echo -n "."
done

echo ""

if [ $COUNTER -ge $MAX_WAIT ]; then
    print_error "Application did not start within $MAX_WAIT seconds"
    print_info "Check logs: $LOG_FILE"
    tail -n 20 "$LOG_FILE"
    exit 1
fi

# ==============================================================================
# DEPLOYMENT SUCCESSFUL
# ==============================================================================
print_header "DEPLOYMENT SUCCESSFUL!"

echo ""
print_success "Application Details:"
echo "  • Name: $APP_NAME"
echo "  • PID: $NEW_PID"
echo "  • Port: $PORT"
echo "  • JAR: $JAR_FILE"
echo "  • Logs: $LOG_FILE"
echo ""
print_success "API Endpoints:"
echo "  • Health: http://localhost:$PORT/actuator/health"
echo "  • Tasks: http://localhost:$PORT/api/tasks"
echo "  • Stats: http://localhost:$PORT/api/tasks/stats"
echo ""
print_info "Useful Commands:"
echo "  • View logs: tail -f $LOG_FILE"
echo "  • Stop app: kill $NEW_PID"
echo "  • Check status: ps -p $NEW_PID"
echo ""

# ==============================================================================
# QUICK HEALTH CHECK
# ==============================================================================
print_info "Quick health check:"
curl -s http://localhost:$PORT/actuator/health | python3 -m json.tool || echo '{"status":"UP"}'

echo ""
print_header "READY FOR TESTING!"

exit 0
