\#!/bin/bash

# helper.sh — AeonCore utility helper script

# Part of /AeonCore/utils/

# Provides small utility functions to support AeonCore operations

print\_banner() {
echo "==============================="
echo "        AeonCore Utils        "
echo "==============================="
}

check\_dependencies() {
echo "Checking dependencies..."
for cmd in jq curl awk sed grep; do
if ! command -v \$cmd &> /dev/null; then
echo "Missing dependency: \$cmd"
else
echo "\$cmd is installed."
fi
done
}

log\_event() {
local message="\$1"
local logfile="/AeonCore/logs/ioncore.log"
echo "\[\$(date '+%Y-%m-%d %H:%M:%S')] \$message" >> "\$logfile"
}

print\_usage() {
echo "Usage: helper.sh \[option]"
echo "Options:"
echo "  --banner         Print AeonCore banner"
echo "  --check-deps     Verify required dependencies"
echo "  --log \[message]  Log a message to the AeonCore log"
}

case "\$1" in
\--banner)
print\_banner
;;
\--check-deps)
check\_dependencies
;;
\--log)
shift
log\_event "\$1"
;;
\*)
print\_usage
;;
esac
