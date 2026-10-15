@echo off
setlocal
set "PLUGIN_ROOT=%~dp0.."
if not defined REELSTUDIO_HOME set "REELSTUDIO_HOME=%USERPROFILE%\ReelStudio"
set "PY=%REELSTUDIO_HOME%\venv\Scripts\python.exe"
if not exist "%PY%" set "PY=python"
set "PYTHONPATH=%PLUGIN_ROOT%\engine;%PYTHONPATH%"
"%PY%" -m reelstudio.cli %*
