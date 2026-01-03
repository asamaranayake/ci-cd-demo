# Local Run Guide - Task Manager API

## Quick Start (Without Jenkins)

This guide shows you how to run the Task Manager API on your local machine **without** using Jenkins. This is useful for:
- Testing the application before setting up CI/CD
- Development and debugging
- Understanding what the CI/CD pipeline automates

---

## Prerequisites

Before running the application, ensure you have:

| Tool | Minimum Version | Check Command |
|------|-----------------|---------------|
| Java | 17 or higher | `java -version` |
| Maven | 3.6 or higher | `mvn -version` |
| Git | Any recent version | `git --version` |

---

## Step 1: Get the Code

### Clone from GitHub

```bash
# Clone the repository
git clone <YOUR-GITHUB-REPO-URL>
cd ci-cd-demo
```

### Or if you already have the code

```bash
# Navigate to the project directory
cd /path/to/ci-cd-demo
```

---

## Step 2: Build the Application

### For Mac/Linux

```bash
# Clean any previous builds and compile
mvn clean compile

# Expected output:
# [INFO] BUILD SUCCESS
```

### For Windows (Command Prompt or PowerShell)

```cmd
REM Clean any previous builds and compile
mvn clean compile

REM Expected output:
REM [INFO] BUILD SUCCESS
```

### What This Does
- Downloads all required dependencies (libraries)
- Compiles Java source code (.java → .class files)
- Validates your setup is correct

---

## Step 3: Run Tests (Optional but Recommended)

### For Mac/Linux

```bash
# Run all unit tests
mvn test

# Expected output:
# Tests run: X, Failures: 0, Errors: 0, Skipped: 0
# [INFO] BUILD SUCCESS
```

### For Windows

```cmd
REM Run all unit tests
mvn test

REM Expected output:
REM Tests run: X, Failures: 0, Errors: 0, Skipped: 0
REM [INFO] BUILD SUCCESS
```

### What This Does
- Runs all JUnit tests
- Verifies application logic is working
- Generates test reports in `target/surefire-reports/`

---

## Step 4: Package the Application

### For Mac/Linux

```bash
# Create JAR file
mvn package

# The JAR file will be created at:
# target/task-manager-api-1.0.0.jar
```

### For Windows

```cmd
REM Create JAR file
mvn package

REM The JAR file will be created at:
REM target\task-manager-api-1.0.0.jar
```

### What This Does
- Compiles code (if not already done)
- Runs tests (if not already done)
- Packages everything into an executable JAR file

---

## Step 5: Run the Application

You have **two options** to run the application:

### Option 1: Run with Maven (Recommended for Development)

#### For Mac/Linux

```bash
# Run directly with Maven
mvn spring-boot:run

# Application will start on port 8080
# Wait for: "Started TaskManagerApplication in X seconds"
```

#### For Windows

```cmd
REM Run directly with Maven
mvn spring-boot:run

REM Application will start on port 8080
REM Wait for: "Started TaskManagerApplication in X seconds"
```

**Advantages:**
- ✓ Quick and easy
- ✓ Auto-reloads on code changes (with Spring DevTools)
- ✓ No need to rebuild JAR for every change

**Disadvantage:**
- ✗ Slower startup than JAR

---

### Option 2: Run the JAR File (Recommended for Production)

#### For Mac/Linux

```bash
# First, package the application (if not done)
mvn package

# Then run the JAR file
java -jar target/task-manager-api-1.0.0.jar

# Application will start on port 8080
```

#### For Windows

```cmd
REM First, package the application (if not done)
mvn package

REM Then run the JAR file
java -jar target\task-manager-api-1.0.0.jar

REM Application will start on port 8080
```

**Advantages:**
- ✓ Faster startup
- ✓ This is how it runs in production
- ✓ Single file to deploy

**Disadvantage:**
- ✗ Need to rebuild JAR after every code change

---

## Step 6: Verify the Application is Running

### Health Check

#### For Mac/Linux

```bash
# Check if application is healthy
curl http://localhost:8080/actuator/health

# Expected response:
# {"status":"UP"}
```

#### For Windows (PowerShell)

```powershell
# Check if application is healthy
Invoke-WebRequest -Uri http://localhost:8080/actuator/health

# Or use curl if installed:
curl http://localhost:8080/actuator/health

# Expected response:
# {"status":"UP"}
```

#### For Windows (Command Prompt)

```cmd
REM Open in browser:
start http://localhost:8080/actuator/health

REM Expected to see in browser:
REM {"status":"UP"}
```

### Test the API

#### For Mac/Linux

```bash
# Get all tasks
curl http://localhost:8080/api/tasks

# Create a new task
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Task",
    "description": "Testing the API",
    "status": "TODO",
    "assignee": "Me"
  }'
```

#### For Windows (PowerShell)

```powershell
# Get all tasks
Invoke-RestMethod -Uri http://localhost:8080/api/tasks

# Create a new task
$body = @{
    title = "Test Task"
    description = "Testing the API"
    status = "TODO"
    assignee = "Me"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:8080/api/tasks `
  -Method POST `
  -ContentType "application/json" `
  -Body $body
```

#### Or Use Browser

Simply open: `http://localhost:8080/api/tasks` in your web browser

---

## Step 7: Stop the Application

