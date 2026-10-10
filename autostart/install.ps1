# Makes GuidanceBridge start automatically (hidden) every time you log in to Windows, and starts it now.
# Run once:  powershell -ExecutionPolicy Bypass -File autostart\install.ps1
$ErrorActionPreference = 'Stop'
$taskName = 'GuidanceBridge'
$vbs = Join-Path $PSScriptRoot 'run-hidden.vbs'
$project = Split-Path $PSScriptRoot -Parent

if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Node.js was not found. Install it from https://nodejs.org first.' }
$keyFile = Join-Path $env:USERPROFILE '.guidancebridge\.env'
if (-not $env:GROQ_API_KEY -and -not (Test-Path $keyFile) -and -not (Test-Path (Join-Path $project '.env'))) { throw "No key file found. Put GROQ_API_KEY=... in $keyFile (see .env.example)." }

$action   = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument "`"$vbs`"" -WorkingDirectory $project
$trigger  = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description 'Runs the GuidanceBridge site at http://localhost:3000' -Force | Out-Null

Start-ScheduledTask -TaskName $taskName
Write-Host "Installed. GuidanceBridge now starts automatically when you log in."
Write-Host "Open http://localhost:3000  (logs: $project\server.log)"
