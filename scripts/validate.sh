#!/bin/sh
# Validates every preset and renovate.json, then checks that the validator
# still rejects each config in tests/invalid. A preset is any .json file at the
# repo root except package.json, so a new preset is validated without editing
# this script.
set -eu
cd "$(dirname "$0")/.."

validate() {
  # --no-global: validate as a repo config or preset, not as self-hosted
  # global config. --strict: also fail when a config needs migrating.
  renovate-config-validator --no-global --strict "$@"
}

presets=$(find . -maxdepth 1 -name '*.json' ! -name package.json | sort)
if [ -z "$presets" ]; then
  echo "No presets found" >&2
  exit 1
fi

# shellcheck disable=SC2086 # one argument per file; names have no spaces
validate $presets

status=0
for config in tests/invalid/*.json; do
  if validate "$config" >/dev/null 2>&1; then
    echo "FAIL: $config passed validation, but it's meant to be invalid" >&2
    status=1
  else
    echo "ok: $config is rejected"
  fi
done
exit "$status"
