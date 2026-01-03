# Real-World Multi-Environment Deployment

## Enterprise Environment Setup

In actual development organizations, applications are NOT deployed directly to production. They go through multiple environments for testing and validation.

---

## Standard Environment Hierarchy

```
┌──────────────────────────────────────────────────────────────────┐
│                    ENVIRONMENT PIPELINE                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Developer Laptop  →  DEV  →  QA/TEST  →  UAT  →  PRODUCTION    │
│                       ↓        ↓           ↓          ↓          │
│                    Auto     Auto/Manual  Manual    Manual        │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Environment Details

| Environment | Purpose | Who Uses It | Deployment | Uptime | Data |
|-------------|---------|-------------|------------|--------|------|
| **DEV** | Development & Integration | Developers | Automatic | Can be down | Fake/Sample |
| **QA/TEST** | Quality Assurance Testing | QA Team | Semi-Auto | Stable | Test Data |
| **UAT** | User Acceptance Testing | Business Users | Manual | Highly Stable | Production-like |
| **STAGING** | Pre-production Validation | DevOps/QA | Manual | Production-like | Production Copy |
| **PRODUCTION** | Live User Access | End Users | Manual (Approved) | 99.9%+ | Real Data |

---

## Real-World Server Setup

### Typical Enterprise Infrastructure

```
┌─────────────────────────────────────────────────────────────────────┐
│                        JENKINS SERVER                                │
│                     jenkins.company.com                              │
│              (Runs CI/CD Pipelines - No App Running)                │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
                    Deploys to different servers
                                ↓
    ┌──────────────┬──────────────┬──────────────┬──────────────┐
    ↓              ↓              ↓              ↓              ↓
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│   DEV   │  │   QA    │  │   UAT   │  │ STAGING │  │  PROD   │
│ Server  │  │ Server  │  │ Server  │  │ Server  │  │ Server  │
├─────────┤  ├─────────┤  ├─────────┤  ├─────────┤  ├─────────┤
│ dev-    │  │ qa-     │  │ uat-    │  │ staging-│  │ prod-   │
│ app01   │  │ app01   │  │ app01   │  │ app01   │  │ app01   │
│         │  │         │  │         │  │         │  │ app02   │
│ Port    │  │ Port    │  │ Port    │  │ Port    │  │ (Load   │
│ 8080    │  │ 8080    │  │ 8080    │  │ 8080    │  │ Balanced)│
└─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘

http://      http://      http://      http://      https://
dev-app      qa-app       uat-app      staging-app  api.company
.internal    .internal    .internal    .internal    .com
:8080        :8080        :8080        :8080
```

---

## Complete Real-World CI/CD Flow

### 1. Developer Workflow

```bash
# Developer on their laptop
git checkout -b feature/new-api-endpoint
# ... write code ...
mvn spring-boot:run  # Test locally on laptop
curl http://localhost:8080/api/tasks  # ✓ Works locally

# Commit and push
git add .
git commit -m "Add new API endpoint"
git push origin feature/new-api-endpoint
```

**Status:** Application running ONLY on developer's laptop

---

### 2. DEV Environment (Development)

```
┌─────────────────────────────────────────────────────────────────┐
│                      DEV ENVIRONMENT                             │
│                   dev-app01.internal:8080                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Trigger: Push to 'develop' branch                              │
│  Jenkins Pipeline:                                               │
│    1. CI Stages (Build, Test, Package) → Creates JAR            │
│    2. CD Stage: Deploy to DEV                                   │
│       - SSH to dev-app01.internal                               │
│       - Copy JAR to /opt/apps/task-manager/                     │
│       - Run: systemctl restart task-manager-dev                 │
│    3. Application NOW RUNNING on dev-app01                      │
│                                                                  │
│  ✓ Developers can test: http://dev-app01.internal:8080         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

#### Jenkins Pipeline for DEV

```groovy
stage('Deploy to DEV') {
    when {
        branch 'develop'
    }
    steps {
        script {
            // Deploy to DEV server
            sh """
                # Copy JAR to DEV server
                scp target/task-manager-api.jar jenkins@dev-app01:/tmp/

                # SSH and deploy
                ssh jenkins@dev-app01 << 'ENDSSH'
                    sudo cp /tmp/task-manager-api.jar /opt/apps/task-manager/
                    sudo systemctl restart task-manager-dev

                    # Wait for application to start
                    sleep 10

                    # Verify deployment
                    curl -f http://localhost:8080/actuator/health || exit 1
ENDSSH
            """

            echo "✓ Deployed to DEV: http://dev-app01.internal:8080"
        }
    }
}
```

