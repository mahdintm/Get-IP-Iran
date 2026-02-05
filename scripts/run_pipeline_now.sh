#!/usr/bin/env bash
set -euo pipefail

# Fast local run using sample cache (works even when RIPE is blocked)
COUNTRY_SCOPE="${COUNTRY_SCOPE:-IR US}"
for cc in $COUNTRY_SCOPE; do
  ./get.sh "$cc" all --from-cache
done
cp output/mikrotik/IR.rsc list.rsc

echo "Pipeline-now completed with cache for: $COUNTRY_SCOPE"
git status --short
