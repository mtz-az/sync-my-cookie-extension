@echo off
REM Build script for SyncMyCookie Chrome Extension (Windows)

echo 🔧 Installing dependencies...
call npm install

echo 🏗️ Building extension...
set NODE_OPTIONS=--openssl-legacy-provider
set NODE_ENV=production
call npx webpack

if %errorlevel% equ 0 (
    echo ✅ Build completed successfully!
    echo 📂 Extension files are in the 'build' directory
    echo.
    echo 🚀 To install:
    echo 1. Open Chrome and go to chrome://extensions/
    echo 2. Enable 'Developer mode'
    echo 3. Click 'Load unpacked' and select the 'build' folder
) else (
    echo ❌ Build failed!
    exit /b 1
)

echo.
echo 📦 To create CRX package:
echo npm install -g crx3
echo crx3 build ./build/ --zip-output ./sync-my-cookie.zip