**Who Accesses:** Developers for integration testing
**Application Running On:** dev-app01.internal server
**Deployment:** Automatic (no approval needed)

---

### 3. QA Environment (Quality Assurance)

```
┌─────────────────────────────────────────────────────────────────┐
│                       QA ENVIRONMENT                             │
│                   qa-app01.internal:8080                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Trigger: Push to 'qa' branch (or manual promotion from dev)    │
│  Jenkins Pipeline:                                               │
│    1. CI Stages (Build, Test, Package)                          │
│    2. CD Stage: Deploy to QA                                    │
│       - Prompt: "Deploy to QA?" [Approve/Reject]                │
│       - If approved:                                             │
│         * SSH to qa-app01.internal                              │
│         * Deploy JAR                                             │
│         * Restart service                                        │
│    3. Application RUNNING on qa-app01                           │
│                                                                  │
│  ✓ QA Team tests: http://qa-app01.internal:8080                │
│  ✓ Run automated test suites                                    │
│  ✓ Manual exploratory testing                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

#### Jenkins Pipeline for QA

```groovy
stage('Deploy to QA') {
    when {
        branch 'qa'
    }
    steps {
        script {
            // Optional approval
            input message: 'Deploy to QA Environment?',
                  ok: 'Deploy',
                  submitter: 'dev-team'

            // Deploy to QA server
            sh """
                scp target/task-manager-api.jar jenkins@qa-app01:/tmp/

                ssh jenkins@qa-app01 << 'ENDSSH'
                    # Stop current version
                    sudo systemctl stop task-manager-qa

                    # Backup current version
                    sudo cp /opt/apps/task-manager/task-manager-api.jar \
                           /opt/apps/task-manager/backups/task-manager-api.jar.\$(date +%Y%m%d_%H%M%S)

                    # Deploy new version
                    sudo cp /tmp/task-manager-api.jar /opt/apps/task-manager/
                    sudo systemctl start task-manager-qa

                    # Health check
                    sleep 10
                    curl -f http://localhost:8080/actuator/health || exit 1
ENDSSH
            """

            // Run automated tests against QA
            sh """
                # Run API integration tests
                mvn verify -Dtest.url=http://qa-app01.internal:8080
            """

            echo "✓ Deployed to QA: http://qa-app01.internal:8080"
        }
    }
    post {
        success {
            // Notify QA team
            emailext to: 'qa-team@company.com',
                     subject: "QA Deployment Ready for Testing",
                     body: "New build deployed to QA environment"
        }
    }
}
```

**Who Accesses:** QA Team for functional testing
**Application Running On:** qa-app01.internal server
**Deployment:** Semi-automatic (requires approval)

---

### 4. UAT Environment (User Acceptance Testing)

```
┌─────────────────────────────────────────────────────────────────┐
│                      UAT ENVIRONMENT                             │
│                   uat-app01.internal:8080                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Trigger: Manual promotion from QA (after QA sign-off)          │
│  Jenkins Pipeline:                                               │
│    1. Use SAME JAR that passed QA (no rebuild)                  │
│    2. CD Stage: Deploy to UAT                                   │
│       - Require approval from QA Lead                           │
│       - SSH to uat-app01.internal                               │
│       - Deploy tested JAR from QA                               │
│       - Run smoke tests                                          │
│    3. Application RUNNING on uat-app01                          │
│                                                                  │
│  ✓ Business users test: http://uat-app01.internal:8080         │
│  ✓ Validate business requirements                               │
│  ✓ Sign-off for production                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

#### Jenkins Pipeline for UAT

