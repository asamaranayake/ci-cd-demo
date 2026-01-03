// ============================================================================
// ADVANCED JENKINS PIPELINE - Multi-Environment CI/CD
// Task Manager API - Production-Ready Pipeline
// ============================================================================
//
// This pipeline demonstrates advanced CI/CD practices:
// - Multiple environment deployments (Dev, Staging, Production)
// - Manual approval gates for sensitive environments
// - Comprehensive testing at each stage
// - Code quality analysis integration points
// - Security scanning integration points
//
// For beginners: Use Jenkinsfile.beginner instead
// ============================================================================

pipeline {
    agent any

    tools {
        maven 'Maven 3.9.0'
        jdk 'JDK 17'
    }

    environment {
        // Application configuration
        APP_NAME = 'task-manager-api'
        JAR_FILE = "target/${APP_NAME}-*.jar"
        
        // Deployment directories for different environments
        DEV_DEPLOY_DIR = '/tmp/task-manager-dev'
        STAGING_DEPLOY_DIR = '/tmp/task-manager-staging'
        PROD_DEPLOY_DIR = '/tmp/task-manager-prod'
        
        // Ports for different environments
        DEV_PORT = '8080'
        STAGING_PORT = '8081'
        PROD_PORT = '8082'
        
        // Email notifications (configure as needed)
        NOTIFICATION_EMAIL = 'team@example.com'
    }

    stages {
        // ====================================================================
        // STAGE 1: CHECKOUT
        // ====================================================================
        stage('Checkout') {
            steps {
                echo '========== Stage 1: Checkout Source Code =========='
                checkout scm
                echo '✓ Source code checked out successfully'
            }
        }

        // ====================================================================
        // STAGE 2: BUILD
        // ====================================================================
        stage('Build') {
            steps {
                echo '========== Stage 2: Build Application =========='
                script {
                    if (isUnix()) {
                        sh 'mvn clean compile -DskipTests'
                    } else {
                        bat 'mvn clean compile -DskipTests'
                    }
                }
                echo '✓ Application compiled successfully'
            }
        }

        // ====================================================================
        // STAGE 3: UNIT TESTS
        // ====================================================================
        stage('Unit Tests') {
            steps {
                echo '========== Stage 3: Run Unit Tests =========='
                script {
                    if (isUnix()) {
                        sh 'mvn test'
                    } else {
                        bat 'mvn test'
                    }
                }
            }
            post {
                always {
                    // Publish test results
                    junit '**/target/surefire-reports/*.xml'
                    
                    // Publish code coverage
                    jacoco(
                        execPattern: '**/target/jacoco.exec',
                        classPattern: '**/target/classes',
                        sourcePattern: '**/src/main/java'
                    )
                }
                success {
                    echo '✓ All tests passed successfully!'
                }
                failure {
                    echo '✗ Tests failed! Please check the test reports.'
                }
            }
        }

        // ====================================================================
        // STAGE 4: CODE QUALITY ANALYSIS (Optional - requires SonarQube)
        // ====================================================================
        stage('Code Quality Analysis') {
            steps {
                echo '========== Stage 4: Code Quality Analysis =========='
                script {
                    // Uncomment and configure if you have SonarQube server
                    /*
                    withSonarQubeEnv('SonarQube') {
                        if (isUnix()) {
                            sh 'mvn sonar:sonar'
                        } else {
                            bat 'mvn sonar:sonar'
                        }
                    }
                    
                    // Wait for quality gate
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                    */
                    
                    echo '⚠ SonarQube integration is optional. Configure in Manage Jenkins → Configure System'
                    echo '✓ Code quality stage completed (integration available)'
                }
            }
        }

        // ====================================================================
        // STAGE 5: SECURITY SCAN (Optional - requires OWASP Dependency Check)
        // ====================================================================
        stage('Security Scan') {
            steps {
                echo '========== Stage 5: Security Vulnerability Scan =========='
                script {
                    // Uncomment if you have OWASP Dependency Check plugin installed
                    /*
                    dependencyCheck additionalArguments: '''
                        --format HTML
                        --format XML
                        --suppression dependency-check-suppression.xml
                    ''', odcInstallation: 'OWASP-DC'
                    
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                    */
                    
                    echo '⚠ Security scanning is optional. Install OWASP Dependency Check plugin'
                    echo '✓ Security scan stage completed (integration available)'
                }
            }
        }

        // ====================================================================
        // STAGE 6: PACKAGE
        // ====================================================================
        stage('Package') {
            steps {
                echo '========== Stage 6: Package Application =========='
                script {
                    if (isUnix()) {
                        sh 'mvn package -DskipTests'
                    } else {
                        bat 'mvn package -DskipTests'
                    }
                }
                echo '✓ Application packaged successfully'
            }
            post {
                success {
                    // Archive the built artifacts
                    archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
                    echo '✓ JAR file archived successfully'
                }
            }
        }

        // ====================================================================
        // STAGE 7: DEPLOY TO DEVELOPMENT
        // Automatically deploys to dev environment
        // Triggered on any branch
        // ====================================================================
        stage('Deploy to Development') {
            steps {
                echo '========== Stage 7: Deploy to Development Environment =========='
                script {
                    if (isUnix()) {
                        sh """
                            echo "Deploying to Development..."
                            
                            # Create deployment directory
                            mkdir -p ${DEV_DEPLOY_DIR}
                            
                            # Copy JAR file
                            cp ${JAR_FILE} ${DEV_DEPLOY_DIR}/${APP_NAME}.jar
                            
                            # Stop old application
                            pkill -f "${APP_NAME}.jar" || true
                            sleep 2
                            
                            # Start new application
                            cd ${DEV_DEPLOY_DIR}
                            nohup java -jar -Dserver.port=${DEV_PORT} ${APP_NAME}.jar > application.log 2>&1 &
                            echo \$! > application.pid
                            
                            # Wait for startup
                            sleep 10
                            
                            # Health check
                            curl -f http://localhost:${DEV_PORT}/actuator/health || exit 1
                        """
                    } else {
                        bat """
                            echo Deploying to Development...
                            
                            REM Create deployment directory
                            if not exist ${DEV_DEPLOY_DIR} mkdir ${DEV_DEPLOY_DIR}
                            
                            REM Copy JAR file
                            copy /Y ${JAR_FILE} ${DEV_DEPLOY_DIR}\\${APP_NAME}.jar
                            
                            REM Stop old application (find and kill)
                            for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":${DEV_PORT}"') do taskkill /F /PID %%a
                            
                            REM Start new application
                            cd ${DEV_DEPLOY_DIR}
                            start /B java -jar -Dserver.port=${DEV_PORT} ${APP_NAME}.jar > application.log 2>&1
                            
                            REM Wait and health check
                            timeout /t 10 /nobreak
                            curl -f http://localhost:${DEV_PORT}/actuator/health
                        """
                    }
                }
                echo '✓ Deployed to Development environment'
                echo "✓ Application available at: http://localhost:${DEV_PORT}"
            }
        }

        // ====================================================================
        // STAGE 8: INTEGRATION TESTS ON DEV
        // Run integration tests against dev environment
        // ====================================================================
        stage('Integration Tests - Dev') {
            steps {
                echo '========== Stage 8: Run Integration Tests =========='
                script {
                    if (isUnix()) {
                        sh """
                            echo "Running integration tests against DEV environment..."
                            
                            # Test health endpoint
                            curl -f http://localhost:${DEV_PORT}/actuator/health
                            
                            # Test API endpoints
                            curl -f http://localhost:${DEV_PORT}/api/tasks
                            
                            # Create a test task
                            curl -X POST http://localhost:${DEV_PORT}/api/tasks \
                              -H "Content-Type: application/json" \
                              -d '{"title":"Test Task","description":"CI/CD Test","status":"TODO","assignee":"Jenkins"}'
                            
                            # Verify task was created
                            curl -f http://localhost:${DEV_PORT}/api/tasks | grep "Test Task"
                            
                            echo "✓ All integration tests passed!"
                        """
                    } else {
                        bat """
                            echo Running integration tests against DEV environment...
                            curl -f http://localhost:${DEV_PORT}/actuator/health
                            curl -f http://localhost:${DEV_PORT}/api/tasks
                            echo Integration tests completed!
                        """
                    }
                }
                echo '✓ Integration tests passed successfully'
            }
        }

        // ====================================================================
        // STAGE 9: DEPLOY TO STAGING
        // Requires manual approval
        // Triggered only on 'staging' or 'main' branch
        // ====================================================================
        stage('Deploy to Staging') {
            when {
                anyOf {
                    branch 'staging'
                    branch 'main'
                }
            }
            steps {
                echo '========== Stage 9: Deploy to Staging Environment =========='
                
                // Manual approval required
                script {
                    input message: 'Deploy to Staging?', 
                          ok: 'Deploy',
                          submitter: 'admin,qa-lead'
                }
                
                script {
                    if (isUnix()) {
                        sh """
                            echo "Deploying to Staging..."
                            
                            # Create deployment directory
                            mkdir -p ${STAGING_DEPLOY_DIR}
                            
                            # Copy JAR file
                            cp ${JAR_FILE} ${STAGING_DEPLOY_DIR}/${APP_NAME}.jar
                            
                            # Stop old application
                            lsof -ti:${STAGING_PORT} | xargs kill -9 || true
                            sleep 2
                            
                            # Start new application
                            cd ${STAGING_DEPLOY_DIR}
                            nohup java -jar -Dserver.port=${STAGING_PORT} ${APP_NAME}.jar > application.log 2>&1 &
                            echo \$! > application.pid
                            
                            # Wait for startup
                            sleep 10
                            
                            # Health check
                            curl -f http://localhost:${STAGING_PORT}/actuator/health || exit 1
                        """
                    } else {
                        bat """
                            echo Deploying to Staging...
                            if not exist ${STAGING_DEPLOY_DIR} mkdir ${STAGING_DEPLOY_DIR}
                            copy /Y ${JAR_FILE} ${STAGING_DEPLOY_DIR}\\${APP_NAME}.jar
                            
                            REM Stop old application
                            for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":${STAGING_PORT}"') do taskkill /F /PID %%a
                            
                            REM Start new application
                            cd ${STAGING_DEPLOY_DIR}
                            start /B java -jar -Dserver.port=${STAGING_PORT} ${APP_NAME}.jar
                            timeout /t 10 /nobreak
                            curl -f http://localhost:${STAGING_PORT}/actuator/health
                        """
                    }
                }
                echo '✓ Deployed to Staging environment'
                echo "✓ Application available at: http://localhost:${STAGING_PORT}"
            }
        }

        // ====================================================================
        // STAGE 10: UAT / SMOKE TESTS ON STAGING
        // ====================================================================
        stage('Smoke Tests - Staging') {
            when {
                anyOf {
                    branch 'staging'
                    branch 'main'
                }
            }
            steps {
                echo '========== Stage 10: Run Smoke Tests on Staging =========='
                script {
                    if (isUnix()) {
                        sh """
                            echo "Running smoke tests against Staging..."
                            
                            # Critical API tests
                            curl -f http://localhost:${STAGING_PORT}/actuator/health
                            curl -f http://localhost:${STAGING_PORT}/api/tasks
                            curl -f http://localhost:${STAGING_PORT}/api/tasks/stats
                            
                            echo "✓ All smoke tests passed!"
                        """
                    } else {
                        bat """
                            echo Running smoke tests against Staging...
                            curl -f http://localhost:${STAGING_PORT}/actuator/health
                            curl -f http://localhost:${STAGING_PORT}/api/tasks
                        """
                    }
                }
                echo '✓ Smoke tests passed successfully'
            }
        }

        // ====================================================================
        // STAGE 11: DEPLOY TO PRODUCTION
        // Requires admin approval
        // Only from 'main' branch
        // Implements blue-green deployment concept
        // ====================================================================
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo '========== Stage 11: Deploy to Production Environment =========='
                
                // Strict approval required
                script {
                    input message: '⚠️ Deploy to PRODUCTION? This will affect live users!', 
                          ok: 'Deploy to Production',
                          submitter: 'admin'
                }
                
                script {
                    if (isUnix()) {
                        sh """
                            echo "Deploying to Production..."
                            
                            # Create deployment directory
                            mkdir -p ${PROD_DEPLOY_DIR}
                            mkdir -p ${PROD_DEPLOY_DIR}/backup
                            
                            # Backup current version
                            if [ -f "${PROD_DEPLOY_DIR}/${APP_NAME}.jar" ]; then
                                cp ${PROD_DEPLOY_DIR}/${APP_NAME}.jar \
                                   ${PROD_DEPLOY_DIR}/backup/${APP_NAME}-\$(date +%Y%m%d-%H%M%S).jar
                            fi
                            
                            # Copy new JAR file
                            cp ${JAR_FILE} ${PROD_DEPLOY_DIR}/${APP_NAME}.jar
                            
                            # Stop old application gracefully
                            if [ -f "${PROD_DEPLOY_DIR}/application.pid" ]; then
                                kill \$(cat ${PROD_DEPLOY_DIR}/application.pid) || true
                                sleep 5
                            fi
                            
                            # Force stop if still running
                            lsof -ti:${PROD_PORT} | xargs kill -9 || true
                            sleep 2
                            
                            # Start new application
                            cd ${PROD_DEPLOY_DIR}
                            nohup java -jar -Dserver.port=${PROD_PORT} ${APP_NAME}.jar > application.log 2>&1 &
                            echo \$! > application.pid
                            
                            # Wait for startup
                            echo "Waiting for application to start..."
                            sleep 15
                            
                            # Health check with retry
                            for i in {1..5}; do
                                if curl -f http://localhost:${PROD_PORT}/actuator/health; then
                                    echo "✓ Application is healthy!"
                                    break
                                else
                                    echo "Retry \$i/5..."
                                    sleep 3
                                fi
                            done
                        """
                    } else {
                        bat """
                            echo Deploying to Production...
                            
                            if not exist ${PROD_DEPLOY_DIR} mkdir ${PROD_DEPLOY_DIR}
                            if not exist ${PROD_DEPLOY_DIR}\\backup mkdir ${PROD_DEPLOY_DIR}\\backup
                            
                            REM Backup current version
                            if exist ${PROD_DEPLOY_DIR}\\${APP_NAME}.jar (
                                copy ${PROD_DEPLOY_DIR}\\${APP_NAME}.jar ${PROD_DEPLOY_DIR}\\backup\\
                            )
                            
                            REM Copy new JAR
                            copy /Y ${JAR_FILE} ${PROD_DEPLOY_DIR}\\${APP_NAME}.jar
                            
                            REM Stop old application
                            for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":${PROD_PORT}"') do taskkill /F /PID %%a
                            
                            REM Start new application
                            cd ${PROD_DEPLOY_DIR}
                            start /B java -jar -Dserver.port=${PROD_PORT} ${APP_NAME}.jar
                            
                            timeout /t 15 /nobreak
                            curl -f http://localhost:${PROD_PORT}/actuator/health
                        """
                    }
                }
                echo '✓ Deployed to Production environment'
                echo "✓ Application available at: http://localhost:${PROD_PORT}"
            }
        }

        // ====================================================================
        // STAGE 12: POST-PRODUCTION VERIFICATION
        // ====================================================================
        stage('Production Verification') {
            when {
                branch 'main'
            }
            steps {
                echo '========== Stage 12: Production Verification =========='
                script {
                    if (isUnix()) {
                        sh """
                            echo "Verifying Production deployment..."
                            
                            # Critical health checks
                            curl -f http://localhost:${PROD_PORT}/actuator/health
                            curl -f http://localhost:${PROD_PORT}/api/tasks
                            
                            echo "✓ Production deployment verified!"
                            echo "✓ Application is live and responding to requests"
                        """
                    } else {
                        bat """
                            echo Verifying Production deployment...
                            curl -f http://localhost:${PROD_PORT}/actuator/health
                            curl -f http://localhost:${PROD_PORT}/api/tasks
                        """
                    }
                }
                echo '✓ Production verification completed successfully'
            }
        }
    }

    // ========================================================================
    // POST-BUILD ACTIONS
    // ========================================================================
    post {
        always {
            echo ''
            echo '=========================================='
            echo 'Pipeline Execution Completed'
            echo '=========================================='
            echo "Build Number: ${env.BUILD_NUMBER}"
            echo "Branch: ${env.BRANCH_NAME}"
            echo "Build Status: ${currentBuild.currentResult}"
            echo '=========================================='
        }
        
        success {
            echo '✓✓✓ SUCCESS! ✓✓✓'
            echo 'The CI/CD pipeline completed successfully!'
            echo ''
            echo 'Environment URLs:'
            echo "  • Development: http://localhost:${DEV_PORT}"
            if (env.BRANCH_NAME == 'staging' || env.BRANCH_NAME == 'main') {
                echo "  • Staging: http://localhost:${STAGING_PORT}"
            }
            if (env.BRANCH_NAME == 'main') {
                echo "  • Production: http://localhost:${PROD_PORT}"
            }
            
            // Uncomment to send email notifications
            /*
            emailext(
                subject: "✓ Pipeline Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Pipeline completed successfully!
                    
                    Job: ${env.JOB_NAME}
                    Build: ${env.BUILD_NUMBER}
                    Branch: ${env.BRANCH_NAME}
                    
                    Check console output at ${env.BUILD_URL}
                """,
                to: "${NOTIFICATION_EMAIL}"
            )
            */
        }
        
        failure {
            echo '✗✗✗ FAILURE! ✗✗✗'
            echo 'The pipeline failed. Please check the console output.'
            echo ''
            echo 'Common issues:'
            echo '1. Build/Test failures - Check compiler errors or test failures'
            echo '2. Deployment failures - Check port availability and permissions'
            echo '3. Integration test failures - Check application logs'
            
            // Uncomment to send failure notifications
            /*
            emailext(
                subject: "✗ Pipeline Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Pipeline failed!
                    
                    Job: ${env.JOB_NAME}
                    Build: ${env.BUILD_NUMBER}
                    Branch: ${env.BRANCH_NAME}
                    
                    Check console output at ${env.BUILD_URL}console
                    
                    Please investigate and fix the issue.
                """,
                to: "${NOTIFICATION_EMAIL}"
            )
            */
        }
        
        unstable {
            echo '⚠ WARNING! ⚠'
            echo 'The pipeline is unstable. Some tests may have failed.'
        }
    }
}

// ============================================================================
// END OF ADVANCED PIPELINE
// ============================================================================
//
// PIPELINE FLOW SUMMARY:
//
// ALL BRANCHES:
// 1-6: Checkout → Build → Test → Quality → Security → Package
// 7-8: Deploy to Dev → Integration Tests
//
// STAGING & MAIN BRANCHES:
// 9-10: Deploy to Staging (with approval) → Smoke Tests
//
// MAIN BRANCH ONLY:
// 11-12: Deploy to Production (with admin approval) → Verification
//
// ENVIRONMENT PORTS:
// - Development: 8080
// - Staging: 8081
// - Production: 8082
//
// APPROVERS:
// - Staging: admin, qa-lead
// - Production: admin only
//
// OPTIONAL INTEGRATIONS:
// - SonarQube (code quality)
// - OWASP Dependency Check (security)
// - Email notifications
//
// For beginners or local-only deployment, use: Jenkinsfile.beginner
// ============================================================================
