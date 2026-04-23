@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0opsone.ps1" %*

