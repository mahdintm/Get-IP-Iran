#!/usr/bin/env bash
set -euo pipefail

AUTHOR="Mahdi"
PROJECT="GlobalIP-Device-Lists"
BASE_URL="https://stat.ripe.net/data/country-resource-list/data.json"
ROOT_OUT="output"
CACHE_DIR="data/cache"
USE_CACHE=0
SAVE_CACHE=0
ALLOW_CACHE_FALLBACK=1
TIMEOUT=25
DEVICE_ARG=""
COUNTRY_ARG=""
ALL_COUNTRIES="AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW"

usage() {
  cat <<USAGE
$PROJECT by $AUTHOR

Usage:
  ./get.sh [COUNTRY_CODE|ALL] [DEVICE|all] [--from-cache] [--save-cache] [--no-cache-fallback]

Devices:
  mikrotik | linux | cisco | fortigate | json | all
USAGE
}

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing command: $1" >&2; exit 1; }; }
upper() { tr '[:lower:]' '[:upper:]' <<<"$1"; }
has_country() { grep -qw "$1" <<<"$ALL_COUNTRIES"; }

json_path() { echo "$ROOT_OUT/json/$1.json"; }
mt_path() { echo "$ROOT_OUT/mikrotik/$1.rsc"; }
linux_path() { echo "$ROOT_OUT/linux/$1.txt"; }
cisco_path() { echo "$ROOT_OUT/cisco/$1.cfg"; }
forti_path() { echo "$ROOT_OUT/fortigate/$1.conf"; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      --from-cache) USE_CACHE=1 ;;
      --save-cache) SAVE_CACHE=1 ;;
      --no-cache-fallback) ALLOW_CACHE_FALLBACK=0 ;;
      --timeout) TIMEOUT="$2"; shift ;;
      *)
        if [[ -z "$COUNTRY_ARG" ]]; then
          COUNTRY_ARG="$1"
        elif [[ -z "$DEVICE_ARG" ]]; then
          DEVICE_ARG="$1"
        else
          echo "Unknown extra argument: $1" >&2
          exit 1
        fi ;;
    esac
    shift
  done
  COUNTRY_ARG="$(upper "${COUNTRY_ARG:-IR}")"
  DEVICE_ARG="${DEVICE_ARG:-mikrotik}"
}

fetch_live() {
  local cc="$1"
  curl -fsSL --connect-timeout "$TIMEOUT" --max-time "$TIMEOUT" "${BASE_URL}?resource=${cc}&v4_format=prefix" | jq -c '.data.resources'
}

fetch_resources() {
  local cc="$1" cache_file="$CACHE_DIR/$cc.json" data=""

  if [[ "$USE_CACHE" -eq 1 ]]; then
    [[ -f "$cache_file" ]] || { echo "Cache missing for $cc" >&2; return 1; }
    data="$(cat "$cache_file")"
  else
    if data="$(fetch_live "$cc" 2>/dev/null)"; then
      if [[ "$SAVE_CACHE" -eq 1 ]]; then
        mkdir -p "$CACHE_DIR"
        echo "$data" > "$cache_file"
      fi
    elif [[ "$ALLOW_CACHE_FALLBACK" -eq 1 && -f "$cache_file" ]]; then
      data="$(cat "$cache_file")"
      echo "WARN: live fetch failed for $cc, used cache" >&2
    else
      return 1
    fi
  fi

  jq -e . >/dev/null <<<"$data" || return 1
  echo "$data"
}

