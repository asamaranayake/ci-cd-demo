# CI/CD with Jenkins - Hands-On Lab Activity
**Module:** DevOps - Continuous Integration & Continuous Deployment (Level 06)  
**Duration:** 4 Hours  
**Target Audience:** Students with Zero CI/CD Knowledge  
**Prerequisites:** Basic Java knowledge, Command line familiarity

---

## 📚 Table of Contents
1. [Introduction to CI/CD](#introduction-to-cicd)
2. [Session 1: Prerequisites & Setup (1 hour)](#session-1-prerequisites--setup)
3. [Session 2: Jenkins Installation & Configuration (1 hour)](#session-2-jenkins-installation--configuration)
4. [Session 3: Building CI Pipeline (1.5 hours)](#session-3-building-ci-pipeline)
5. [Session 4: CD Pipeline & Local Deployment (30 mins)](#session-4-cd-pipeline--local-deployment)

---

## 🎯 Learning Objectives

By the end of this lab, students will be able to:
- Understand what CI/CD is and why it matters
- Install and configure Jenkins on their local machine
- Create a Jenkins pipeline from scratch
- Automate building, testing, and packaging of Java applications
- Deploy applications locally using Jenkins
- Test and verify deployed applications
- Troubleshoot common CI/CD issues

---

## Introduction to CI/CD

### What is CI/CD?

**Simple Definition:** CI/CD is the practice of automating the process of building, testing, and deploying software.

**Real-Life Analogy:**
Think of a car assembly line:
- **Manual Process (No CI/CD):** Each worker builds one complete car by themselves (slow, error-prone)
- **Assembly Line (CI/CD):** Each step is automated and verified, cars are built faster and more consistently

### Why Do We Need CI/CD?

**Without CI/CD:**
1. Developer writes code
2. Manually compiles the code
3. Manually runs tests
4. Manually creates JAR file
5. Manually copies to server
6. Manually starts application
7. ❌ Takes hours, error-prone, boring!

**With CI/CD:**
1. Developer writes code
2. Push to Git
3. ✨ **Everything else happens automatically!** ✨
4. ✓ Takes minutes, consistent, reliable!

### CI vs CD - What's the Difference?

| Aspect | CI (Continuous Integration) | CD (Continuous Deployment) |
|--------|----------------------------|----------------------------|
| **What** | Build + Test | Deploy + Run |
| **When** | Every code commit | After CI passes |
| **Output** | JAR file (not running) | Running application |
| **Purpose** | Verify code works | Make app accessible |
| **Example** | "Your code compiles ✓" | "App live at localhost:8080 ✓" |

### This Lab Project

**Application:** Task Manager REST API  
**Technology:** Java 17 + Spring Boot + Maven  
**CI/CD Tool:** Jenkins  
**Deployment:** Local machine (no cloud/Docker for beginners)

---

## Session 1: Prerequisites & Setup

**Duration:** 1 hour  
**Goal:** Install all required software and verify your setup

### What You Need

| Tool | Version | Purpose |
|------|---------|---------|
| Java JDK | 17 or higher | Run Java applications |
| Maven | 3.6 or higher | Build Java projects |
| Git | Any recent | Version control |
| Jenkins | Latest LTS | CI/CD automation |
| curl | Any | Test APIs |

---

### Step 1.1: Install Java JDK 17 (15 minutes)

#### For Mac Users

**Option 1: Using Homebrew (Recommended)**

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install OpenJDK 17
brew install openjdk@17

# Link it so your system can find it
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# Add to your PATH (add to ~/.zshrc or ~/.bash_profile)
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Option 2: Manual Download**

1. Visit: https://adoptium.net/
2. Download: macOS, JDK 17 (LTS), .pkg file
3. Run the installer
4. Follow the installation wizard

#### For Windows Users

**Step-by-Step Installation:**

1. Visit: https://adoptium.net/
2. Select:
   - **Operating System:** Windows
   - **Version:** 17 (LTS)
   - **JVM:** HotSpot
   - **Architecture:** x64
3. Download the `.msi` installer
4. Run the installer
5. **Important:** Check ✓ "Set JAVA_HOME variable"
6. **Important:** Check ✓ "Add to PATH"
7. Click "Install"

**Verify Installation (Both Mac & Windows):**

```bash
# Check Java version
java -version

# Expected output (version may vary slightly):
# openjdk version "17.0.x" 2024-xx-xx
# OpenJDK Runtime Environment Temurin-17.0.x
# OpenJDK 64-Bit Server VM Temurin-17.0.x

# Check Java compiler
javac -version

# Expected output:
# javac 17.0.x
```

**✅ Success Criteria:**
- `java -version` shows version 17 or higher
- `javac -version` shows version 17 or higher

**❌ Troubleshooting:**

If commands not found:

**Mac:**
```bash
# Find Java installation
/usr/libexec/java_home -V

# Set JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH

# Add to ~/.zshrc to make permanent
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
```

**Windows:**
1. Search for "Environment Variables" in Windows
2. Click "Environment Variables" button
3. Under "System Variables", click "New"
4. Variable name: `JAVA_HOME`
5. Variable value: `C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot`
6. Edit "Path" variable, add: `%JAVA_HOME%\bin`
7. Click OK, open NEW command prompt and try again

---

### Step 1.2: Install Maven (10 minutes)

#### For Mac Users

```bash
# Using Homebrew
brew install maven

# Verify installation
mvn -version
```

#### For Windows Users

**Step-by-Step Installation:**

1. Visit: https://maven.apache.org/download.cgi
2. Download: `apache-maven-3.9.x-bin.zip` (Binary zip archive)
3. Extract to: `C:\Program Files\Apache\maven`
4. Add to PATH:
   - Search "Environment Variables"
   - System Variables → Path → Edit → New
   - Add: `C:\Program Files\Apache\maven\bin`
5. Click OK and restart Command Prompt

**Verify Installation (Both Platforms):**

```bash
mvn -version

# Expected output:
# Apache Maven 3.9.x
# Maven home: /path/to/maven
# Java version: 17.0.x
```

**✅ Success Criteria:**
- `mvn -version` shows Maven 3.6 or higher
- Shows Java version 17

---

### Step 1.3: Install Git (5 minutes)

#### For Mac Users

```bash
# Using Homebrew
brew install git

# Verify
git --version
```

#### For Windows Users

1. Download from: https://git-scm.com/download/win
2. Run installer with default options
3. Verify:

```cmd
git --version
```

**✅ Success Criteria:**
- `git --version` shows any recent version

---

### Step 1.4: Get the Project Code (10 minutes)

#### Clone the Repository

**For Mac/Linux:**

```bash
# Create a projects directory
mkdir -p ~/projects
cd ~/projects

# Clone the repository
git clone https://github.com/asamaranayake/ci-cd-demo.git

# Navigate to project
cd ci-cd-demo

# Verify files are there
ls -la
```

**For Windows:**

```cmd
REM Create a projects directory
mkdir C:\projects
cd C:\projects

REM Clone the repository
git clone https://github.com/asamaranayake/ci-cd-demo.git

REM Navigate to project
cd ci-cd-demo

REM Verify files are there
dir
```

**Expected Files:**
```
ci-cd-demo/
├── src/                    ← Java source code
├── deployment/             ← Deployment scripts
├── pom.xml                 ← Maven configuration
├── Jenkinsfile.beginner    ← Pipeline for beginners
├── LOCAL_RUN_GUIDE.md      ← Running without Jenkins
└── README.md               ← Project documentation
```

---

### Step 1.5: Test Build the Project (15 minutes)

Let's make sure everything works before we set up Jenkins!

#### Build and Run Tests

**For Mac/Linux:**

```bash
# Navigate to project directory
cd ~/projects/ci-cd-demo

# Clean and compile
mvn clean compile

# This should show:
# [INFO] BUILD SUCCESS

# Run tests
mvn test

# This should show:
# Tests run: X, Failures: 0, Errors: 0
# [INFO] BUILD SUCCESS

# Package the application
mvn package

# This creates: target/task-manager-api-1.0.0.jar
```

**For Windows:**

```cmd
REM Navigate to project directory
cd C:\projects\ci-cd-demo

REM Clean and compile
mvn clean compile

REM Run tests
mvn test

REM Package the application
mvn package
```

**✅ Success Criteria:**
- All commands complete with `[INFO] BUILD SUCCESS`
- No compilation errors
- All tests pass
- JAR file created at `target/task-manager-api-1.0.0.jar`

**❌ Troubleshooting:**

**Problem: Tests fail**
```
[ERROR] Tests run: 5, Failures: 1, Errors: 0
```

**Solution:**
- This is OK for now! We'll fix it later
- For testing purposes, you can skip tests:
  ```bash
  mvn package -DskipTests
  ```

**Problem: Can't download dependencies**
```
[ERROR] Failed to execute goal... Could not resolve dependencies
```

**Solution:**
- Check internet connection
- Maven needs to download libraries on first run
- Try again: `mvn clean install -U`

---

### Step 1.6: Run the Application Locally (10 minutes)

Before automating with Jenkins, let's run the app manually to understand what we're automating!

**For Mac/Linux:**

```bash
# Option 1: Run with Maven
mvn spring-boot:run

# OR Option 2: Run the JAR file
java -jar target/task-manager-api-1.0.0.jar
```

**For Windows:**

```cmd
REM Option 1: Run with Maven
mvn spring-boot:run

REM OR Option 2: Run the JAR file
java -jar target\task-manager-api-1.0.0.jar
```

**Wait for this message:**
```
Started TaskManagerApplication in X.XXX seconds
```

**Test the Application:**

Open a NEW terminal/command prompt (keep the app running in the first one):

**Mac/Linux:**
```bash
# Test health endpoint
curl http://localhost:8080/actuator/health

# Expected: {"status":"UP"}

# Test API endpoint
curl http://localhost:8080/api/tasks

# Expected: [] (empty array, no tasks yet)
```

**Windows (PowerShell):**
```powershell
# Test health endpoint
Invoke-RestMethod http://localhost:8080/actuator/health

# Test API endpoint
Invoke-RestMethod http://localhost:8080/api/tasks
```

**Or use your web browser:**
- Visit: http://localhost:8080/actuator/health
- Visit: http://localhost:8080/api/tasks

**Stop the application:**
- Press `Ctrl+C` in the terminal where it's running

**✅ Success Criteria:**
- Application starts without errors
- Health endpoint returns `{"status":"UP"}`
- API endpoints are accessible
- You can stop it with Ctrl+C

---

### 🎓 Session 1 Exercise: Verify Your Setup (5 minutes)

**Complete this checklist:**

- [ ] Java 17 installed - `java -version` works
- [ ] Maven installed - `mvn -version` works
- [ ] Git installed - `git --version` works
- [ ] Project cloned - `ci-cd-demo/` directory exists
- [ ] Build successful - `mvn package` works
- [ ] Application runs - Can access http://localhost:8080/actuator/health
- [ ] Application stops - Ctrl+C works

**✓ If all boxes checked:** You're ready for Session 2!  
**✗ If any failed:** Ask instructor for help before continuing

---

## Session 2: Jenkins Installation & Configuration

**Duration:** 1 hour  
**Goal:** Install Jenkins and configure it for our project

### What is Jenkins?

**Simple Definition:** Jenkins is a tool that automatically builds, tests, and deploys your code whenever you make changes.

**Analogy:** Think of Jenkins as a robot that watches your code and automatically does all the boring, repetitive tasks for you!

---

### Step 2.1: Install Jenkins (20 minutes)

#### For Mac Users

**Option 1: Using Homebrew (Easiest)**

```bash
# Install Jenkins LTS (Long Term Support)
brew install jenkins-lts

# Start Jenkins as a service
brew services start jenkins-lts

# Jenkins will start on: http://localhost:8080
# Wait about 1-2 minutes for Jenkins to start
```

**Option 2: Manual Download**

1. Visit: https://www.jenkins.io/download/
2. Download: macOS Generic Java package (.war file)
3. Run Jenkins:
   ```bash
   java -jar jenkins.war --httpPort=8080
   ```

#### For Windows Users

**Step-by-Step Installation:**

1. Visit: https://www.jenkins.io/download/
2. Click: "Windows" → Download LTS `.msi` installer
3. Run the installer
4. Installation Options:
   - **Service Port:** 8080 (default)
   - **Java Home:** Should auto-detect your JDK 17
   - **Logon Type:** Run as "Local System"
5. Click "Install"
6. Jenkins will start automatically

**Verify Jenkins is Running:**

Open your web browser and go to:
```
http://localhost:8080
```

You should see Jenkins unlock screen!

**✅ Success Criteria:**
- Browser shows "Unlock Jenkins" page
- No error messages

**❌ Troubleshooting:**

**Problem: "Site can't be reached" or Connection refused**

**Solution:**
- Jenkins is still starting (wait 2-3 minutes)
- Check if port 8080 is used by something else:
  
  **Mac:**
  ```bash
  lsof -i :8080
  ```
  
  **Windows:**
  ```cmd
  netstat -ano | findstr :8080
  ```
  
- If another app uses 8080, stop it or change Jenkins port:
  **Mac:** `brew services stop jenkins-lts` then start with different port
  **Windows:** Reinstall and choose different port (e.g., 8081)

---

### Step 2.2: Initial Jenkins Setup (15 minutes)

#### Unlock Jenkins

**[SCREENSHOT PLACEHOLDER: Jenkins Unlock Screen]**

You'll see: "Unlock Jenkins - To ensure Jenkins is securely set up..."

**Get the Initial Admin Password:**

**For Mac:**
```bash
# Method 1: Read the password file
cat ~/.jenkins/secrets/initialAdminPassword

# Method 2: Check Jenkins logs
brew services info jenkins-lts
cat /opt/homebrew/var/log/jenkins-lts/jenkins-lts.log
```

**For Windows:**
```cmd
REM The installer shows you the path, typically:
type C:\Users\<YourUsername>\.jenkins\secrets\initialAdminPassword

REM Or:
type "C:\Program Files\Jenkins\secrets\initialAdminPassword"
```

**Copy the password and paste it** into the web interface, click "Continue"

#### Install Plugins

**[SCREENSHOT PLACEHOLDER: Customize Jenkins - Plugin Selection Screen]**

You'll see: "Customize Jenkins - Which plugins would you like to install?"

**Choose:** "Install suggested plugins"

This will install essential plugins including:
- Git plugin
- Maven Integration plugin  
- Pipeline plugin
- And many more...

**Wait:** 5-10 minutes for all plugins to install  
☕ Good time for a coffee break!

#### Create Admin User

**[SCREENSHOT PLACEHOLDER: Create First Admin User]**

Fill in the form:
- **Username:** admin (or your name)
- **Password:** Choose a strong password (write it down!)
- **Full name:** Your name
- **Email:** your.email@example.com

Click "Save and Continue"

#### Instance Configuration

**[SCREENSHOT PLACEHOLDER: Instance Configuration]**

**Jenkins URL:** http://localhost:8080/

Click "Save and Finish"

Click "Start using Jenkins"

**🎉 You now see the Jenkins Dashboard!**

**[SCREENSHOT PLACEHOLDER: Jenkins Dashboard - Welcome Screen]**

---

### Step 2.3: Install Required Plugins (10 minutes)

We need a few more plugins for our Java project.

#### Navigate to Plugin Manager

**[SCREENSHOT PLACEHOLDER: Jenkins Dashboard with arrow pointing to "Manage Jenkins"]**

1. Click **"Manage Jenkins"** (left sidebar)
2. Click **"Plugins"** (or "Manage Plugins" on older versions)
3. Click **"Available plugins"** tab

#### Search and Install Plugins

**[SCREENSHOT PLACEHOLDER: Plugin Manager - Available Plugins]**

In the search box, type and select:

1. **"Maven Integration"** - Check the box
2. **"JUnit"** - Check the box  
3. **"JaCoCo"** - Check the box (for code coverage)
4. **"Git"** - Should already be installed

Click **"Install"** button (bottom of page)

**[SCREENSHOT PLACEHOLDER: Plugin Installation Progress]**

Check: ✓ "Restart Jenkins when installation is complete"

Wait for restart (2-3 minutes)

**✅ Success Criteria:**
- All plugins show "Success" status
- Jenkins automatically restarts
- You can log back in

---

### Step 2.4: Configure Global Tools (15 minutes)

Jenkins needs to know where Java and Maven are installed.

#### Configure Maven

**[SCREENSHOT PLACEHOLDER: Manage Jenkins page]**

1. Go to **"Manage Jenkins"** → **"Tools"** (or "Global Tool Configuration")

**[SCREENSHOT PLACEHOLDER: Global Tool Configuration page]**

2. Scroll to **"Maven"** section
3. Click **"Add Maven"**

**[SCREENSHOT PLACEHOLDER: Maven Configuration Form]**

Fill in:
- **Name:** `Maven 3.9.0` (MUST match what's in Jenkinsfile!)
- **Install automatically:** ✓ Check this box
- **Version:** Select latest 3.9.x version
- **Install from Apache:** Keep default

Click **"Apply"** (don't close yet!)

#### Configure JDK

**[SCREENSHOT PLACEHOLDER: JDK Configuration Section]**

1. Scroll to **"JDK"** section  
2. Click **"Add JDK"**

**[SCREENSHOT PLACEHOLDER: JDK Configuration Form]**

Fill in:
- **Name:** `JDK 17` (MUST match what's in Jenkinsfile!)
- **JAVA_HOME:** Path to your JDK installation

**Find JAVA_HOME:**

**Mac:**
```bash
/usr/libexec/java_home -v 17
# Copy the output path
```

**Windows:**
```cmd
echo %JAVA_HOME%
# Or typically: C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot
```

- **Install automatically:** ✗ Uncheck (we already installed it)

Click **"Save"**

**✅ Success Criteria:**
- Maven configured with name "Maven 3.9.0"
- JDK configured with name "JDK 17"
- No error messages

**❌ Common Mistakes:**
- ✗ Wrong names (must match Jenkinsfile exactly!)
- ✗ Typos in JAVA_HOME path
- ✗ Forgot to click "Save"

---

### Step 2.5: Understanding Jenkins Workspace (5 minutes)

**Important Concept:** Jenkins stores everything in a "workspace" directory on your computer.

#### Workspace Location

**Mac/Linux:**
```bash
/Users/<your-username>/.jenkins/workspace/
```

**Windows:**
```
C:\Users\<your-username>\.jenkins\workspace\
```

#### What's in the Workspace?

```
.jenkins/
├── workspace/
│   └── <job-name>/          ← Your project code goes here
│       ├── src/
│       ├── target/          ← Build outputs (JAR files)
│       ├── pom.xml
│       └── ...
├── jobs/
│   └── <job-name>/          ← Job configuration
├── secrets/
├── plugins/
└── logs/
```

**Why This Matters:**
- Jenkins clones your Git repository here
- Builds happen here
- JAR files are created here
- Deployment scripts read from here

**Find Your Workspace:**

**Mac:**
```bash
ls -la ~/.jenkins/workspace/
```

**Windows:**
```cmd
dir C:\Users\%USERNAME%\.jenkins\workspace\
```

Right now it's empty. After we create a job, you'll see a folder for it!

---

### 🎓 Session 2 Exercise: Verify Jenkins Setup (5 minutes)

**Complete this checklist:**

- [ ] Jenkins running at http://localhost:8080
- [ ] Can log in with admin credentials
- [ ] Plugins installed: Maven Integration, JUnit, JaCoCo
- [ ] Maven configured as "Maven 3.9.0"
- [ ] JDK configured as "JDK 17"
- [ ] Know where Jenkins workspace is located

**✓ If all boxes checked:** You're ready for Session 3!  
**✗ If any failed:** Ask instructor for help before continuing

---

## Session 3: Building CI Pipeline

**Duration:** 1.5 hours  
**Goal:** Create your first Jenkins pipeline to automate build and test

### What We'll Build

A pipeline that:
1. ✓ Gets code from Git
2. ✓ Compiles Java code
3. ✓ Runs all tests
4. ✓ Creates JAR file
5. ✓ Shows test results in Jenkins UI

---

### Step 3.1: Create a New Jenkins Job (10 minutes)

#### Create Pipeline Job

**[SCREENSHOT PLACEHOLDER: Jenkins Dashboard]**

1. Click **"New Item"** (top left)

**[SCREENSHOT PLACEHOLDER: New Item Page]**

2. Enter item name: `task-manager-ci-cd`
3. Select: **"Pipeline"**  
4. Click **"OK"**

**[SCREENSHOT PLACEHOLDER: Pipeline Configuration Page - General Tab]**

#### Configure Job Description

In the **"General"** section:
- **Description:** `CI/CD Pipeline for Task Manager API - Beginner Lab`
- **Discard old builds:** ✓ Check this
  - **Days to keep builds:** 7
  - **Max # of builds to keep:** 10

**[SCREENSHOT PLACEHOLDER: Pipeline Configuration - Build Triggers]**

#### Configure Build Triggers (Optional)

For now, we'll trigger builds manually. Later you can configure:
- ✓ **Poll SCM:** Check this if you want automatic builds
  - **Schedule:** `H/5 * * * *` (checks every 5 minutes)

We'll skip this for now to focus on understanding the pipeline.

---

### Step 3.2: Configure Git Repository (15 minutes)

**[SCREENSHOT PLACEHOLDER: Pipeline Configuration - Pipeline Section]**

Scroll down to **"Pipeline"** section.

#### Option A: Using GitHub Repository (Recommended)

**Definition:** Select `Pipeline script from SCM`

**[SCREENSHOT PLACEHOLDER: SCM Configuration]**

- **SCM:** Select `Git`
- **Repository URL:** `https://github.com/YOUR-ORG/ci-cd-demo.git`
  - Replace with YOUR actual repository URL!
- **Credentials:** None (for public repos)
- **Branch Specifier:** `*/main` (or `*/master` depending on your repo)
- **Script Path:** `Jenkinsfile.beginner`

Click **"Save"**

#### Option B: Using Local Repository (If GitHub not available)

**Definition:** Select `Pipeline script`

We'll paste the script directly:

1. Open `Jenkinsfile.beginner` in a text editor on your computer
2. Copy ALL the content
3. Paste into the **"Script"** text box in Jenkins

**[SCREENSHOT PLACEHOLDER: Pipeline Script Text Box]**

Click **"Save"**

---

### Step 3.3: Understanding the Pipeline Script (15 minutes)

Let's understand what the pipeline does before running it!

#### Open the Jenkinsfile

In your project directory:

**Mac/Linux:**
```bash
cd ~/projects/ci-cd-demo
cat Jenkinsfile.beginner
```

**Windows:**
```cmd
cd C:\projects\ci-cd-demo
type Jenkinsfile.beginner
```

#### Pipeline Structure

```groovy
pipeline {
    agent any  ← Where to run (any available machine)
    
    tools {
        maven 'Maven 3.9.0'  ← Tools needed
        jdk 'JDK 17'
    }
    
    stages {  ← The actual work
        stage('Checkout') { ... }
        stage('Build') { ... }
        stage('Test') { ... }
        stage('Package') { ... }
        stage('Deploy') { ... }
    }
}
```

#### The 6 Stages Explained

**Stage 1: Checkout**
```groovy
stage('1. Checkout Source Code') {
    checkout scm  // Downloads code from Git
}
```
- What: Gets latest code from repository
- Output: Code in Jenkins workspace
- Duration: ~5-10 seconds

**Stage 2: Build**
```groovy
stage('2. Build Application') {
    sh 'mvn clean compile -DskipTests'  // For Mac/Linux
    bat 'mvn clean compile -DskipTests' // For Windows
}
```
- What: Compiles Java code (.java → .class)
- Output: Compiled classes in `target/classes/`
- Duration: ~20-30 seconds (first time: 2-3 minutes to download dependencies)

**Stage 3: Test**
```groovy
stage('3. Run Unit Tests') {
    sh 'mvn test'
    junit '**/target/surefire-reports/*.xml'  // Publish results
}
```
- What: Runs all JUnit tests
- Output: Test reports, code coverage
- Duration: ~10-20 seconds

**Stage 4: Package**
```groovy
stage('4. Package Application') {
    sh 'mvn package -DskipTests'
    archiveArtifacts artifacts: '**/target/*.jar'  // Save JAR
}
```
- What: Creates executable JAR file
- Output: `task-manager-api-1.0.0.jar`
- Duration: ~10-15 seconds

**Stage 5: Deploy**
```groovy
stage('5. Deploy to Local Machine') {
    sh "cp target/*.jar /tmp/task-manager/"
    sh "./deployment/deploy-local-mac.sh"  // Mac
    bat "deployment\\deploy-local-windows.bat"  // Windows
}
```
- What: Copies JAR and runs deployment script
- Output: Running application on localhost:8080
- Duration: ~10-15 seconds

**Stage 6: Verify**
```groovy
stage('6. Verify Deployment') {
    sh 'curl -f http://localhost:8080/actuator/health'
}
```
- What: Checks if application is responding
- Output: Health status
- Duration: ~10 seconds

**Total Pipeline Duration:** ~2-5 minutes (first run: 5-10 minutes)

---

### Step 3.4: Run Your First Build! (20 minutes)

Time to see Jenkins in action!

#### Trigger the Build

**[SCREENSHOT PLACEHOLDER: Job Page with "Build Now" button]**

1. Go to your job: Click `task-manager-ci-cd`
2. Click **"Build Now"** (left sidebar)

**[SCREENSHOT PLACEHOLDER: Build Starting - #1 in Build Queue]**

You'll see:
- Build appears in "Build History" (left sidebar)
- Build number: `#1`
- Blue ocean view showing stages

#### Watch the Pipeline Execute

**[SCREENSHOT PLACEHOLDER: Stage View - Pipeline Stages Running]**

**[SCREENSHOT PLACEHOLDER: Blue Ocean View of Pipeline]**

You'll see 6 stages running in sequence:
1. ⏳ Checkout (yellow = running)
2. ⏸️ Build (gray = waiting)
3. ⏸️ Test
4. ⏸️ Package
5. ⏸️ Deploy
6. ⏸️ Verify

As each completes:
- ✓ Green = Success
- ✗ Red = Failure
- ⏸️ Gray = Not started
- ⏳ Yellow = Running

#### View Console Output

**[SCREENSHOT PLACEHOLDER: Build Page - Console Output Link]**

Click on build **#1** → **"Console Output"**

**[SCREENSHOT PLACEHOLDER: Console Output Page]**

You'll see detailed logs:
```
Started by user admin
Running as SYSTEM
[Pipeline] Start of Pipeline
[Pipeline] node
[Pipeline] {
[Pipeline] stage
[Pipeline] { (1. Checkout Source Code)
==========================================
STAGE 1: Checking out source code from Git
==========================================
...
✓ Source code checked out successfully!
[Pipeline] }
[Pipeline] stage
[Pipeline] { (2. Build Application)
==========================================
STAGE 2: Compiling Java source code
==========================================
...
[INFO] BUILD SUCCESS
✓ Application compiled successfully!
...
```

**This is very important!** The console output shows exactly what Jenkins is doing.

#### Wait for Completion

**First Build:** 5-10 minutes (Maven downloads dependencies)  
**Subsequent Builds:** 2-3 minutes

**☕ While waiting, read the console output to see what's happening!**

#### Check Build Status

**[SCREENSHOT PLACEHOLDER: Build History showing Blue (Success) build #1]**

**✓ Success:** Blue/Green ball next to build #1  
**✗ Failure:** Red ball next to build #1

**[SCREENSHOT PLACEHOLDER: Stage View - All Stages Green]**

All stages should be green!

---

### Step 3.5: View Test Results (10 minutes)

One of the best features of Jenkins: beautiful test reports!

#### Navigate to Test Results

**[SCREENSHOT PLACEHOLDER: Build Page - Test Result Link]**

1. Click on build **#1**
2. Click **"Test Result"** (left sidebar)

**[SCREENSHOT PLACEHOLDER: Test Results Page]**

You'll see:
- **Total tests:** X
- **Passed:** X (green)
- **Failed:** 0 (red)
- **Skipped:** 0 (yellow)

#### View Detailed Test Reports

**[SCREENSHOT PLACEHOLDER: Test Results - Package Level]**

Click through:
- Package: `com.nvq.demo.controller`
- Class: `TaskControllerTest`
- See individual test methods

**[SCREENSHOT PLACEHOLDER: Individual Test Details]**

Each test shows:
- ✓ Test name
- ✓ Duration
- ✓ Status

#### View Code Coverage

**[SCREENSHOT PLACEHOLDER: Build Page - JaCoCo Coverage Report Link]**

1. Back to build **#1**
2. Click **"JaCoCo Coverage Report"**

**[SCREENSHOT PLACEHOLDER: JaCoCo Coverage Report]**

You'll see:
- **Line Coverage:** XX%
- **Branch Coverage:** XX%
- **Class Coverage:** 100%

This shows how much of your code is tested!

---

### Step 3.6: View Build Artifacts (5 minutes)

Jenkins saves the JAR file you can download!

**[SCREENSHOT PLACEHOLDER: Build Page - Build Artifacts Section]**

1. Go to build **#1**
2. Scroll to **"Build Artifacts"** section

**[SCREENSHOT PLACEHOLDER: Build Artifacts showing task-manager-api-1.0.0.jar]**

You'll see:
- `task-manager-api-1.0.0.jar` (X MB)
- Click to download!

This is the same JAR file in your `target/` directory.

---

### Step 3.7: Verify Application is Running (10 minutes)

The pipeline deployed the app. Let's verify!

#### Check Application Health

**Mac/Linux:**
```bash
# Test health endpoint
curl http://localhost:8080/actuator/health

# Expected output:
# {"status":"UP"}
```

**Windows (PowerShell):**
```powershell
Invoke-RestMethod http://localhost:8080/actuator/health
```

**Or Browser:**
Visit: http://localhost:8080/actuator/health

#### Test the API

**Mac/Linux:**
```bash
# Get all tasks
curl http://localhost:8080/api/tasks

# Create a task
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Jenkins",
    "description": "Complete CI/CD lab",
    "status": "TODO",
    "assignee": "Me"
  }'

# Get tasks again (should see your new task)
curl http://localhost:8080/api/tasks
```

**Windows (PowerShell):**
```powershell
# Get all tasks
Invoke-RestMethod http://localhost:8080/api/tasks

# Create a task
$body = @{
    title = "Learn Jenkins"
    description = "Complete CI/CD lab"
    status = "TODO"
    assignee = "Me"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:8080/api/tasks `
  -Method POST `
  -ContentType "application/json" `
  -Body $body

# Get tasks again
Invoke-RestMethod http://localhost:8080/api/tasks
```

**✅ Success Criteria:**
- Health endpoint returns `{"status":"UP"}`
- Can create tasks via API
- Can retrieve tasks via API

**🎉 Congratulations! You've built and deployed with Jenkins!**

---

### Step 3.8: Make a Change and Rebuild (15 minutes)

Now let's see the power of CI/CD: make a change, rebuild automatically!

#### Modify the Code

Open `src/main/java/com/nvq/demo/controller/TaskController.java`

Find line ~15 (the greeting message) and change it.

Or add a new endpoint:

```java
@GetMapping("/welcome")
public String welcome() {
    return "Welcome to Task Manager API - Built with Jenkins CI/CD!";
}
```

#### Save and Commit

**Mac/Linux:**
```bash
cd ~/projects/ci-cd-demo
git add .
git commit -m "Add welcome endpoint"
git push origin main
```

**Windows:**
```cmd
cd C:\projects\ci-cd-demo
git add .
git commit -m "Add welcome endpoint"
git push origin main
```

#### Rebuild in Jenkins

**[SCREENSHOT PLACEHOLDER: Build Now button]**

1. Go back to Jenkins
2. Click **"Build Now"** again

Build **#2** starts!

#### Verify Your Change

After build completes:

```bash
curl http://localhost:8080/api/tasks/welcome

# Expected: "Welcome to Task Manager API - Built with Jenkins CI/CD!"
```

**✓ Your change is live!**

---

### 🎓 Session 3 Exercise: Build Pipeline Challenge (10 minutes)

**Task:** Complete these challenges:

1. **Trigger 3 successful builds**
   - Each build should be green/blue
   - Check test results for each

2. **Find these details from build #3:**
   - Total duration: _____ seconds
   - Number of tests run: _____
   - Code coverage percentage: _____%
   - Size of JAR file: _____ MB

3. **Make the build fail (intentionally!)**
   - Hint: Break a test or add syntax error
   - Take a screenshot of red build
   - Fix it and make it green again

4. **Download the JAR file**
   - From build artifacts
   - Run it manually: `java -jar downloaded-file.jar`
   - Verify it works

**✓ Completed all challenges?** You understand CI pipelines!

---

## Session 4: CD Pipeline & Local Deployment

**Duration:** 30 minutes  
**Goal:** Understand CD (deployment) and test the deployed application

### What is CD (Continuous Deployment)?

**Remember:**
- **CI (Continuous Integration):** Build + Test = Creates JAR file
- **CD (Continuous Deployment):** Deploy + Run = Running application

Our pipeline already does CD! Let's understand how.

---

### Step 4.1: Understanding the Deployment Process (10 minutes)

#### What Happens in Deploy Stage?

**The Pipeline:**
1. ✓ CI stages create JAR file: `target/task-manager-api-1.0.0.jar`
2. ✓ JAR is in Jenkins workspace: `~/.jenkins/workspace/task-manager-ci-cd/target/`
3. ✓ Deploy stage copies JAR to: `/tmp/task-manager/` (Mac) or `C:\task-manager\` (Windows)
4. ✓ Deployment script runs:
   - Stops old application (if running)
   - Starts new application
   - Verifies it's working

#### View Deployment Script

**Mac/Linux:**
```bash
cd ~/projects/ci-cd-demo
cat deployment/deploy-local-mac.sh
```

**Windows:**
```cmd
cd C:\projects\ci-cd-demo
type deployment\deploy-local-windows.bat
```

**What the script does:**
1. Checks if JAR exists
2. Checks if port 8080 is available
3. Stops old process: `pkill -f task-manager-api` (Mac) or `taskkill` (Windows)
4. Starts new process: `java -jar task-manager-api.jar &`
5. Saves PID to file for next deployment
6. Waits for app to start
7. Checks health endpoint
8. Reports success!

---

### Step 4.2: Manual Deployment Test (10 minutes)

Let's run the deployment script manually to understand it.

#### Stop Current Application

**Mac/Linux:**
```bash
# Find the process
lsof -i :8080

# Kill it (replace PID with actual PID from above)
kill <PID>

# Or use the script's method
pkill -f task-manager-api
```

**Windows:**
```cmd
REM Find the process
netstat -ano | findstr :8080

REM Kill it (replace PID with actual PID)
taskkill /PID <PID> /F
```

#### Run Deployment Script

**Mac/Linux:**
```bash
cd ~/projects/ci-cd-demo

# Make script executable (if not already)
chmod +x deployment/deploy-local-mac.sh

# Copy JAR to deployment location
mkdir -p /tmp/task-manager
cp target/task-manager-api-1.0.0.jar /tmp/task-manager/task-manager-api.jar

# Run deployment script
./deployment/deploy-local-mac.sh
```

**Windows:**
```cmd
cd C:\projects\ci-cd-demo

REM Create deployment directory
mkdir C:\task-manager

REM Copy JAR
copy target\task-manager-api-1.0.0.jar C:\task-manager\task-manager-api.jar

REM Run deployment script
deployment\deploy-local-windows.bat
```

**Watch the output:**
```
============================================
Step 1: Checking JAR file
============================================
✓ JAR file found: /tmp/task-manager/task-manager-api.jar

============================================
Step 2: Checking port availability
============================================
✓ Port 8080 is available

============================================
Step 3: Stopping old application
============================================
...

============================================
DEPLOYMENT SUCCESSFUL!
============================================
```

**✅ Success:** Application is running!

---

### Step 4.3: Complete API Testing (10 minutes)

Now let's thoroughly test all API endpoints!

#### Test 1: Health Check

```bash
curl http://localhost:8080/actuator/health
```

Expected:
```json
{
  "status": "UP"
}
```

#### Test 2: Get All Tasks (Empty)

```bash
curl http://localhost:8080/api/tasks
```

Expected:
```json
[]
```

#### Test 3: Create a Task

**Mac/Linux:**
```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Complete CI/CD Lab",
    "description": "Finish all 4 sessions",
    "status": "IN_PROGRESS",
    "assignee": "Student"
  }'
```

**Windows (PowerShell):**
```powershell
$task = @{
    title = "Complete CI/CD Lab"
    description = "Finish all 4 sessions"
    status = "IN_PROGRESS"
    assignee = "Student"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:8080/api/tasks `
  -Method POST `
  -ContentType "application/json" `
  -Body $task
```

Expected:
```json
{
  "id": 1,
  "title": "Complete CI/CD Lab",
  "description": "Finish all 4 sessions",
  "status": "IN_PROGRESS",
  "assignee": "Student"
}
```

#### Test 4: Get All Tasks (With Data)

```bash
curl http://localhost:8080/api/tasks
```

Expected:
```json
[
  {
    "id": 1,
    "title": "Complete CI/CD Lab",
    ...
  }
]
```

#### Test 5: Get Task by ID

```bash
curl http://localhost:8080/api/tasks/1
```

#### Test 6: Get Tasks by Status

```bash
curl "http://localhost:8080/api/tasks?status=IN_PROGRESS"
```

#### Test 7: Update a Task

```bash
curl -X PUT http://localhost:8080/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Complete CI/CD Lab",
    "description": "Finish all 4 sessions",
    "status": "DONE",
    "assignee": "Student"
  }'
```

#### Test 8: Get Statistics

```bash
curl http://localhost:8080/api/tasks/stats
```

Expected:
```json
{
  "total": 1,
  "todo": 0,
  "inProgress": 0,
  "done": 1
}
```

#### Test 9: Delete a Task

```bash
curl -X DELETE http://localhost:8080/api/tasks/1
```

#### Test 10: Verify Deletion

```bash
curl http://localhost:8080/api/tasks
# Should return: []
```

**✅ All tests pass:** Your CI/CD pipeline works perfectly!

---

### 🎓 Final Exercise: Complete CI/CD Flow (10 minutes)

**Task:** Do a complete end-to-end CI/CD cycle

1. **Make a code change**
   - Add a new field to Task model
   - Or add a new API endpoint
   - Or change a message

2. **Commit and push**
   ```bash
   git add .
   git commit -m "Your change description"
   git push origin main
   ```

3. **Trigger Jenkins build**
   - Click "Build Now"
   - Wait for completion

4. **Verify deployment**
   - Check health endpoint
   - Test your new feature
   - Verify it works!

**✓ Success Criteria:**
- Build completes successfully (green)
- All tests pass
- Application deploys automatically
- Your change is live and working
- You can access it via API

---

## 📝 Summary

### What You've Learned

#### CI/CD Concepts
✅ What CI/CD is and why it matters  
✅ Difference between CI and CD  
✅ Benefits of automation  
✅ Pipeline concept (stages)

#### Technical Skills
✅ Install Java, Maven, Git  
✅ Install and configure Jenkins  
✅ Create Jenkins pipeline jobs  
✅ Configure build tools  
✅ Read pipeline scripts (Jenkinsfile)  
✅ View test results and coverage  
✅ Deploy applications locally  
✅ Test REST APIs with curl

#### DevOps Practices
✅ Automated building  
✅ Automated testing  
✅ Automated deployment  
✅ Process management (start/stop apps)  
✅ Health checking  
✅ Log viewing

### The Complete CI/CD Flow

```
Developer → Git Push → Jenkins Detects Change
    ↓
Jenkins Pipeline Starts
    ↓
Stage 1: Checkout (get code from Git)
    ↓
Stage 2: Build (compile Java code)
    ↓
Stage 3: Test (run all tests)
    ↓
Stage 4: Package (create JAR)
    ↓
Stage 5: Deploy (copy JAR, start app)
    ↓
Stage 6: Verify (health check)
    ↓
Application Running! ✅
```

### Time Savings

**Manual Process (Without CI/CD):** ~30 minutes per deployment
- 5 min: Pull code, navigate to project
- 5 min: Run `mvn clean compile`
- 5 min: Run `mvn test`
- 5 min: Run `mvn package`
- 5 min: Copy JAR to deployment location
- 3 min: Stop old application
- 2 min: Start new application
- 5 min: Test to make sure it works

**With CI/CD:** ~3-5 minutes, fully automated!
- 1 min: Git push
- 3-5 min: Pipeline runs automatically
- ✨ Done!

**Plus:** Consistent, repeatable, no human errors!

---

## 🔧 Troubleshooting Guide

### Build Issues

#### Problem: "mvn: command not found"

**Solution:**
```bash
# Verify Maven in PATH
echo $PATH  # Mac/Linux
echo %PATH%  # Windows

# Add Maven to PATH (see Session 1)
```

#### Problem: Tests fail

**Solution:**
1. View console output in Jenkins
2. Click on failed test in Test Results
3. Read error message
4. Fix code
5. Rebuild

#### Problem: "Port 8080 already in use"

**Solution:**

**Mac/Linux:**
```bash
# Find and kill process
lsof -i :8080
kill <PID>
```

**Windows:**
```cmd
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Jenkins Issues

#### Problem: Jenkins won't start

**Solution:**
- Check if port 8080 is available
- Check Java is installed: `java -version`
- View Jenkins logs:
  - Mac: `brew services list jenkins-lts`
  - Windows: Event Viewer → Application logs

#### Problem: "Tool not found: Maven 3.9.0"

**Solution:**
- Go to Manage Jenkins → Tools
- Verify Maven name matches Jenkinsfile exactly
- Click "Save"
- Rebuild

#### Problem: Pipeline hangs at "Deploy" stage

**Solution:**
- Old application might not have stopped
- Manually kill Java process
- Check deployment script has execute permission (Mac/Linux)
- Re-run build

### Deployment Issues

#### Problem: Application doesn't start after deployment

**Solution:**
1. Check logs:
   - Mac: `tail -f /tmp/task-manager/application.log`
   - Windows: `type C:\task-manager\application.log`
2. Common causes:
   - Port already in use
   - JAR file corrupted
   - Java version mismatch
3. Try manual start:
   ```bash
   java -jar /tmp/task-manager/task-manager-api.jar
   ```

#### Problem: Health check fails

**Solution:**
- Application might still be starting (wait 10-15 seconds)
- Check if application process is running:
  - Mac: `ps aux | grep task-manager`
  - Windows: `tasklist | findstr java.exe`
- Check logs for startup errors

---

## 📚 Additional Resources

### Documentation
- **Jenkins Official Docs:** https://www.jenkins.io/doc/
- **Spring Boot Reference:** https://docs.spring.io/spring-boot/docs/current/reference/html/
- **Maven Guide:** https://maven.apache.org/guides/

### Practice Projects
1. **Add more API endpoints** to the Task Manager
2. **Add database** (H2, PostgreSQL) instead of in-memory storage
3. **Add email notifications** when build fails
4. **Deploy to cloud** (AWS, Heroku, DigitalOcean)
5. **Add Docker** containerization
6. **Setup multiple environments** (dev, staging, production)

### Next Steps
- Learn about **Docker** for containerization
- Learn about **Kubernetes** for orchestration
- Learn about **GitLab CI** or **GitHub Actions** as alternatives to Jenkins
- Learn about **Infrastructure as Code** (Terraform, Ansible)
- Learn about **Monitoring** (Prometheus, Grafana)

---

## 🎉 Congratulations!

You've completed the CI/CD Lab Activity! You now know:
- ✅ How to set up a complete CI/CD pipeline
- ✅ How Jenkins automates software delivery
- ✅ How to build, test, and deploy applications automatically
- ✅ How to troubleshoot common issues

**You're now ready to:**
- Apply CI/CD to your own projects
- Explore more advanced DevOps topics
- Contribute to professional software teams

---

**Keep Learning, Keep Building! 🚀**

---

## Appendix: Quick Reference

### Common Commands

#### Mac/Linux
```bash
# Build project
mvn clean package

# Run application
java -jar target/task-manager-api-1.0.0.jar

# Check port
lsof -i :8080

# Kill process
kill <PID>

# View logs
tail -f /tmp/task-manager/application.log

# Test API
curl http://localhost:8080/api/tasks
```

#### Windows
```cmd
REM Build project
mvn clean package

REM Run application
java -jar target\task-manager-api-1.0.0.jar

REM Check port
netstat -ano | findstr :8080

REM Kill process
taskkill /PID <PID> /F

REM View logs
type C:\task-manager\application.log

REM Test API (PowerShell)
Invoke-RestMethod http://localhost:8080/api/tasks
```

### Jenkins Locations

| Item | Mac/Linux | Windows |
|------|-----------|---------|
| Jenkins Home | `~/.jenkins/` | `C:\Users\<user>\.jenkins\` |
| Workspace | `~/.jenkins/workspace/<job>/` | `C:\Users\<user>\.jenkins\workspace\<job>\` |
| Logs | `~/.jenkins/logs/` | `C:\Users\<user>\.jenkins\logs\` |
| Plugins | `~/.jenkins/plugins/` | `C:\Users\<user>\.jenkins\plugins\` |

### Pipeline File Locations

| File | Location |
|------|----------|
| Jenkinsfile (Beginner) | `Jenkinsfile.beginner` |
| Jenkinsfile (Advanced) | `Jenkinsfile` |
| Mac Deploy Script | `deployment/deploy-local-mac.sh` |
| Windows Deploy Script | `deployment/deploy-local-windows.bat` |
| Local Run Guide | `LOCAL_RUN_GUIDE.md` |
| API Examples | `API_EXAMPLES.md` |

---

**End of Lab Activity**

Remember: CI/CD is not just a tool, it's a practice. The more you use it, the more natural it becomes. Start small, automate incrementally, and soon you'll wonder how you ever worked without it! 🎯
