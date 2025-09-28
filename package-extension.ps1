# PowerShell script to package Chrome extension as CRX
param(
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
    [string]$ExtensionPath = ".\build",
    [string]$OutputPath = ".\sync-my-cookie.crx",
    [string]$KeyPath = ".\sync-my-cookie.pem"
)

# Check if Chrome exists
if (-not (Test-Path $ChromePath)) {
    $ChromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    if (-not (Test-Path $ChromePath)) {
        Write-Host "Chrome not found. Please install Google Chrome or specify the correct path." -ForegroundColor Red
        exit 1
    }
}

# Convert paths to absolute paths
$ExtensionPath = Resolve-Path $ExtensionPath
$OutputDir = Split-Path $OutputPath -Parent
$OutputFile = Split-Path $OutputPath -Leaf
$KeyFile = Split-Path $KeyPath -Leaf

if ($OutputDir) {
    $OutputPath = Join-Path (Resolve-Path $OutputDir) $OutputFile
} else {
    $OutputPath = Join-Path (Get-Location) $OutputFile
}

if (Split-Path $KeyPath -Parent) {
    $KeyPath = Resolve-Path $KeyPath -ErrorAction SilentlyContinue
} else {
    $KeyPath = Join-Path (Get-Location) $KeyFile
}

Write-Host "Extension Path: $ExtensionPath" -ForegroundColor Green
Write-Host "Output Path: $OutputPath" -ForegroundColor Green
Write-Host "Key Path: $KeyPath" -ForegroundColor Green

# Build the command
$chromeArgs = @(
    "--pack-extension=`"$ExtensionPath`""
)

# Add key file if it exists
if (Test-Path $KeyPath) {
    $chromeArgs += "--pack-extension-key=`"$KeyPath`""
    Write-Host "Using existing key file: $KeyPath" -ForegroundColor Yellow
} else {
    Write-Host "No key file found. Chrome will generate a new one." -ForegroundColor Yellow
}

# Run Chrome to package the extension
Write-Host "Packaging extension..." -ForegroundColor Cyan
Write-Host "Command: $ChromePath $($chromeArgs -join ' ')" -ForegroundColor Gray

try {
    $process = Start-Process -FilePath $ChromePath -ArgumentList $chromeArgs -Wait -PassThru -WindowStyle Hidden
    
    if ($process.ExitCode -eq 0) {
        # Chrome creates the CRX in the parent directory of the extension
        $generatedCrx = "$ExtensionPath.crx"
        $generatedKey = "$ExtensionPath.pem"
        
        if (Test-Path $generatedCrx) {
            # Move to desired output location
            if ($OutputPath -ne $generatedCrx) {
                Move-Item $generatedCrx $OutputPath -Force
            }
            Write-Host "✓ Extension packaged successfully: $OutputPath" -ForegroundColor Green
            
            # Also move the key file to the project root if it was generated
            if ((Test-Path $generatedKey) -and (-not (Test-Path $KeyPath))) {
                Move-Item $generatedKey $KeyPath -Force
                Write-Host "✓ Private key saved: $KeyPath" -ForegroundColor Green
                Write-Host "⚠️  Keep this key file secure and private!" -ForegroundColor Yellow
            }
        } else {
            Write-Host "❌ CRX file was not created. Check Chrome output for errors." -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Chrome packaging failed with exit code: $($process.ExitCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error running Chrome: $($_.Exception.Message)" -ForegroundColor Red
}