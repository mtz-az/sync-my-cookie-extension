# PowerShell script to package Chrome extension as CRX
$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $ChromePath)) {
    $ChromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
}

if (-not (Test-Path $ChromePath)) {
    Write-Host "Chrome not found at standard locations" -ForegroundColor Red
    Write-Host "Please specify Chrome path or install Google Chrome" -ForegroundColor Yellow
    exit 1
}

$ExtensionPath = Resolve-Path ".\build"
Write-Host "Extension Path: $ExtensionPath" -ForegroundColor Green
Write-Host "Packaging extension..." -ForegroundColor Cyan

# Run Chrome to package the extension
$chromeArgs = "--pack-extension=`"$ExtensionPath`""
Start-Process -FilePath $ChromePath -ArgumentList $chromeArgs -Wait

# Check if CRX was created
$generatedCrx = "$ExtensionPath.crx"
$generatedKey = "$ExtensionPath.pem"

if (Test-Path $generatedCrx) {
    $outputCrx = ".\sync-my-cookie.crx"
    $outputKey = ".\sync-my-cookie.pem"
    
    Move-Item $generatedCrx $outputCrx -Force
    Write-Host "✓ Extension packaged successfully: $outputCrx" -ForegroundColor Green
    
    if (Test-Path $generatedKey) {
        Move-Item $generatedKey $outputKey -Force
        Write-Host "✓ Private key saved: $outputKey" -ForegroundColor Green
        Write-Host "⚠️  Keep this key file secure and private!" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ CRX file was not created" -ForegroundColor Red
    Write-Host "This might be due to Chrome security policies" -ForegroundColor Yellow
}