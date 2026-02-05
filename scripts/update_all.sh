#!/usr/bin/env bash
set -euo pipefail

COUNTRY_SCOPE="${COUNTRY_SCOPE:-ALL}"
DEVICE_SCOPE="${DEVICE_SCOPE:-all}"
EXTRA_FLAGS="${EXTRA_FLAGS:---save-cache}"

./get.sh "$COUNTRY_SCOPE" "$DEVICE_SCOPE" $EXTRA_FLAGS

if [[ -f output/mikrotik/IR.rsc ]]; then
  cp output/mikrotik/IR.rsc list.rsc
fi
