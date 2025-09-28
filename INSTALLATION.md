# SyncMyCookie Installation Guide

## ⚠️ CRX Installation Issue

If you're getting the error **"Package is invalid: 'CRX_REQUIRED_PROOF_MISSING'"**, this is because:

- Modern Chrome requires CRX files to be cryptographically signed
- Unsigned CRX files (like ours) are blocked for security reasons
- This affects all sideloaded extensions not from the Chrome Web Store

## ✅ Working Installation Methods

### Method 1: Developer Mode Installation (Recommended)

1. **Download the Extension**
   - Option A: Download ZIP: [sync-my-cookie-extension.zip](https://github.com/mtz-az/sync-my-cookie-extension/raw/patch-1/sync-my-cookie-extension.zip)
   - Option B: Clone the repository

2. **Extract Files** (if using ZIP)
   - Extract `sync-my-cookie-extension.zip`
   - You should see files like `manifest.json`, `background.js`, etc.

3. **Open Chrome Extensions**
   - Type `chrome://extensions/` in your address bar
   - Press Enter

4. **Enable Developer Mode**
   - Toggle the "Developer mode" switch in the top-right corner

5. **Load the Extension**
   - Click "Load unpacked"
   - Navigate to the extracted folder (or the `build` folder if you cloned)
   - Select the folder containing `manifest.json`
   - Click "Select Folder"

6. **Verify Installation**
   - The extension should appear in your extensions list
   - Look for "SyncMyCookie" with version 2.0.3
   - Pin it to your toolbar for easy access

### Method 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/mtz-az/sync-my-cookie-extension.git
cd sync-my-cookie-extension

# Install dependencies
npm install

# Build the extension
# On Windows:
./build.bat

# On Linux/macOS:
chmod +x build.sh
./build.sh

# Or manually:
export NODE_OPTIONS="--openssl-legacy-provider"
export NODE_ENV="production"
npx webpack
```

Then follow steps 3-6 from Method 1, but select the `build` folder.

## 🔧 Troubleshooting

### "This extension may have been corrupted"
- Make sure you selected the correct folder containing `manifest.json`
- Try refreshing the extension in `chrome://extensions/`

### Build Errors
- Ensure Node.js is installed (version 14+)
- Use the legacy OpenSSL provider: `NODE_OPTIONS="--openssl-legacy-provider"`
- Delete `node_modules` and run `npm install` again

### Extension Not Working
- Check if Developer mode is enabled
- Look for error messages in the Chrome Extensions page
- Check the browser console for JavaScript errors

## 🔒 Security Notes

- Developer mode extensions show a warning banner - this is normal
- The extension is safe to use but Chrome warns about non-store extensions
- Keep your GitHub token and encryption password secure
- Only download from trusted sources

## 📝 Next Steps

After installation:
1. Click the extension icon
2. Configure your GitHub Personal Access Token
3. Set an encryption password
4. Start syncing cookies across devices!

For detailed usage instructions, see the main README.md file.