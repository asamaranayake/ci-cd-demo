@echo off
REM ============================================================================
REM Task Manager API - Local Deployment Script for Windows
REM This script automates the deployment process on your local machine
REM ============================================================================

setlocal enabledelayedexpansion

REM ============================================================================
REM CONFIGURATION
REM ============================================================================
set APP_NAME=task-manager-api
set DEPLOY_DIR=C:\task-manager
set JAR_FILE=%DEPLOY_DIR%\%APP_NAME%.jar
set LOG_FILE=%DEPLOY_DIR%\application.log
set PID_FILE=%DEPLOY_DIR%\application.pid
set PORT=8080

REM ============================================================================
REM STEP 1: CHECK IF JAR FILE EXISTS
REM ============================================================================
echo ============================================
echo Step 1: Checking JAR file
echo ============================================

if not exist "%JAR_FILE%" (
    echo [ERROR] JAR file not found: %JAR_FILE%
    echo [INFO] Jenkins should have copied it. Check the pipeline.
    exit /b 1
)

echo [SUCCESS] JAR file found: %JAR_FILE%
echo.

REM ============================================================================
REM STEP 2: CHECK IF PORT IS AVAILABLE
REM ============================================================================
echo ============================================
echo Step 2: Checking port availability
echo ============================================

REM Check if anything is running on port 8080
netstat -ano | findstr ":%PORT%" | findstr "LISTENING" >nul 2>&1
if !errorlevel! equ 0 (
    echo [INFO] Port %PORT% is currently in use
    
    REM Get the PID of the process using the port
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT%" ^| findstr "LISTENING"') do (
        set OLD_PID=%%a
        goto :found_pid
    )
    :found_pid
    echo [INFO] Process using port %PORT%: PID !OLD_PID!
) else (
    echo [SUCCESS] Port %PORT% is available
)
echo.

REM ============================================================================
REM STEP 3: STOP OLD APPLICATION
REM ============================================================================
echo ============================================
echo Step 3: Stopping old application
echo ============================================

REM Method 1: Try to kill by PID from file
if exist "%PID_FILE%" (
    set /p OLD_PID=<"%PID_FILE%"
    echo [INFO] Found PID file with PID: !OLD_PID!
    
    REM Check if process is running
    tasklist /FI "PID eq !OLD_PID!" 2>nul | find "java.exe" >nul
    if !errorlevel! equ 0 (
        echo [INFO] Stopping application (PID: !OLD_PID!)...
        taskkill /PID !OLD_PID! /F >nul 2>&1
        timeout /t 2 /nobreak >nul
        echo [SUCCESS] Old application stopped
    ) else (
        echo [INFO] PID file exists but process is not running
        del "%PID_FILE%" >nul 2>&1
    )
)

REM Method 2: Kill any Java process running our JAR
echo [INFO] Checking for any remaining %APP_NAME% processes...
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO LIST ^| findstr "PID:"') do (
    set JAVA_PID=%%a
    REM Check if this java process is running our app
    wmic process where "ProcessId=!JAVA_PID!" get CommandLine 2>nul | findstr "%APP_NAME%" >nul
    if !errorlevel! equ 0 (
        echo [INFO] Killing %APP_NAME% process (PID: !JAVA_PID!)...
        taskkill /PID !JAVA_PID! /F >nul 2>&1
    )
)

REM Method 3: Kill by port
netstat -ano | findstr ":%PORT%" | findstr "LISTENING" >nul 2>&1
if !errorlevel! equ 0 (
    echo [INFO] Killing process on port %PORT%...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT%" ^| findstr "LISTENING"') do (
        taskkill /PID %%a /F >nul 2>&1
    )
    timeout /t 2 /nobreak >nul
)

REM Verify port is now free
netstat -ano | findstr ":%PORT%" | findstr "LISTENING" >nul 2>&1
if !errorlevel! equ 0 (
    echo [ERROR] Failed to free port %PORT%!
    echo [INFO] Please manually close the application using port %PORT%
    exit /b 1
) else (
    echo [SUCCESS] Port %PORT% is now free
)
echo.

