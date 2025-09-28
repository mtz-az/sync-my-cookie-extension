#!/bin/bash
# Build script for SyncMyCookie Chrome Extension

echo "🔧 Installing dependencies..."
npm install

echo "🏗️  Building extension..."
export NODE_OPTIONS="--openssl-legacy-provider"
export NODE_ENV="production"
npx webpack

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    echo "📂 Extension files are in the 'build' directory"
    echo ""
    echo "🚀 To install:"
    echo "1. Open Chrome and go to chrome://extensions/"
    echo "2. Enable 'Developer mode'"
    echo "3. Click 'Load unpacked' and select the 'build' folder"
else
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "📦 To create CRX package:"
echo "npm install -g crx3"
echo "crx3 build ./build/ --zip-output ./sync-my-cookie.zip"