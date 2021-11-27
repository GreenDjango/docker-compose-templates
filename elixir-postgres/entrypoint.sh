#!/bin/bash -e

# WIP: need database creation
eval "/app/bin/timemanager eval \"TimeManagerAPI.Release.migrate\""
# start the elixir application
exec "/app/bin/timemanager" "start"