REM ============================================================================
REM STEP 4: START NEW APPLICATION
REM ============================================================================
echo ============================================
echo Step 4: Starting new application
echo ============================================

echo [INFO] Starting %APP_NAME%...
echo [INFO] JAR: %JAR_FILE%
echo [INFO] Port: %PORT%
echo [INFO] Logs: %LOG_FILE%

REM Start the application in background
start /B "TaskManager" java -jar "%JAR_FILE%" > "%LOG_FILE%" 2>&1

REM Get the PID of the started process (Windows limitation: approximate method)
timeout /t 2 /nobreak >nul

REM Find the newly started java.exe process
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO LIST ^| findstr "PID:"') do (
    set JAVA_PID=%%a
    REM Check if this java process is running our app
    wmic process where "ProcessId=!JAVA_PID!" get CommandLine 2>nul | findstr "%APP_NAME%" >nul
    if !errorlevel! equ 0 (
        set NEW_PID=!JAVA_PID!
        goto :found_new_pid
    )
)
:found_new_pid

if defined NEW_PID (
    echo !NEW_PID! > "%PID_FILE%"
    echo [SUCCESS] Application started with PID: !NEW_PID!
) else (
    echo [WARNING] Could not determine PID, but application may have started
)

echo [INFO] Waiting for application to start...
echo.

REM ============================================================================
REM STEP 5: VERIFY DEPLOYMENT
REM ============================================================================
echo ============================================
echo Step 5: Verifying deployment
echo ============================================

REM Wait for application to start (max 30 seconds)
set COUNTER=0
set MAX_WAIT=30

:wait_loop
if !COUNTER! geq !MAX_WAIT! goto :timeout

REM Check if process is still running (if we have PID)
if defined NEW_PID (
    tasklist /FI "PID eq !NEW_PID!" 2>nul | find "java.exe" >nul
    if !errorlevel! neq 0 (
        echo.
        echo [ERROR] Application process died!
        echo [INFO] Check logs: %LOG_FILE%
        type "%LOG_FILE%"
        exit /b 1
    )
)

REM Try to connect to health endpoint
curl -sf http://localhost:%PORT%/actuator/health >nul 2>&1
if !errorlevel! equ 0 (
    echo.
    echo [SUCCESS] Application is running and healthy!
    goto :verified
)

REM Wait and try again
timeout /t 1 /nobreak >nul
set /a COUNTER+=1
echo|set /p=.
goto :wait_loop

:timeout
echo.
echo [ERROR] Application did not start within !MAX_WAIT! seconds
echo [INFO] Check logs: %LOG_FILE%
type "%LOG_FILE%"
exit /b 1

:verified
echo.

REM ============================================================================
REM DEPLOYMENT SUCCESSFUL
REM ============================================================================
echo ============================================
echo DEPLOYMENT SUCCESSFUL!
echo ============================================
echo.
echo [SUCCESS] Application Details:
echo   * Name: %APP_NAME%
if defined NEW_PID echo   * PID: !NEW_PID!
echo   * Port: %PORT%
echo   * JAR: %JAR_FILE%
echo   * Logs: %LOG_FILE%
echo.
echo [SUCCESS] API Endpoints:
echo   * Health: http://localhost:%PORT%/actuator/health
echo   * Tasks: http://localhost:%PORT%/api/tasks
echo   * Stats: http://localhost:%PORT%/api/tasks/stats
echo.
echo [INFO] Useful Commands:
echo   * View logs: type %LOG_FILE%
if defined NEW_PID echo   * Stop app: taskkill /PID !NEW_PID! /F
echo   * Check port: netstat -ano ^| findstr ":%PORT%"
echo.

REM ============================================================================
REM QUICK HEALTH CHECK
REM ============================================================================
echo [INFO] Quick health check:
curl -s http://localhost:%PORT%/actuator/health
echo.
echo.
echo ============================================
echo READY FOR TESTING!
echo ============================================

endlocal
exit /b 0
