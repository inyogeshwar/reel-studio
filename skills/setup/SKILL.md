---
name: setup
description: One-time install of the Reel Studio engine on this computer (ffmpeg, a Python virtual environment, and optional AI models for captions, background removal and face detection), or update it. Run this first, before making any reel.
argument-hint: "[update]"
---

# setup

Installs everything the plugin needs into one folder (`REELSTUDIO_HOME`; Windows
`%USERPROFILE%\ReelStudio`, macOS/Linux `~/ReelStudio`). No admin rights, and nothing
else on the computer is changed. The plugin is **free**: there is no licence key, no
account and no online check.

**Shells.** On Windows the user may have PowerShell only, Bash only, or both. Every command
here is written once when it is the same in both and twice (PowerShell / Bash) when it is
not. The **plugin root** is two folders above this skill's base directory. **Running
`reelstudio`:** always the plugin's wrapper by its full path (a PATH change never reaches
this session):

- PowerShell: `& "<plugin root>\bin\reelstudio.cmd" <args>`
- Bash (macOS or Git Bash on Windows): `bash "<plugin root>/bin/reelstudio" <args>`

`reelstudio <args>` below always means this.

## Install (argument empty)

1. Already installed? Run `reelstudio doctor`. If `"ready": true`, say the engine is ready
   and stop (mention `update` if the plugin was just upgraded).
2. Otherwise, tell the user in plain words what will happen: it creates a private Python
   environment in `%USERPROFILE%\ReelStudio` and downloads ffmpeg (about 30 MB) plus, if it
   can, the optional AI models (captions ~150 MB, background removal ~180 MB, face detection
   ~10 MB). First install usually takes 2–10 minutes; it needs internet and about 2 GB free.
3. Run the installer. It is idempotent: running it again finishes anything that failed.
   - Windows, PowerShell: `powershell -NoProfile -ExecutionPolicy Bypass -File "<plugin root>\setup\install.ps1"`
   - Windows, Bash: `bash "<plugin root>/setup/install.ps1"` (Git Bash runs the .ps1 via `powershell`)
   - macOS / Linux: `bash "<plugin root>/setup/install.sh"`
   - Update (add the flag): `... install.ps1 -Update` / `... install.sh --update`
4. Afterwards run `reelstudio doctor` and report plainly: ready or not, and any failing
   check with its `notes` line. Never show raw JSON to the user except as a last resort.

## Update (argument `update`)

Run the installer with the update flag. It reuses the existing virtual environment and only
installs what is missing; user styles in `REELSTUDIO_HOME/styles` are never touched. Then
run `reelstudio doctor` and report as in Install step 4.

## Notes

- The engine works with **ffmpeg only**. The optional packages unlock specific features:
  captions and voice-over need `faster-whisper`; background removal needs `rembg`; face
  detection needs `opencv-python`; more accurate beat-sync needs `librosa` (beat-sync also
  works without it using the built-in detector). If one failed, everything else still works
  — name the missing piece and offer to run setup again.
- Never delete `REELSTUDIO_HOME` unless the user asks to uninstall.
- To uninstall: delete that folder and the plugin folder from the workspace/global plugins
  directory.
