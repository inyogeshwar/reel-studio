#!/usr/bin/env bash
# Reel Studio engine installer (macOS / Linux).
# Usage:
#   bash install.sh
#   bash install.sh --update
# Prints a single JSON object as its last line.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENGINE_DIR="$PLUGIN_ROOT/engine"

UPDATE=false
for arg in "$@"; do
  [ "$arg" = "--update" ] && UPDATE=true
done

export REELSTUDIO_HOME="${REELSTUDIO_HOME:-$HOME/ReelStudio}"
HOME_DIR="$REELSTUDIO_HOME"
mkdir -p "$HOME_DIR"
LOG="$HOME_DIR/install.log"
VENV="$HOME_DIR/venv"
VENV_PY="$VENV/bin/python"

log() { echo "[$(date +%H:%M:%S)] $1" | tee -a "$LOG"; }

fail() { # step error hint
  log "FAILED at $1: $2"
  printf '{"ok":false,"step":"%s","error":"%s","hint":"%s"}\n' "$1" "$2" "$3"
  exit 1
}

log "Reel Studio installer starting (Update=$UPDATE)"
log "Home: $HOME_DIR"

# 1. Find Python.
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  fail "python" "Python 3.9 or newer was not found." "Install Python 3 and run setup again."
fi
log "Using Python: $PY"

# 2. Create the virtual environment.
if [ ! -x "$VENV_PY" ]; then
  log "[1/4] Creating the engine environment..."
  "$PY" -m venv "$VENV" || fail "venv" "Could not create the Python environment." "Ensure python3-venv is available and run setup again."
else
  log "[1/4] Engine environment already exists."
fi

# 3. Core engine (ffmpeg via imageio-ffmpeg).
log "[2/4] Updating pip..."
"$VENV_PY" -m pip install --upgrade pip >>"$LOG" 2>&1
log "[3/4] Installing the core engine (ffmpeg)..."
"$VENV_PY" -m pip install -e "$ENGINE_DIR" >>"$LOG" 2>&1 || fail "core" "Could not install the core engine." "Check your internet connection and run setup again."

# 4. Optional models — best effort.
CAPTIONS=false
NOTES=""
log "[4/4] Installing optional features (captions, background removal, faces)..."
for pkg in "faster-whisper" "rembg onnxruntime" "opencv-python-headless" "librosa"; do
  if "$VENV_PY" -m pip install $pkg >>"$LOG" 2>&1; then
    case "$pkg" in faster-whisper*) CAPTIONS=true ;; esac
  else
    NOTES="$NOTES Optional package '$pkg' could not be installed."
  fi
done

# 5. Verify ffmpeg.
FFMPEG="$("$VENV_PY" -c 'import reelstudio.media as m; print(m.find_ffmpeg() or "")' 2>/dev/null || true)"
[ -z "$FFMPEG" ] && NOTES="$NOTES ffmpeg did not resolve; run 'reelstudio doctor'."

log "Done."
printf '{"ok":true,"home":"%s","venv":"%s","ffmpeg":"%s","captions_installed":%s,"notes":"%s","update":%s}\n' \
  "$HOME_DIR" "$VENV" "$FFMPEG" "$CAPTIONS" "$NOTES" "$UPDATE"
