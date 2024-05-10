::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdDeDJHLE8FA5Ph5oTwuGOVe7CKEVpeXy4e6FrkIeX945cYPeyYiIIfYa6UrqO58u2Ro=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSTk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDZdVhGJPVeeA6YX/Ofr09iCtEgPR+dxfZfeug==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal EnableDelayedExpansion

set "URL_VER=https://shikkesora.com/version.txt"
set "URL_SHIKKE=https://github.com/ShikkesoraSIM/anti-mindblock/archive/refs/heads/main.zip"
set "verFile=version.txt"

curl %URL_VER% -o version_remote.txt
cls
set /p local_version=<version.txt
set /p remote_version=<version_remote.txt

:: check if the version match, if not ask to update
if "!local_version!" neq "!remote_version!" (
    PowerShell -Command "Add-Type -AssemblyName PresentationFramework; $Result = [System.Windows.MessageBox]::Show('An update is available. Would you like to update?', 'Confirmation', 'YesNo'); if ($Result -eq 'Yes') {exit 0} else {exit 1}"
    if %errorlevel% equ 0 (
        RMDIR /S /Q %cd%\anti-mindblock-main

        :: Download Shikke's program
        if not exist "%cd%\anti-mindblock-main.zip" (
            echo Downloading the main program from github
            curl -s -LJO %URL_SHIKKE% -o anti-mindblock-main.zip
        )

        if not exist "%cd%\anti-mindblock-main.zip" (
            echo Download failed, trying with powershell
            powershell -Command "& {Invoke-WebRequest -Uri '%URL_SHIKKE% -OutFile 'anti-mindblock-main.zip'}"
        )

        if not exist "%cd%\anti-mindblock-main" (
            echo Extracting the file...
            powershell -command "& { Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory('%cd%\anti-mindblock-main.zip', '%cd%') }"
        )

        if not exist "%cd%\anti-mindblock-main" (
            echo Extracting failed, trying with tar...
            tar -xf %cd%\anti-mindblock-main.zip
        )

        if exist "%cd%\anti-mindblock-main" (
            del anti-mindblock-main.zip
        ) else (
            echo there was a problem extracting the file. Please download the file and extract it manually.
            echo https://github.com/ShikkesoraSIM/anti-mindblock/archive/refs/heads/main.zip
            pause
            exit
        )

        :: create a version file for updates
        curl -s -o "%verFile%" "%URL_VER%"
    )
)

:: cleanup, delete remote version
del version_remote.txt

if not exist anti-mindblock-main if not exist python-3.12.3 if not exist Shikkesora-env if not exist tcl-tk-dll (
    echo Please run 'install.exe' first to set up the environment.
    pause
    exit /b 1
)

powershell -ExecutionPolicy Bypass -Command "& {.\Shikkesora-env\Scripts\activate.ps1;python .\anti-mindblock-main\reverse.py}"
