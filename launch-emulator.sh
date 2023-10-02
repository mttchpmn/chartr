#!/usr/bin/env bash

DEVICE_NAME=$(~/Library/Android/sdk/emulator/emulator -list-avds | head -n 1)

echo "Launching emulator for -$DEVICE_NAME-"

~/Library/Android/sdk/emulator/emulator -avd "$DEVICE_NAME"


