#!/bin/bash
set -e

dsh web --no-open --host 127.0.0.1 --port 3080 \
  --trusted-host 127.0.0.1:3080 --trusted-host localhost:3080 &
PID=$!

trap 'kill $PID 2>/dev/null' TERM INT

for _ in $(seq 1 240); do
  if (echo > /dev/tcp/127.0.0.1/3080) 2>/dev/null; then
    break
  fi
  sleep 0.25
done

dsh plugin --profile web add dshmarket || true

wait $PID
