# Stops GuidanceBridge and removes the automatic start.
# Run:  powershell -ExecutionPolicy Bypass -File autostart\uninstall.ps1
$taskName = 'GuidanceBridge'
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
  Stop-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
  Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}
# Stop the running server using the PID it recorded, and only if that PID is still a node process.
$pidFile = Join-Path (Split-Path $PSScriptRoot -Parent) 'server.pid'
if (Test-Path $pidFile) {
  $p = Get-Process -Id ([int](Get-Content $pidFile)) -ErrorAction SilentlyContinue
  if ($p -and $p.ProcessName -eq 'node') { Stop-Process -Id $p.Id -Force }
  Remove-Item $pidFile -ErrorAction SilentlyContinue
}
Write-Host 'GuidanceBridge auto-start removed and server stopped.'
