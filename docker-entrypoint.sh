#!/usr/bin/env sh

set -ex

# Graceful shutdown
trap 'pkill -TERM -P1; litecoin-cli -chain=$CHAIN stop; exit 0' SIGTERM

# Run application
if [ -n '$PROXY' ]; then
  litecoind -chain=${CHAIN} -rpcauth=${RPC_AUTH} -proxy=${PROXY}
else
  litecoind -chain=${CHAIN} -rpcauth=${RPC_AUTH}
fi