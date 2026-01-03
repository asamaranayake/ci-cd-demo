# Task Manager API - CI/CD Demo Project

## Overview

This is a complete Spring Boot REST API project demonstrating **Continuous Integration (CI)** and **Continuous Deployment (CD)** practices using Jenkins. The project includes a fully functional Task Manager API with comprehensive tests, CI/CD pipelines, and local deployment automation.

## 🎓 For Students: Hands-On Lab Activity

**New to CI/CD?** Start here:
- **[CI/CD Lab Activity](CI_CD_LAB_ACTIVITY.md)** - Complete 4-hour beginner-friendly lab guide
- **[Local Run Guide](LOCAL_RUN_GUIDE.md)** - Run the application without Jenkins
- **[CI vs CD Explained](CI_VS_CD_EXPLAINED.md)** - Understand the concepts
- **[API Examples](API_EXAMPLES.md)** - Test all API endpoints

This project is designed for students with **zero CI/CD knowledge**. Follow the lab activity for step-by-step instructions!

## Project Structure

```
ci-cd-demo/
├── src/
│   ├── main/
│   │   ├── java/com/nvq/demo/
│   │   │   ├── TaskManagerApplication.java    # Main application class
│   │   │   ├── controller/
│   │   │   │   └── TaskController.java        # REST API endpoints
│   │   │   ├── service/
│   │   │   │   └── TaskService.java           # Business logic
│   │   │   └── model/
│   │   │       └── Task.java                  # Task entity
│   │   └── resources/
│   │       └── application.properties         # Configuration
│   └── test/
│       └── java/com/nvq/demo/                 # Unit & Integration tests
├── deployment/
│   ├── deploy-local-mac.sh                    # Mac/Linux deployment script
│   └── deploy-local-windows.bat               # Windows deployment script
├── Jenkinsfile.beginner                       # Simplified pipeline for learning
├── Jenkinsfile                                # Advanced pipeline
├── pom.xml                                    # Maven build configuration
├── CI_CD_LAB_ACTIVITY.md                      # 4-hour hands-on lab guide
├── LOCAL_RUN_GUIDE.md                         # Run locally without Jenkins
├── CI_VS_CD_EXPLAINED.md                      # Conceptual explanation
└── API_EXAMPLES.md                            # API testing examples
```

## API Endpoints

### Task Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | Get all tasks |
| GET | `/api/tasks?status=TODO` | Get tasks by status |
| GET | `/api/tasks/{id}` | Get task by ID |
| POST | `/api/tasks` | Create new task |
| PUT | `/api/tasks/{id}` | Update task |
| DELETE | `/api/tasks/{id}` | Delete task |
| GET | `/api/tasks/stats` | Get task statistics |

### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/actuator/health` | Application health status |
| GET | `/actuator/info` | Application information |

## Quick Start

### Option 1: For Beginners - Follow the Lab Activity

**Start here if you're new to CI/CD:**
1. Follow the [CI/CD Lab Activity](CI_CD_LAB_ACTIVITY.md) for complete step-by-step instructions
2. The lab covers:
   - Prerequisites installation (Java, Maven, Git, Jenkins)
   - Jenkins setup and configuration
   - Creating your first CI/CD pipeline
   - Deploying to your local machine
   - Testing the deployed application

### Option 2: Quick Local Run (No Jenkins)

**If you just want to run the application:**

See the [Local Run Guide](LOCAL_RUN_GUIDE.md) for detailed instructions, or:

```bash
# Clone the repository
git clone https://github.com/asamaranayake/ci-cd-demo.git
cd ci-cd-demo

# Build and run
mvn clean package
mvn spring-boot:run

# Or run the JAR file
java -jar target/task-manager-api-1.0.0.jar
```

The application will start on `http://localhost:8080`

### Prerequisites

