#! /bin/bash
set -euo pipefail

info() {
  printf "\r\033[00;35m$1\033[0m\n"
}

success() {
  printf "\r\033[00;32m$1\033[0m\n"
}

fail() {
  printf "\r\033[0;31m$1\033[0m\n"
}

divider() {
  printf "\r\033[0;1m========================================================================\033[0m\n"
}

pause_for_confirmation() {
  read -rsp $'Press any key to continue (ctrl-c to quit):\n' -n1 key
}

# Set up an interrupt handler so we can exit gracefully
interrupt_count=0
interrupt_handler() {
  ((interrupt_count += 1))

  echo ""
  if [[ $interrupt_count -eq 1 ]]; then
    fail "Really quit? Hit ctrl-c again to confirm."
  else
    echo "Goodbye!"
    exit
  fi
}
trap interrupt_handler SIGINT SIGTERM

# This setup script does all the magic.

# Check for required tools
declare -a req_tools=("terraform" "sed" "curl" "jq")
for tool in "${req_tools[@]}"; do
  if ! command -v "$tool" > /dev/null; then
    fail "It looks like '${tool}' is not installed; please install it and run this setup script again."
    exit 1
  fi
done

# Check for required Terraform version
if ! terraform version -json | jq -r '.terraform_version' &> /dev/null; then
  echo
  fail "Terraform 0.13 or later is required for this setup script!"
  echo "You are currently running:"
  terraform version
  exit 1
fi

# Set up some variables we'll need
HOST="${1:-app.terraform.io}"
TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')

# Check that we've already authenticated via Terraform in the static credentials
# file.  Note that if you configure your token via a credentials helper or any
# other method besides the static file, this script will not take that in to
# account - but we do this to avoid embedding a Go binary in this simple script
# and you hopefully do not need this Getting Started project if you're using one
# already!
CREDENTIALS_FILE="$HOME/.terraform.d/credentials.tfrc.json"
if [[ ! -f $CREDENTIALS_FILE ]]; then
  fail "We couldn't find a token in the Terraform credentials file at $CREDENTIALS_FILE."
  fail "Please run 'terraform login', then run this setup script again."
  exit 1
fi


CREDENTIALS_FILE="$HOME/.terraform.d/credentials.tfrc.json"
TOKEN=$(jq -j --arg h "$HOST" '.credentials[$h].token' $CREDENTIALS_FILE)
if [[ ! -f $CREDENTIALS_FILE || $TOKEN == null ]]; then
  fail "We couldn't find a token in the Terraform credentials file at $CREDENTIALS_FILE."
  fail "Please run 'terraform login', then run this setup script again."
  exit 1
fi


echo
printf "\r\033[00;35;1m
--------------------------------------------------------------------------
Getting Started with Terraform Cloud
-------------------------------------------------------------------------\033[0m"
echo
echo
echo "Terraform Cloud offers secure, easy-to-use remote state management and allows
you to run Terraform remotely in a controlled environment. Terraform Cloud runs
can be performed on demand or triggered automatically by various events."
echo
echo "This script will set up everything you need to get started. You'll be
applying some example infrastructure - for free - in less than a minute."
echo
info "First, we'll do some setup and configure Terraform to use Terraform Cloud."
echo
pause_for_confirmation

# Create a Terraform Cloud organization
echo
echo "Creating an organization and workspace..."
sleep 1
setup() {
curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @infrastructure/organization.json \
  https://$HOST/api/v2/organizations
}

response=$(setup)

if [[ $(echo $response | jq -r '.errors') != null ]]; then
  fail "An unknown error occurred: ${response}"
  exit 1
fi

api_error=$(echo $response | jq -r '.error')
if [[ $api_error != null ]]; then
  fail "\n${api_error}"
  exit 1
fi

# TODO: If there's an active trial, we should just retrieve that and configure
# it instead (especially if it has no state yet)
info=$(echo $response | jq -r '.info')
if [[ $info != null ]]; then
  info "\n${info}"
  exit 0
fi

setup2() {
curl   --header "Authorization: Bearer $TOKEN"   --header "Content-Type: application/vnd.api+json"   --request POST   --data @infrastructure/workspace.json   https://app.terraform.io/api/v2/organizations/mohamed_ali_test_org1/workspaces
}

response2=$(setup2)

if [[ $(echo $response2 | jq -r '.errors') != null ]]; then
  fail "An unknown error occurred: ${response}"
  exit 1
fi

api_error=$(echo $response2 | jq -r '.error')
if [[ $api_error != null ]]; then
  fail "\n${api_error}"
  exit 1
fi

# TODO: If there's an active trial, we should just retrieve that and configure
# it instead (especially if it has no state yet)
info=$(echo $response2 | jq -r '.info')
if [[ $info != null ]]; then
  info "\n${info}"
  exit 0
fi
