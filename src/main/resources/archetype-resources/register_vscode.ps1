$launchFile = ".vscode\launch.json"

Write-Host "Creating microservice '${microserviceName}' and retrieving bootstrap credentials..."

set-session

$cmdOutput = c8y microservices create --name ${microserviceName} --file ./src/main/configuration/cumulocity.json `
    | c8y microservices getBootstrapUser --outputTemplate "{env: {C8Y_BASEURL: 'NA', C8Y_BOOTSTRAP_TENANT: output.tenant, C8Y_BOOTSTRAP_USER: output.name, C8Y_BOOTSTRAP_PASSWORD: output.password, C8Y_MICROSERVICE_ISOLATION: 'MULTI_TENANT'}}"

if (-not $cmdOutput) { throw "No output received from c8y command." }

$json = $cmdOutput | ConvertFrom-Json
if (-not $json.env) { throw "Unexpected JSON format (missing env object)." }

$baseUrl = $env:C8Y_BASEURL
if (-not $baseUrl) { throw "Environment variable C8Y_BASEURL not set." }

$json.env.C8Y_BASEURL = $env:C8Y_BASEURL

# Update launch.json env
$launchPath = Join-Path $PSScriptRoot $launchFile
if (-not (Test-Path $launchPath)) { throw "Launch file not found: $launchPath" }

$launchContent = Get-Content $launchPath -Raw
$launchJson = $launchContent | ConvertFrom-Json

if (-not $launchJson.configurations -or $launchJson.configurations.Count -eq 0) {
    throw "No configurations found in launch.json."
}

$launchJson.configurations[0].env = $json.env

# Persist launch.json
$launchJson | ConvertTo-Json -Depth 10 | Set-Content $launchPath

# Output final JSON
$json | ConvertTo-Json -Depth 5
Write-Host "Updated $launchFile with new environment variables."