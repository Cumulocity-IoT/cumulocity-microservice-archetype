#!/usr/bin/env bash
# Generates a .env/dev.env with Cumulocity bootstrap credentials
# Note: This file is filtered by the Maven archetype. Only ${microserviceName} is intentional.

set -eo pipefail

MICRO_NAME="${microserviceName}"  # replaced by archetype at generation time
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Requirements
if ! command -v c8y >/dev/null 2>&1; then
  echo "ERROR: c8y CLI not found. Install: https://github.com/reubenmiller/go-c8y-cli" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required to parse CLI output. Install jq." >&2
  exit 1
fi
if [ -z "$C8Y_BASEURL" ]; then
  echo "ERROR: C8Y_BASEURL env var not set (e.g. export C8Y_BASEURL=https://tenant.example.com)." >&2
  exit 1
fi

echo "Creating microservice '$MICRO_NAME' and retrieving bootstrap credentials..."

# Create microservice and fetch bootstrap user as JSON
# Keep outputTemplate JSON simple to avoid shell parsing issues.
set +e
cmd_output="$(
  c8y microservices create --name "$MICRO_NAME" --file ./src/main/configuration/cumulocity.json \
  | c8y microservices getBootstrapUser \
      --outputTemplate '{C8Y_BOOTSTRAP_TENANT: output.tenant, C8Y_BOOTSTRAP_USER: output.name, C8Y_BOOTSTRAP_PASSWORD: output.password, C8Y_MICROSERVICE_ISOLATION: "MULTI_TENANT"}'
)"
rc=$?
set -e

if [ $rc -ne 0 ] || [ -z "$cmd_output" ]; then
  echo "ERROR: Failed to create microservice or fetch bootstrap user." >&2
  exit 1
fi

# Validate JSON and inject base URL
json="$(printf '%s' "$cmd_output" | jq --arg base "$C8Y_BASEURL" '. + {C8Y_BASEURL: $base}')" || {
  echo "ERROR: Unexpected JSON format from c8y output." >&2
  exit 1
}

# Write KEY=VALUE to .env/dev.env (gitignore this file)
env_dir="$SCRIPT_DIR/.env"
mkdir -p "$env_dir"
env_file="$env_dir/dev.env"
printf '%s\n' "$json" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"' > "$env_file"

echo "Wrote environment variables to $env_file"
echo "Tip: reference this with VS Code launch.json using \"envFile\": \".env/dev.env\""