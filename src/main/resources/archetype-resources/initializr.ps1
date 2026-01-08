

$launchFile = ".vscode\launch.json"

Write-Host "Creating microservice '${microserviceName}' and retrieving bootstrap credentials..."

if ($env:C8Y_BASEURL) {
    Write-Host "Session already set, using C8Y_BASEURL from environment: $env:C8Y_BASEURL"
} else {
    Write-Host "No existing session found, starting new session..."
    set-session
}

$cmdOutput = c8y microservices create --name ${microserviceName} --file ./src/main/configuration/cumulocity.json `
    | c8y microservices getBootstrapUser --outputTemplate "{C8Y_BASEURL: 'NA', C8Y_BOOTSTRAP_TENANT: output.tenant, C8Y_BOOTSTRAP_USER: output.name, C8Y_BOOTSTRAP_PASSWORD: output.password, C8Y_MICROSERVICE_ISOLATION: 'MULTI_TENANT'}"

if (-not $cmdOutput) { throw "No output received from c8y command." }

$json = $cmdOutput | ConvertFrom-Json
if (-not $json) { throw "Unexpected JSON format (missing env object)." }

$baseUrl = $env:C8Y_BASEURL
if (-not $baseUrl) { throw "Environment variable C8Y_BASEURL not set." }
$json.C8Y_BASEURL = $baseUrl

# --- Write KEY=VALUE file (.env/dev.env) ---
$envDir = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envDir)) { New-Item -ItemType Directory -Path $envDir | Out-Null }
$envFilePath = Join-Path $envDir "dev.env"

function Write-PropertiesFile {
    param($obj, $path)
    $obj.PSObject.Properties | ForEach-Object { "{0}={1}" -f $_.Name, $_.Value } | Set-Content $path
}

Write-PropertiesFile $json $envFilePath
Write-Host "Wrote environment variables to $envFilePath"
Write-Host "Start your IDE! Run configurations already prepared for IntelliJ and VSCode."