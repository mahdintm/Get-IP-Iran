#!/usr/bin/env bash
set -euo pipefail

COUNTRY_SCOPE="${COUNTRY_SCOPE:-IR US}"
for cc in $COUNTRY_SCOPE; do
  ./get.sh "$cc" all --from-cache
done
cp output/mikrotik/IR.rsc list.rsc

git status --short
