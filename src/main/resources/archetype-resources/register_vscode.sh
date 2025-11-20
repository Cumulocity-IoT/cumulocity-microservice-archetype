#!/usr/bin/env bash

# register_vscode.sh
# Cross-platform (Linux/macOS) equivalent of PowerShell script register_vscode.ps1
# Creates Cumulocity microservice, retrieves bootstrap credentials, and updates .vscode/launch.json env.

set -euo pipefail

LAUNCH_FILE=".vscode/launch.json"
CONFIG_FILE="./src/main/configuration/cumulocity.json"

echo "Creating microservice '${microserviceName}' and retrieving bootstrap credentials..." >&2

# --- Dependency checks ---
for dep in c8y jq; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "Error: Required dependency '$dep' not found in PATH." >&2
    exit 1
  fi
done

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file not found: $CONFIG_FILE" >&2
  exit 1
fi

if [[ ! -f "$LAUNCH_FILE" ]]; then
  echo "Error: VS Code launch file not found: $LAUNCH_FILE" >&2
  exit 1
fi

if [[ -z "${C8Y_BASEURL:-}" ]]; then
  echo "Error: Environment variable C8Y_BASEURL not set." >&2
  exit 1
fi

# Output template matching PowerShell script semantics
OUTPUT_TEMPLATE="{env: {C8Y_BASEURL: 'NA', C8Y_BOOTSTRAP_TENANT: output.tenant, C8Y_BOOTSTRAP_USER: output.name, C8Y_BOOTSTRAP_PASSWORD: output.password, C8Y_MICROSERVICE_ISOLATION: 'MULTI_TENANT'}}"

# Create microservice and fetch bootstrap user info
if ! CMD_OUTPUT=$(c8y microservices create --name "${microserviceName}" --file "$CONFIG_FILE" | \
  c8y microservices getBootstrapUser --outputTemplate "$OUTPUT_TEMPLATE"); then
  echo "Error: Failed to retrieve bootstrap user via c8y CLI." >&2
  exit 1
fi

if [[ -z "$CMD_OUTPUT" ]]; then
  echo "Error: No output received from c8y command." >&2
  exit 1
fi

# Validate JSON has env object
if ! echo "$CMD_OUTPUT" | jq -e '.env' >/dev/null 2>&1; then
  echo "Error: Unexpected JSON format (missing env object)." >&2
  echo "$CMD_OUTPUT" >&2
  exit 1
fi

# Inject real C8Y_BASEURL
FINAL_JSON=$(echo "$CMD_OUTPUT" | jq --arg baseUrl "$C8Y_BASEURL" '.env.C8Y_BASEURL = $baseUrl')

# Load launch.json and ensure configurations array exists and has at least one entry
if ! jq -e '.configurations | length > 0' "$LAUNCH_FILE" >/dev/null 2>&1; then
  echo "Error: No configurations found in $LAUNCH_FILE." >&2
  exit 1
fi

# Replace first configuration's env with the new env object
UPDATED_LAUNCH=$(jq --argjson env "$(echo "$FINAL_JSON" | jq '.env')" '.configurations[0].env = $env' "$LAUNCH_FILE")
UPDATED_LAUNCH_ESCAPED=$(printf '%s\n' "$UPDATED_LAUNCH")
echo "$UPDATED_LAUNCH_ESCAPED" > "$LAUNCH_FILE"

# Pretty-print final JSON (same behavior as PowerShell script output)
echo "$FINAL_JSON" | jq '.'

echo "Updated $LAUNCH_FILE with new environment variables." >&2

# --- Usage Notes ---
# Prerequisites: c8y CLI and jq installed.
# Ensure you have exported C8Y_BASEURL before running:
#   export C8Y_BASEURL="https://your-tenant.cumulocity.com"
# Run the script:
#   bash register_vscode.sh
# Optionally override microservice name:
#   MICROSERVICE_NAME=myservice bash register_vscode.sh