| Tool | Version | Required For | Installation Guide |
|------|---------|--------------|-------------------|
| Java JDK | 17+ | Running application | [Lab Activity - Session 1](CI_CD_LAB_ACTIVITY.md#step-11-install-java-jdk-17-15-minutes) |
| Maven | 3.6+ | Building project | [Lab Activity - Session 1](CI_CD_LAB_ACTIVITY.md#step-12-install-maven-10-minutes) |
| Git | Any | Version control | [Lab Activity - Session 1](CI_CD_LAB_ACTIVITY.md#step-13-install-git-5-minutes) |
| Jenkins | Latest LTS | CI/CD automation | [Lab Activity - Session 2](CI_CD_LAB_ACTIVITY.md#session-2-jenkins-installation--configuration) |

### Testing the API

See [API_EXAMPLES.md](API_EXAMPLES.md) for complete API documentation and examples.

Quick test:
```bash
# Health check
curl http://localhost:8080/actuator/health

# Get all tasks
curl http://localhost:8080/api/tasks

# Create a new task
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Task",
    "description": "Learn CI/CD with Jenkins",
    "status": "TODO",
    "assignee": "Student"
  }'
```

---

## Jenkins CI/CD Pipeline

### For Beginners: Simplified Pipeline

We provide a beginner-friendly pipeline with only essential stages:

**File:** [Jenkinsfile.beginner](Jenkinsfile.beginner)

**Stages:**
1. **Checkout** - Get code from Git
2. **Build** - Compile Java code
3. **Test** - Run unit tests
4. **Package** - Create JAR file
5. **Deploy** - Deploy to local machine
6. **Verify** - Check application health

**Setup Instructions:** Follow the [CI/CD Lab Activity](CI_CD_LAB_ACTIVITY.md)

### For Advanced Users: Full Pipeline

**File:** [Jenkinsfile](Jenkinsfile)

Additional features:
- Multiple environment deployment (Dev/Staging/Production)
- Code quality analysis (SonarQube integration available)
- Security scanning
- Manual approval gates
- Comprehensive post-deployment testing

---

## Understanding CI/CD Concepts

For a detailed explanation of CI vs CD, see [CI_VS_CD_EXPLAINED.md](CI_VS_CD_EXPLAINED.md)

### Quick Summary

**CI (Continuous Integration):**
- Automates: Build + Test
- Output: JAR file (not running)
- Purpose: Verify code quality
- When: Every code commit

**CD (Continuous Deployment):**
- Automates: Deploy + Run
- Output: Running application
- Purpose: Make app accessible
- When: After CI passes

**The Key Difference:**
- After CI: You have a JAR file ✓ (but application is NOT running ✗)
- After CD: Application is RUNNING ✓ (users can access it ✓)

#### 3. Unit Tests
```groovy
stage('Unit Tests') {
    steps {
        sh 'mvn test'
    }
    post {
        always {
            junit '**/target/surefire-reports/*.xml'
            jacoco(...)
        }
    }
}
```
- Runs all unit tests
- Generates test reports
- Calculates code coverage
- **Fails the pipeline if tests fail**

#### 4. Code Quality Analysis
```groovy
stage('Code Quality Analysis') {
    steps {
        // SonarQube integration
    }
}
```
- Analyzes code quality
- Checks for code smells
- Identifies potential bugs
- Ensures coding standards

#### 5. Package
```groovy
stage('Package') {
    steps {
        sh 'mvn package -DskipTests'
    }
    post {
        success {
            archiveArtifacts artifacts: '**/target/*.jar'
        }
    }
}
```
- Creates executable JAR file
- Archives build artifacts
- Prepares for deployment

#### 6. Security Scan
```groovy
stage('Security Scan') {
    steps {
        // OWASP Dependency Check
    }
}
```
- Scans dependencies for vulnerabilities
- Identifies security risks
- Generates security reports

### CD Stages (Continuous Deployment)

#### 7. Deploy to Development
```groovy
stage('Deploy to Development') {
    when {
        branch 'develop'
    }
    steps {
        // Automatic deployment
    }
}
```
- **Automatically** deploys to dev environment
- Triggered on commits to `develop` branch
- No manual approval required

#### 8. Deploy to Staging
```groovy
stage('Deploy to Staging') {
    when {
        branch 'staging'
    }
    steps {
        input message: 'Deploy to Staging?'
        // Deploy after approval
    }
}
```
- Requires **manual approval**
- Triggered on commits to `staging` branch
- Used for QA testing

#### 9. Deploy to Production
```groovy
stage('Deploy to Production') {
    when {
        branch 'main'
    }
    steps {
        input message: 'Deploy to Production?', submitter: 'admin'
        // Production deployment with rollback
    }
}
```
- Requires **admin approval**
- Only from `main` branch
- Blue-green deployment strategy
- Rollback capability

#### 10. Post-Deployment Tests
```groovy
stage('Post-Deployment Tests') {
    steps {
        // Smoke tests
        sh 'curl -f http://localhost:8080/actuator/health'
    }
}
```
- Verifies deployment success
- Runs smoke tests
- Checks application health
- **Triggers rollback if fails**

---

## Local Deployment Options

### Option 1: Manual Maven Run (Development)

Best for development and quick testing:

```bash
# Run with Maven
mvn spring-boot:run

# Or run the JAR directly
java -jar target/task-manager-api-1.0.0.jar
```

**Pros:** Quick and simple  
**Cons:** Must manually restart after changes

### Option 2: Automated Deployment Script (Jenkins CD)

Used by the Jenkins CD pipeline:

**For Mac/Linux:**
```bash
# Make script executable
chmod +x deployment/deploy-local-mac.sh

# Deploy application
./deployment/deploy-local-mac.sh
```

**For Windows:**
```cmd
REM Deploy application
deployment\deploy-local-windows.bat
```

**Features:**
- Automatic process management (stops old, starts new)
- Port availability checking
- Health check verification
- Logging to file
- PID tracking for easy management

**View logs:**
- Mac/Linux: `tail -f /tmp/task-manager/application.log`
- Windows: `type C:\task-manager\application.log`

**Stop application:**
- Mac/Linux: `kill $(cat /tmp/task-manager/application.pid)`
- Windows: Find PID in `C:\task-manager\application.pid` and use Task Manager

### Option 3: Background Process (Simple)

Run in background manually:

**Mac/Linux:**
```bash
# Start in background
nohup java -jar target/task-manager-api-1.0.0.jar > app.log 2>&1 &

# Get PID
echo $! > app.pid

# Stop later
kill $(cat app.pid)
```

**Windows (PowerShell):**
```powershell
# Start in background
Start-Process java -ArgumentList "-jar","target\task-manager-api-1.0.0.jar" -WindowStyle Hidden

# Stop (find in Task Manager or use taskkill)
```

---

## Project Documentation

| Document | Description |
|----------|-------------|
| [CI_CD_LAB_ACTIVITY.md](CI_CD_LAB_ACTIVITY.md) | Complete 4-hour hands-on lab for beginners |
| [LOCAL_RUN_GUIDE.md](LOCAL_RUN_GUIDE.md) | Run application locally without Jenkins |
| [CI_VS_CD_EXPLAINED.md](CI_VS_CD_EXPLAINED.md) | Understand CI vs CD concepts |
| [API_EXAMPLES.md](API_EXAMPLES.md) | API endpoint examples and testing |
| [Jenkinsfile.beginner](Jenkinsfile.beginner) | Simplified pipeline for learning |
| [Jenkinsfile](Jenkinsfile) | Advanced pipeline with all features |

---

## Setting Up Jenkins

### 1. Install Jenkins

```bash
# On Ubuntu/Debian
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Access Jenkins at: `http://localhost:8080`

### 2. Install Required Plugins

In Jenkins, go to **Manage Jenkins** → **Manage Plugins** → **Available**:

- Git Plugin
- Pipeline Plugin
- Maven Integration Plugin
- JUnit Plugin
- JaCoCo Plugin
- Email Extension Plugin (optional)
- SonarQube Scanner (optional)

### 3. Configure Global Tools

**Manage Jenkins** → **Global Tool Configuration**:

#### Configure Maven
- Name: `Maven 3.9.0`
- Install automatically
- Version: 3.9.0

#### Configure JDK
- Name: `JDK 17`
- Install automatically
- Version: Java 17

### 4. Create Pipeline Job

1. Click **New Item**
2. Enter name: `task-manager-ci-cd`
3. Select **Pipeline**
4. Click **OK**

#### Configure Pipeline

**Pipeline Configuration:**
- Definition: `Pipeline script from SCM`
- SCM: `Git`
- Repository URL: Your Git repository URL
- Branch: `*/main` (or your default branch)
- Script Path: `Jenkinsfile`

**Build Triggers:**
- ☑ Poll SCM: `H/5 * * * *` (check every 5 minutes)
- Or configure webhooks for instant triggers

**Save** the configuration

### 5. Run the Pipeline

1. Click **Build Now**
2. Watch the pipeline execute
3. View stage results
4. Check test reports
5. Review code coverage

## Testing the Complete CI/CD Flow

### Step-by-Step Workflow

#### 1. Make a Code Change

```bash
# Create a new branch
git checkout -b feature/add-priority

# Make changes to the code
# (Example: Add priority field to Task model)

# Commit changes
git add .
git commit -m "Add priority field to tasks"

# Push to repository
git push origin feature/add-priority
```

#### 2. Create Pull Request

- Create PR from `feature/add-priority` to `develop`
- Jenkins automatically builds and tests
- Review test results and code coverage
- Merge if all checks pass

#### 3. Development Deployment

```bash
# Merge to develop branch
git checkout develop
git merge feature/add-priority
git push origin develop
```

- Jenkins detects commit to `develop`
- Runs full CI pipeline
- **Automatically deploys to dev environment**
- No manual approval needed

#### 4. Staging Deployment

```bash
# When ready for QA
git checkout staging
git merge develop
git push origin staging
```

- Jenkins detects commit to `staging`
- Runs full CI pipeline
- **Prompts for approval** before deploying
- Click "Proceed" in Jenkins UI
- Deploys to staging environment

#### 5. Production Deployment

```bash
# When ready for production
git checkout main
git merge staging
git push origin main
```

- Jenkins detects commit to `main`
- Runs full CI pipeline
- **Requires admin approval**
- Uses blue-green deployment
- Runs smoke tests
- Keeps old version for rollback

## Monitoring and Troubleshooting

### View Application Logs

```bash
# If using deployment script
tail -f /opt/applications/task-manager/app.log

# If using systemd
sudo journalctl -u task-manager -f

# If using Docker
docker logs -f task-manager
```

### Check Application Health

```bash
# Health endpoint
curl http://localhost:8080/actuator/health

# Metrics endpoint
curl http://localhost:8080/actuator/metrics
```

### Common Issues

#### Build Fails
- Check Jenkins console output
- Verify Java and Maven versions
- Review compilation errors
- Check dependency issues

#### Tests Fail
- Review test reports in Jenkins
- Check JUnit test results
- Examine code coverage reports
- Fix failing tests before merging

#### Deployment Fails
- Check deployment logs
- Verify server connectivity
- Ensure sufficient disk space
- Check file permissions
- Verify port availability

#### Rollback Procedure

```bash
# Using deployment script
./deployment/deploy.sh rollback

# Or manually in Jenkins
# Click on the stage
# Select "Rollback"
```

## Best Practices Demonstrated

### 1. Version Control
- Feature branches for development
- Pull requests for code review
- Branch protection rules
- Semantic commit messages

### 2. Automated Testing
- Comprehensive unit tests
- Integration tests
- Code coverage reporting
- Test-driven development

### 3. Code Quality
- Static code analysis
- Code style enforcement
- Security scanning
- Documentation

### 4. Deployment Strategy
- Environment segregation (dev/staging/prod)
- Manual approvals for critical environments
- Blue-green deployment
- Rollback capability
- Health checks

### 5. Monitoring
- Application health checks
- Logging and metrics
- Failure notifications
- Performance monitoring

## Key Learning Points

### CI Benefits You'll Experience
1. **Fast Feedback**: Know immediately if your code breaks
2. **Quality Assurance**: Automated tests catch bugs early
3. **Integration Confidence**: Code integrates smoothly
4. **Documentation**: Pipeline serves as deployment documentation

### CD Benefits You'll Experience
1. **Faster Releases**: Deploy multiple times per day
2. **Reduced Risk**: Small, incremental changes
3. **Quick Rollback**: Easily revert if issues arise
4. **Consistency**: Same process every time

### Pipeline Features
- **Parallel Execution**: Multiple stages run simultaneously
- **Conditional Deployment**: Different rules per environment
- **Artifact Management**: Build once, deploy many times
- **Approval Gates**: Human oversight where needed

## Extending the Project

### Add Database Persistence
- Integrate with MySQL/PostgreSQL
- Update tests for database operations
- Add database migration scripts

### Add Security
- Implement Spring Security
- Add JWT authentication
- Configure HTTPS

### Add Monitoring
- Integrate Prometheus metrics
- Set up Grafana dashboards
- Configure alerts

### Add More Environments
- Add UAT environment
- Configure canary deployments
- Implement A/B testing

## Resources

### Documentation
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Maven Documentation](https://maven.apache.org/guides/)

### Tools
- Jenkins: https://www.jenkins.io/
- SonarQube: https://www.sonarqube.org/
- Docker: https://www.docker.com/

## Conclusion

This project provides a complete, working example of CI/CD practices. You can:

1. **Understand** the CI/CD workflow
2. **Practice** with real tools and code
3. **Learn** industry best practices
4. **Extend** for your own projects

The pipeline is production-ready and follows enterprise standards for software delivery automation.

---

**Happy Learning and Building!**