write_json() { local cc="$1" r="$2" out; out="$(json_path "$cc")"; jq -n --arg project "$PROJECT" --arg author "$AUTHOR" --arg country "$cc" --arg updated "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" --argjson resources "$r" '{project:$project,author:$author,country:$country,updated_at:$updated,resources:$resources}' > "$out"; }
write_mikrotik() { local cc="$1" r="$2" out; out="$(mt_path "$cc")"; { echo "# $PROJECT by $AUTHOR"; echo "# Country: $cc"; echo "/ip firewall address-list remove [/ip firewall address-list find list=$cc]"; echo "/ip firewall address-list"; jq -r '.ipv4[]?' <<<"$r" | while read -r p; do echo ":do { add address=$p list=$cc} on-error={}"; done; echo "/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=$cc]"; echo "/ipv6 firewall address-list"; jq -r '.ipv6[]?' <<<"$r" | while read -r p; do echo ":do { add address=$p list=$cc} on-error={}"; done; } > "$out"; }
write_linux() { local cc="$1" r="$2" out; out="$(linux_path "$cc")"; { echo "# $PROJECT by $AUTHOR"; echo "# Country: $cc"; jq -r '.ipv4[]?, .ipv6[]?' <<<"$r"; } > "$out"; }
write_cisco() { local cc="$1" r="$2" out; out="$(cisco_path "$cc")"; { echo "! $PROJECT by $AUTHOR"; echo "ip access-list extended COUNTRY_${cc}_V4"; jq -r '.ipv4[]?' <<<"$r" | while read -r p; do echo " permit ip any $p"; done; echo "ipv6 access-list COUNTRY_${cc}_V6"; jq -r '.ipv6[]?' <<<"$r" | while read -r p; do echo " permit ipv6 any $p"; done; } > "$out"; }
write_fortigate() { local cc="$1" r="$2" out; out="$(forti_path "$cc")"; { echo "# $PROJECT by $AUTHOR"; echo "config firewall address"; jq -r '.ipv4[]?' <<<"$r" | while read -r p; do n="${cc}_${p//\//_}"; echo "  edit \"$n\""; echo "    set subnet $p"; echo "  next"; done; echo "end"; } > "$out"; }

write_one_country() {
  local cc="$1" device="$2" resources
  resources="$(fetch_resources "$cc")" || return 1
  case "$device" in
    json) write_json "$cc" "$resources" ;;
    mikrotik) write_mikrotik "$cc" "$resources" ;;
    linux) write_linux "$cc" "$resources" ;;
    cisco) write_cisco "$cc" "$resources" ;;
    fortigate) write_fortigate "$cc" "$resources" ;;
    all) write_json "$cc" "$resources" && write_mikrotik "$cc" "$resources" && write_linux "$cc" "$resources" && write_cisco "$cc" "$resources" && write_fortigate "$cc" "$resources" ;;
    *) echo "Unsupported device: $device" >&2; return 1 ;;
  esac
}

main() {
  need_cmd curl
  need_cmd jq
  parse_args "$@"

  case "$DEVICE_ARG" in mikrotik|linux|cisco|fortigate|json|all) ;; *) echo "Unsupported device: $DEVICE_ARG" >&2; exit 1;; esac
  if [[ "$COUNTRY_ARG" != "ALL" ]] && ! has_country "$COUNTRY_ARG"; then
    echo "Invalid country code: $COUNTRY_ARG" >&2
    exit 1
  fi

  mkdir -p "$ROOT_OUT/json" "$ROOT_OUT/mikrotik" "$ROOT_OUT/linux" "$ROOT_OUT/cisco" "$ROOT_OUT/fortigate"

  local list ok=0 fail=0 rc
  if [[ "$COUNTRY_ARG" == "ALL" ]]; then list="$ALL_COUNTRIES"; else list="$COUNTRY_ARG"; fi

  for cc in $list; do
    set +e
    write_one_country "$cc" "$DEVICE_ARG"
    rc=$?
    set -e
    if [[ "$rc" -eq 0 ]]; then
      echo "OK: $cc ($DEVICE_ARG)"
      ok=$((ok+1))
    else
      echo "FAIL: $cc ($DEVICE_ARG)" >&2
      fail=$((fail+1))
    fi
  done

  echo "Done. success=$ok failed=$fail"
  [[ "$fail" -eq 0 ]]
}

main "$@"