```groovy
stage('Deploy to UAT') {
    when {
        branch 'uat'
    }
    steps {
        script {
            // Require QA sign-off
            input message: 'QA Testing Complete. Deploy to UAT?',
                  ok: 'Deploy to UAT',
                  submitter: 'qa-lead'

            // Use artifact from successful QA build
            copyArtifacts projectName: 'task-manager-pipeline',
                         filter: 'target/task-manager-api.jar',
                         selector: lastSuccessful()

            // Deploy to UAT server
            sh """
                scp target/task-manager-api.jar jenkins@uat-app01:/tmp/

                ssh jenkins@uat-app01 << 'ENDSSH'
                    # Create backup
                    sudo cp /opt/apps/task-manager/task-manager-api.jar \
                           /opt/apps/task-manager/backups/

                    # Deploy
                    sudo systemctl stop task-manager-uat
                    sudo cp /tmp/task-manager-api.jar /opt/apps/task-manager/
                    sudo systemctl start task-manager-uat

                    # Verify
                    sleep 15
                    curl -f http://localhost:8080/actuator/health || exit 1
ENDSSH
            """

            echo "✓ Deployed to UAT: http://uat-app01.internal:8080"
        }
    }
    post {
        success {
            emailext to: 'business-users@company.com',
                     subject: "UAT Environment Ready",
                     body: "Please test: http://uat-app01.internal:8080"
        }
    }
}
```

**Who Accesses:** Business users, Product owners
**Application Running On:** uat-app01.internal server
**Deployment:** Manual (requires QA approval)

---

### 5. Production Environment

```
┌─────────────────────────────────────────────────────────────────┐
│                   PRODUCTION ENVIRONMENT                         │
│              https://api.company.com (Load Balanced)            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Trigger: Manual promotion from UAT (after UAT sign-off)        │
│  Jenkins Pipeline:                                               │
│    1. Use SAME JAR that passed UAT (no rebuild)                 │
│    2. CD Stage: Deploy to Production                            │
│       - Require approval from Release Manager                   │
│       - Create deployment ticket                                 │
│       - Blue-Green Deployment:                                   │
│         * Deploy to inactive server (prod-app02)                │
│         * Run health checks                                      │
│         * Switch load balancer                                   │
│         * Keep old version (prod-app01) for rollback            │
│                                                                  │
│  ✓ End users access: https://api.company.com                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

#### Jenkins Pipeline for Production

```groovy
stage('Deploy to Production') {
    when {
        branch 'main'
    }
    steps {
        script {
            // Require multiple approvals
            input message: 'UAT Sign-off Complete. Deploy to PRODUCTION?',
                  ok: 'Deploy to Production',
                  submitter: 'release-manager,cto'

            // Create change ticket
            sh """
                # Create change request in ServiceNow/Jira
                curl -X POST https://ticketing.company.com/api/change-request \
                     -H "Authorization: Bearer \${TICKET_TOKEN}" \
                     -d '{"type":"deployment","app":"task-manager","version":"1.0.0"}'
            """

            // Blue-Green Deployment
            sh """
                # Deploy to BLUE server (inactive)
                scp target/task-manager-api.jar jenkins@prod-app02:/tmp/

                ssh jenkins@prod-app02 << 'ENDSSH'
                    # Deploy to blue server
                    sudo systemctl stop task-manager
                    sudo cp /tmp/task-manager-api.jar /opt/apps/task-manager/
                    sudo systemctl start task-manager

                    # Wait and verify
                    sleep 20
                    curl -f http://localhost:8080/actuator/health || exit 1

                    # Run smoke tests
                    curl -f http://localhost:8080/api/tasks || exit 1
ENDSSH

                # Switch load balancer to blue server
                curl -X POST https://loadbalancer.company.com/api/switch \
                     -H "Authorization: Bearer \${LB_TOKEN}" \
                     -d '{"active_server":"prod-app02"}'

                # Verify production traffic
                sleep 30
                curl -f https://api.company.com/actuator/health || exit 1
            """

            echo "✓ Deployed to PRODUCTION: https://api.company.com"
        }
    }
    post {
        success {
            // Notify stakeholders
            emailext to: 'engineering@company.com,support@company.com',
                     subject: "Production Deployment Successful - v1.0.0",
                     body: "Task Manager API v1.0.0 is now live"

            // Update monitoring
            sh """
                curl -X POST https://monitoring.company.com/api/deployment \
                     -d '{"app":"task-manager","version":"1.0.0","status":"deployed"}'
            """
        }
        failure {
            // Automatic rollback
            sh """
                echo "Deployment failed! Rolling back..."

                # Switch load balancer back to green server
                curl -X POST https://loadbalancer.company.com/api/switch \
                     -H "Authorization: Bearer \${LB_TOKEN}" \
                     -d '{"active_server":"prod-app01"}'
            """

            emailext to: 'engineering@company.com,oncall@company.com',
                     subject: "URGENT: Production Deployment Failed",
                     body: "Automatic rollback initiated"
        }
    }
}
```

**Who Accesses:** End users (customers)
**Application Running On:** prod-app01, prod-app02 (load balanced)
**Deployment:** Manual (requires senior approval)
**Strategy:** Blue-Green deployment with automatic rollback

---

## Environment Configuration

### Different Configurations Per Environment

Each environment uses different configuration:

#### application-dev.properties
```properties
# DEV Environment
server.port=8080
spring.profiles.active=dev

