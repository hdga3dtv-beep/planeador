@echo off
chcp 65001 >nul
title Planeador - instalación
if not exist "%~dp0instalar.ps1" (
  echo.
  echo   Primero descomprime el .zip: clic derecho en Planeador.zip, «Extraer todo...»,
  echo   y abre Instalar en la carpeta que sale.
  echo.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar.ps1" %*
