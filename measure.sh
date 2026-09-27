#!/bin/bash
# Starts the production server, waits 10s so the startup preload
# (experimental.preloadEntriesOnStart, on by default) has finished,
# then times the first and second request to the route handler.
set -e
npx next start -p 3300 > server.log 2>&1 &
PID=$!
trap 'kill $PID' EXIT
until curl -s -o /dev/null localhost:3300/; do sleep 0.2; done
sleep 10
curl -s -o /dev/null -w "first  GET /api/heavy: %{time_total}s\n" localhost:3300/api/heavy
curl -s -o /dev/null -w "second GET /api/heavy: %{time_total}s\n" localhost:3300/api/heavy
