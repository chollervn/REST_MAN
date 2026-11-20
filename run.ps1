param(
    [int]$Port = 8085,
    [string]$JavaHome = 'C:\Program Files\Java\jdk-21',
    [string]$TomcatHome = 'C:\Program Files\Apache Software Foundation\Tomcat 10.1',
    [string]$Maven = 'D:\IntelliJ IDEA 2025.3.1.1\plugins\maven\lib\maven3\bin\mvn.cmd'
)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$runtime = Join-Path $PSScriptRoot '.run'
$config = Join-Path $PSScriptRoot 'local.properties'
if (!(Test-Path -LiteralPath $config) -and !$env:DB_PASSWORD) {
    throw 'Create local.properties with db.password, or set DB_PASSWORD before running.'
}
$pidFile = Join-Path $runtime 'server.pid'
if (Test-Path -LiteralPath $pidFile) {
    $oldProcess = Get-Process -Id ([int](Get-Content -LiteralPath $pidFile)) -ErrorAction SilentlyContinue
    if ($oldProcess) { throw 'PTTK is already running. Run .\stop.ps1 before rebuilding.' }
}
if (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) {
    throw "Port $Port is already in use. Stop that application or choose -Port."
}
& $Maven -B -ntp package
if ($LASTEXITCODE -ne 0) { throw 'Maven build failed.' }
foreach ($folder in @('conf', 'logs', 'temp', 'webapps', 'work')) {
    New-Item -ItemType Directory -Force -Path (Join-Path $runtime $folder) | Out-Null
}
Copy-Item -LiteralPath (Join-Path $TomcatHome 'conf/web.xml') -Destination (Join-Path $runtime 'conf/web.xml')
Copy-Item -LiteralPath (Join-Path $TomcatHome 'conf/logging.properties') -Destination (Join-Path $runtime 'conf/logging.properties')
@"
<Server port="-1">
  <Service name="Catalina">
    <Connector address="127.0.0.1" port="$Port" protocol="HTTP/1.1" URIEncoding="UTF-8" />
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" autoDeploy="false">
        <Context path="/PTTK" docBase="$($PSScriptRoot.Replace('\','/'))/target/PTTK.war" unpackWAR="false" />
      </Host>
    </Engine>
  </Service>
</Server>
"@ | Set-Content -LiteralPath (Join-Path $runtime 'conf/server.xml') -Encoding utf8
$java = Join-Path $JavaHome 'bin/java.exe'
$arguments = @(
    "-Dcatalina.home=`"$TomcatHome`"",
    "-Dcatalina.base=`"$runtime`"",
    "-Djava.io.tmpdir=`"$(Join-Path $runtime 'temp')`"",
    '-Dfile.encoding=UTF-8',
    "-Djava.util.logging.config.file=`"$(Join-Path $runtime 'conf/logging.properties')`"",
    '-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager'
)
if (Test-Path -LiteralPath $config) { $arguments += "-Drestman.config=`"$config`"" }
$arguments += @('-cp', "`"$TomcatHome\bin\bootstrap.jar;$TomcatHome\bin\tomcat-juli.jar`"", 'org.apache.catalina.startup.Bootstrap', 'start')
$server = Start-Process -FilePath $java -ArgumentList $arguments -WindowStyle Hidden -PassThru -WorkingDirectory $PSScriptRoot -RedirectStandardOutput (Join-Path $runtime 'stdout.log') -RedirectStandardError (Join-Path $runtime 'stderr.log')
$server.Id | Set-Content -LiteralPath $pidFile
for ($attempt = 0; $attempt -lt 40; $attempt++) {
    Start-Sleep -Seconds 1
    $server.Refresh()
    if ($server.HasExited) { throw 'Tomcat stopped. See .run/stderr.log.' }
    try {
        $response = Invoke-WebRequest -Uri "http://127.0.0.1:$Port/PTTK/login" -UseBasicParsing -TimeoutSec 5 -NoProxy
        if ($response.StatusCode -eq 200) {
            Write-Output "PTTK is ready at http://localhost:$Port/PTTK/"
            exit 0
        }
    } catch { }
}
throw 'Tomcat did not become ready. See .run/stderr.log.'