# Database (DEV)
spring.datasource.url=jdbc:mysql://dev-db.internal:3306/taskmanager_dev
spring.datasource.username=dev_user
spring.datasource.password=dev_password

# Logging
logging.level.com.nvq.demo=DEBUG

# Feature Flags
features.new-api-endpoint=true
```

#### application-qa.properties
```properties
# QA Environment
server.port=8080
spring.profiles.active=qa

# Database (QA)
spring.datasource.url=jdbc:mysql://qa-db.internal:3306/taskmanager_qa
spring.datasource.username=qa_user
spring.datasource.password=qa_password

# Logging
logging.level.com.nvq.demo=INFO

# Feature Flags
features.new-api-endpoint=true
```

#### application-production.properties
```properties
# PRODUCTION Environment
server.port=8080
spring.profiles.active=production

# Database (Production - Read Replica)
spring.datasource.url=jdbc:mysql://prod-db-primary.internal:3306/taskmanager
spring.datasource.username=prod_user
spring.datasource.password=${DB_PASSWORD}  # From secrets manager

# Logging
logging.level.com.nvq.demo=WARN

# Feature Flags
features.new-api-endpoint=false  # Disabled until fully tested

# Production optimizations
server.tomcat.max-threads=200
spring.jpa.show-sql=false
```

---

## Complete Multi-Environment Jenkinsfile

```groovy
pipeline {
    agent any

    tools {
        maven 'Maven 3.9.0'
        jdk 'JDK 17'
    }

    environment {
        APP_NAME = 'task-manager-api'

        // Server configurations
        DEV_SERVER = 'jenkins@dev-app01.internal'
        QA_SERVER = 'jenkins@qa-app01.internal'
        UAT_SERVER = 'jenkins@uat-app01.internal'
        PROD_SERVER_BLUE = 'jenkins@prod-app02.internal'
        PROD_SERVER_GREEN = 'jenkins@prod-app01.internal'
    }

    stages {
        // ===== CI STAGES (Same for all branches) =====

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                    jacoco execPattern: '**/target/jacoco.exec'
                }
            }
        }

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

        // ===== CD STAGES (Environment-specific) =====

        stage('Deploy to DEV') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    deployToEnvironment(
                        server: DEV_SERVER,
                        environment: 'dev',
                        port: 8080,
                        profile: 'dev'
                    )
                }
            }
        }

        stage('Deploy to QA') {
            when {
                branch 'qa'
            }
            steps {
                script {
                    input message: 'Deploy to QA?', submitter: 'dev-team'

                    deployToEnvironment(
                        server: QA_SERVER,
                        environment: 'qa',
                        port: 8080,
                        profile: 'qa'
                    )

                    // Run integration tests
                    sh 'mvn verify -Dtest.url=http://qa-app01.internal:8080'
                }
            }
        }

        stage('Deploy to UAT') {
            when {
                branch 'uat'
            }
            steps {
                script {
                    input message: 'QA Approved. Deploy to UAT?',
                          submitter: 'qa-lead'

                    deployToEnvironment(
                        server: UAT_SERVER,
                        environment: 'uat',
                        port: 8080,
                        profile: 'uat'
                    )
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    input message: 'UAT Approved. Deploy to PRODUCTION?',
                          submitter: 'release-manager,cto'

                    // Blue-Green Deployment
                    blueGreenDeploy(
                        blueServer: PROD_SERVER_BLUE,
                        greenServer: PROD_SERVER_GREEN,
                        environment: 'production',
                        profile: 'production'
                    )
                }
            }
        }
    }
}

