$ErrorActionPreference = 'Stop'
$pidFile = Join-Path $PSScriptRoot '.run/server.pid'
if (Test-Path -LiteralPath $pidFile) {
    $serverPid = [int](Get-Content -LiteralPath $pidFile)
    $server = Get-CimInstance Win32_Process -Filter "ProcessId=$serverPid"
    if ($server -and $server.CommandLine.Contains((Join-Path $PSScriptRoot '.run'))) {
        Stop-Process -Id $serverPid
        Wait-Process -Id $serverPid -Timeout 15 -ErrorAction SilentlyContinue
        Write-Output 'Stopped the PTTK Tomcat process.'
    }
    Remove-Item -LiteralPath $pidFile
}
