# Reel Studio engine installer (Windows).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
#   powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Update
# Prints a single JSON object as its last line.

param(
    [switch]$Update
)

$ErrorActionPreference = "Stop"

$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$PluginRoot = Split-Path -Parent $ScriptDir
$EngineDir  = Join-Path $PluginRoot "engine"

if (-not $env:REELSTUDIO_HOME -or $env:REELSTUDIO_HOME -eq "") {
    $env:REELSTUDIO_HOME = Join-Path $env:USERPROFILE "ReelStudio"
}
$RsHome = $env:REELSTUDIO_HOME
New-Item -ItemType Directory -Force -Path $RsHome | Out-Null
$LogPath = Join-Path $RsHome "install.log"
$Venv    = Join-Path $RsHome "venv"
$VenvPy  = Join-Path $Venv "Scripts\python.exe"

function Log([string]$Message) {
    $line = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -Path $LogPath -Value $line
}

function Fail([string]$Step, [string]$ErrorText, [string]$Hint) {
    $result = @{ ok = $false; step = $step; error = $ErrorText; hint = $Hint }
    Log ("FAILED at {0}: {1}" -f $step, $ErrorText)
    $result | ConvertTo-Json -Compress | Write-Output
    exit 1
}

Log "Reel Studio installer starting (Update=$Update)"
Log "Home: $RsHome"

# 1. Find a Python interpreter.
$Py = $null
foreach ($candidate in @("python", "py")) {
    $cmd = Get-Command $candidate -ErrorAction SilentlyContinue
    if ($cmd) { $Py = $candidate; break }
}
if (-not $Py) {
    Fail "python" "Python 3.9 or newer was not found." "Install Python from https://www.python.org/downloads/ and run setup again."
}
Log "Using Python: $Py"

# 2. Create the virtual environment if needed.
if (-not (Test-Path $VenvPy)) {
    Log "[1/4] Creating the engine environment..."
    try {
        if ($Py -eq "py") { & py -3 -m venv $Venv } else { & python -m venv $Venv }
    } catch {
        Fail "venv" "Could not create the Python environment." "Make sure Python includes pip and venv, then run setup again."
    }
} else {
    Log "[1/4] Engine environment already exists."
}

if (-not (Test-Path $VenvPy)) {
    Fail "venv" "The Python environment was not created." "Try running setup again; if it keeps failing, reinstall Python."
}

# 3. Upgrade pip and install the core engine (ffmpeg via imageio-ffmpeg).
Log "[2/4] Updating pip..."
& $VenvPy -m pip install --upgrade pip 2>&1 | Add-Content -Path $LogPath

Log "[3/4] Installing the core engine (ffmpeg)..."
& $VenvPy -m pip install -e $EngineDir 2>&1 | Add-Content -Path $LogPath
if ($LASTEXITCODE -ne 0) {
    Fail "core" "Could not install the core engine." "Check your internet connection and run setup again."
}

# 4. Optional models — best effort, never fatal.
$captions = $false
$notes = @()
Log "[4/4] Installing optional features (captions, background removal, faces)..."
$optional = Join-Path $EngineDir "requirements-optional.txt"
if (Test-Path $optional) {
    foreach ($pkg in @("faster-whisper", "rembg onnxruntime", "opencv-python-headless", "librosa")) {
        try {
            & $VenvPy -m pip install $pkg.Split(" ") 2>&1 | Add-Content -Path $LogPath
            if ($LASTEXITCODE -eq 0 -and $pkg -like "faster-whisper*") { $captions = $true }
        } catch {
            $notes += "Optional package '$pkg' could not be installed; the matching feature stays off."
        }
    }
}

# 5. Verify ffmpeg resolves.
$ffmpeg = $null
try {
    $ffmpeg = (& $VenvPy -c "import reelstudio.media as m; print(m.find_ffmpeg() or '')").Trim()
} catch { }
if (-not $ffmpeg) {
    $notes += "ffmpeg did not resolve; run 'reelstudio doctor' for details."
}

$result = @{
    ok                = $true
    home              = $RsHome
    venv              = $Venv
    ffmpeg            = $ffmpeg
    captions_installed = $captions
    notes             = $notes
    update            = [bool]$Update
}
Log "Done."
$result | ConvertTo-Json -Compress | Write-Output