// Helper function for standard deployment
def deployToEnvironment(Map config) {
    sh """
        scp target/${APP_NAME}*.jar ${config.server}:/tmp/

        ssh ${config.server} << 'ENDSSH'
            sudo systemctl stop ${APP_NAME}-${config.environment}
            sudo cp /tmp/${APP_NAME}*.jar /opt/apps/${APP_NAME}/
            sudo systemctl start ${APP_NAME}-${config.environment}
            sleep 10
            curl -f http://localhost:${config.port}/actuator/health || exit 1
ENDSSH
    """

    echo "✓ Deployed to ${config.environment.toUpperCase()}"
}

// Helper function for blue-green deployment
def blueGreenDeploy(Map config) {
    // Deploy to blue server
    deployToEnvironment(
        server: config.blueServer,
        environment: config.environment,
        port: 8080,
        profile: config.profile
    )

    // Switch load balancer
    sh """
        curl -X POST https://loadbalancer.company.com/api/switch \
             -d '{"active_server":"prod-app02"}'
    """

    echo "✓ Production deployment complete with blue-green strategy"
}
```

---

## Real-World Timeline Example

### Day 1: Development
```
09:00 - Developer commits code
09:05 - Jenkins CI runs (build, test)
09:15 - Jenkins deploys to DEV automatically
09:20 - ✓ Application RUNNING on dev-app01.internal:8080
09:30 - Developers test integration
```

### Day 2: QA Testing
```
10:00 - Code merged to 'qa' branch
10:05 - Jenkins CI runs
10:15 - Team Lead approves QA deployment
10:20 - ✓ Application RUNNING on qa-app01.internal:8080
10:30 - QA team starts testing
14:00 - QA finds bug, deployment fails
15:00 - Bug fixed, redeployed to DEV
```

### Day 3: More QA
```
09:00 - Fixed code deployed to QA
09:15 - ✓ Application RUNNING on qa-app01.internal:8080
       - QA team tests all day
16:00 - ✓ QA Sign-off complete
```

### Day 4: UAT
```
09:00 - QA Lead approves UAT deployment
09:10 - ✓ Application RUNNING on uat-app01.internal:8080
09:30 - Business users test
15:00 - ✓ UAT Sign-off complete
```

### Day 5: Production
```
20:00 - Off-hours deployment window
20:05 - Release Manager approves production
20:10 - Deploy to prod-app02 (blue server)
20:15 - Health checks pass
20:20 - Switch load balancer
20:25 - ✓ Application RUNNING on https://api.company.com
20:30 - Monitor for 30 minutes
21:00 - ✓ Deployment successful
```

---

## Key Differences: Lower Environments vs Production

### Lower Environments (DEV, QA, UAT)
- **Purpose:** Testing and validation
- **Availability:** Can have downtime
- **Data:** Fake or sanitized data
- **Deployment:** Frequent (multiple times per day)
- **Approval:** Minimal or automatic
- **Users:** Internal teams only
- **Infrastructure:** Single server, basic setup
- **Rollback:** Less critical

### Production Environment
- **Purpose:** Serve real users
- **Availability:** 99.9%+ uptime required
- **Data:** Real customer data
- **Deployment:** Controlled (weekly/monthly)
- **Approval:** Multiple stakeholders required
- **Users:** Customers, public
- **Infrastructure:** Load balanced, redundant, clustered
- **Rollback:** Critical capability required

---

## Summary: Where is Application Running?

| Stage | Application Status | Where is it Running? | Who Can Access? |
|-------|-------------------|---------------------|-----------------|
| **After CI** | ❌ NOT running | Nowhere (JAR file exists) | No one |
| **After Deploy to DEV** | ✓ Running | dev-app01.internal:8080 | Developers |
| **After Deploy to QA** | ✓ Running | qa-app01.internal:8080 | QA Team |
| **After Deploy to UAT** | ✓ Running | uat-app01.internal:8080 | Business Users |
| **After Deploy to PROD** | ✓ Running | api.company.com | End Users (Public) |

---

## Key Takeaway

**CI creates the JAR file, but the application only RUNS after CD deploys it to a specific environment server. In real organizations:**

1. **CI runs once** (builds and tests)
2. **CD runs multiple times** (deploys same JAR to DEV → QA → UAT → PROD)
3. Each environment is a **separate server** where the application actually runs
4. The **same JAR** is promoted through environments (not rebuilt)
5. Each environment has **different configurations** but same code

This ensures what you test in QA is exactly what goes to production!
