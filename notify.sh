#!/bin/bash

set -euo pipefail

TYPE=$1  # shellcheck disable=SC2034
NAME=$2  # shellcheck disable=SC2034
ENDSTATE=$3

if [ -z "$ENDSTATE" ]; then
  echo "error: call with arguments TYPE NAME ENDSTATE" >&2
  exit 1
fi

if [ -z "$HCLOUD_TOKEN" ]; then
  echo "error: HCLOUD_TOKEN not set" >&2
  exit 1
fi

if [ -z "$NODE_NAME" ]; then
  echo "error: NODE_NAME not set" >&2
  exit 1
fi

if [ -z "$FLOATING_IP" ]; then
  echo "error: FLOATING_IP not set" >&2
  exit 1
fi

if [ "$ENDSTATE" = "MASTER" ] ; then
  SERVER_ID=$(hcloud server list -o noheader -o columns=name,id | grep "^$NODE_NAME\>" | awk '{print $2}')
  FLOATING_IP_ID=$(hcloud floating-ip list -o noheader -o columns=ip,id | grep "^$FLOATING_IP\>" | awk '{print $2}')
  hcloud floating-ip assign "$FLOATING_IP_ID" "$SERVER_ID"
fi