### If Running with Maven or JAR

#### For Mac/Linux

```bash
# Press Ctrl+C in the terminal where the app is running

# Or, if running in background, find and kill the process:
lsof -i :8080
# Note the PID, then:
kill <PID>
```

#### For Windows

```cmd
REM Press Ctrl+C in the command prompt where the app is running

REM Or, if you need to force stop:
netstat -ano | findstr :8080
REM Note the PID, then:
taskkill /PID <PID> /F
```

---

## Common Commands Cheat Sheet

### Mac/Linux

| Task | Command |
|------|---------|
| Clean build | `mvn clean` |
| Compile only | `mvn compile` |
| Run tests | `mvn test` |
| Create JAR | `mvn package` |
| Run with Maven | `mvn spring-boot:run` |
| Run JAR | `java -jar target/task-manager-api-1.0.0.jar` |
| Check port 8080 | `lsof -i :8080` |
| Kill process on port | `lsof -ti :8080 \| xargs kill` |

### Windows

| Task | Command |
|------|---------|
| Clean build | `mvn clean` |
| Compile only | `mvn compile` |
| Run tests | `mvn test` |
| Create JAR | `mvn package` |
| Run with Maven | `mvn spring-boot:run` |
| Run JAR | `java -jar target\task-manager-api-1.0.0.jar` |
| Check port 8080 | `netstat -ano \| findstr :8080` |
| Kill process | `taskkill /PID <PID> /F` |

---

## Troubleshooting

### Problem: "mvn: command not found" or "'mvn' is not recognized"

**Solution:**
1. Verify Maven is installed: Download from https://maven.apache.org/download.cgi
2. Add Maven to PATH:
   - **Mac/Linux:** Add to `~/.bashrc` or `~/.zshrc`:
     ```bash
     export PATH="/path/to/maven/bin:$PATH"
     ```
   - **Windows:** 
     - Right-click "This PC" → Properties → Advanced System Settings
     - Environment Variables → System Variables → Path → Edit
     - Add: `C:\path\to\maven\bin`

### Problem: "java: command not found" or "'java' is not recognized"

**Solution:**
1. Verify Java is installed: Download from https://adoptium.net/
2. Add Java to PATH similar to Maven above
3. Set JAVA_HOME environment variable:
   - **Mac/Linux:** `export JAVA_HOME=/path/to/jdk-17`
   - **Windows:** Add system variable `JAVA_HOME=C:\path\to\jdk-17`

### Problem: Port 8080 already in use

**Error Message:**
```
Port 8080 was already in use
```

**Solution:**

**Mac/Linux:**
```bash
# Find what's using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>
```

**Windows:**
```cmd
REM Find what's using port 8080
netstat -ano | findstr :8080

REM Kill the process
taskkill /PID <PID> /F
```

**Or change the port:**

Edit `src/main/resources/application.properties`:
```properties
server.port=8081
```

Then access app at: http://localhost:8081

### Problem: Tests fail during build

**Error Message:**
```
Tests run: X, Failures: Y
```

**Solution:**
1. Check test output in `target/surefire-reports/`
2. Read error messages carefully
3. Fix the code or tests
4. Re-run: `mvn test`

### Problem: Build fails with "Cannot resolve dependencies"

**Error Message:**
```
Could not resolve dependencies
```

**Solution:**
1. Check internet connection
2. Try cleaning Maven cache:
   ```bash
   mvn dependency:purge-local-repository
   ```
3. Delete `~/.m2/repository` (Mac/Linux) or `C:\Users\<username>\.m2\repository` (Windows)
4. Run `mvn clean install` again

---

## What's Next?

Now that you can run the application locally, you're ready to:

1. **Learn CI/CD:** See [CI_CD_LAB_ACTIVITY.md](CI_CD_LAB_ACTIVITY.md) to automate this process with Jenkins

2. **Explore the API:** See [API_EXAMPLES.md](API_EXAMPLES.md) for all available endpoints

3. **Understand CI vs CD:** Read [CI_VS_CD_EXPLAINED.md](CI_VS_CD_EXPLAINED.md) to understand the concepts

4. **Make Changes:** Try modifying the code and re-running to see your changes

---

## Project Structure Reference

```
ci-cd-demo/
├── src/
│   ├── main/
│   │   ├── java/              ← Java source code
│   │   └── resources/         ← Configuration files
│   └── test/                  ← Test files
├── target/                    ← Build output (created after mvn package)
│   ├── classes/               ← Compiled .class files
│   ├── test-classes/          ← Compiled test .class files
│   ├── surefire-reports/      ← Test reports
│   └── *.jar                  ← Executable JAR file
├── pom.xml                    ← Maven configuration
└── README.md                  ← Project documentation
```

---

## Summary

✅ **To run locally without Jenkins:**
```bash
mvn clean package
java -jar target/task-manager-api-1.0.0.jar
```

✅ **To run for development:**
```bash
mvn spring-boot:run
```

✅ **To verify it's working:**
```bash
curl http://localhost:8080/actuator/health
```

That's it! You now know how to run the application manually. The CI/CD pipeline automates all these steps for you! 🚀

---

**Ready for CI/CD?** → Go to [CI_CD_LAB_ACTIVITY.md](CI_CD_LAB_ACTIVITY.md)
