# Setup environment & paths
$scrcpyDir = "C:\scrcpy"
$scrcpyExe = Join-Path $scrcpyDir "scrcpy.exe"
$launcherBat = Join-Path $scrcpyDir "launch_darts.cmd"
$iconPath = Join-Path $scrcpyDir "GranPi.ico"
$iconUrl = "https://raw.githubusercontent.com/kegerraider/phone-clone-audio-out/main/GranPi.ico"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "DARTS.lnk"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 1. Check if scrcpy is installed; download and extract if missing
if (-not (Test-Path $scrcpyExe)) {
    Write-Host "scrcpy not found. Fetching latest release..." -ForegroundColor Cyan
    
    if (-not (Test-Path $scrcpyDir)) {
        New-Item -ItemType Directory -Path $scrcpyDir -Force | Out-Null
    }

    # Query GitHub API for the latest win64 zip
    $apiUrl = "https://api.github.com/repos/Genymobile/scrcpy/releases/latest"
    $headers = @{ "User-Agent" = "PowerShell-Scrcpy-Installer" }
    
    try {
        $release = Invoke-RestMethod -Uri $apiUrl -Headers $headers
        $asset = $release.assets | Where-Object { $_.name -match 'win64.*\.zip$' } | Select-Object -First 1

        if (-not $asset) {
            throw "Unable to locate a win64 release asset."
        }

        $zipPath = Join-Path $env:TEMP "scrcpy_latest.zip"
        $tempExtractDir = Join-Path $env:TEMP "scrcpy_extract"

        Write-Host "Downloading $($asset.name)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath

        Write-Host "Extracting archive..." -ForegroundColor Yellow
        if (Test-Path $tempExtractDir) { Remove-Item $tempExtractDir -Recurse -Force }
        Expand-Archive -Path $zipPath -DestinationPath $tempExtractDir -Force

        # Locate extracted inner directory and move contents into C:\scrcpy
        $extractedFolder = Get-ChildItem -Path $tempExtractDir -Directory | Select-Object -First 1
        Copy-Item -Path "$($extractedFolder.FullName)\*" -Destination $scrcpyDir -Recurse -Force

        # Clean up temp files
        Remove-Item $zipPath -Force
        Remove-Item $tempExtractDir -Recurse -Force
        Write-Host "scrcpy installed successfully to $scrcpyDir." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install scrcpy automatically: $_"
        exit 1
    }
} else {
    Write-Host "scrcpy already present at $scrcpyExe." -ForegroundColor Green
}

# 2. Download the custom GranPi.ico if missing
if (-not (Test-Path $iconPath)) {
    try {
        Write-Host "Downloading GranPi icon..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $iconUrl -OutFile $iconPath
        Write-Host "Icon saved to $iconPath." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to download custom icon. Falling back to default executable icon."
    }
}

# 3. Write the .cmd launcher file inside C:\scrcpy
$cmdContent = @"
@echo off
cd /d "$scrcpyDir"
scrcpy.exe --audio-source=playback --stay-awake -f
"@

Set-Content -Path $launcherBat -Value $cmdContent -Encoding ASCII
Write-Host "Launcher script created at $launcherBat." -ForegroundColor Green

# 4. Create desktop shortcut named DARTS
$wscriptShell = New-Object -ComObject WScript.Shell
$shortcut = $wscriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $launcherBat
$shortcut.WorkingDirectory = $scrcpyDir
$shortcut.Description = "Launch DARTS Phone Mirror"

# Use downloaded GranPi icon if present, otherwise fallback to scrcpy's native icon
if (Test-Path $iconPath) {
    $shortcut.IconLocation = "$iconPath,0"
} elseif (Test-Path $scrcpyExe) {
    $shortcut.IconLocation = "$scrcpyExe,0"
}

$shortcut.Save()
Write-Host "Shortcut created on Desktop: $shortcutPath" -ForegroundColor Green

# 5. Launch scrcpy immediately
Write-Host "Launching scrcpy..." -ForegroundColor Cyan
Start-Process -FilePath $launcherBat
