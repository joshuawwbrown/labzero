@echo off
setlocal enabledelayedexpansion

set CONTAINER_NAME=mongo-dev
set VOLUME_NAME=mongo-dev-data
set MONGO_IMAGE=mongo:latest
set MONGO_PORT=27017:27017

REM Ensure Docker Desktop is running
echo Starting Docker Desktop if not running...
tasklist /FI "IMAGENAME eq Docker Desktop.exe" 2>NUL | find /I /N "Docker Desktop.exe">NUL
if "%ERRORLEVEL%"=="1" (
    echo ^> Starting Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
)

REM Wait for Docker to be ready
echo ^> Waiting for Docker to be ready...
:docker_wait
docker info >nul 2>&1
if errorlevel 1 (
    echo ^> Docker is starting up...
    timeout /t 2 >nul
    goto docker_wait
)

echo * Docker is running

REM Check if the volume exists
docker volume ls --format "{{.Name}}" | findstr /x "%VOLUME_NAME%" >nul
if errorlevel 1 (
    echo ^> Volume does not exist, creating a new one...
    docker volume create %VOLUME_NAME%
)

echo * Volume %VOLUME_NAME% is ready.

REM Check if the container exists
docker ps -a --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul
if errorlevel 1 (
    REM Container does not exist, run a new one
    echo Container does not exist, running a new one...
    docker run -d -p %MONGO_PORT% --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data/db %MONGO_IMAGE%
) else (
    REM Container exists, check if it's running
    for /f "tokens=*" %%i in ('docker inspect --format="{{.State.Running}}" %CONTAINER_NAME% 2^>nul') do set is_running=%%i

    if "!is_running!"=="false" (
        echo Container exists but is not running, starting it...
        docker start %CONTAINER_NAME%
    ) else (
        echo Container is already running.
    )
)
