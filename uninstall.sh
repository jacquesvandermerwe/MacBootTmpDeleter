#!/bin/bash

# MacBootTmpDeleter Uninstallation Script
# This script removes the temp file deleter and log cleaner services

TEMP_PLIST="com.jacquesvdm.tempfiledeleter.plist"
LOG_PLIST="com.jacquesvdm.logcleaner.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

echo "Uninstalling MacBootTmpDeleter..."

# Unload the launch agents if they're currently loaded
if launchctl list | grep -q "com.jacquesvdm.tempfiledeleter"; then
    echo "Unloading temp file deleter service..."
    launchctl unload "$LAUNCH_AGENTS_DIR/$TEMP_PLIST"
fi

if launchctl list | grep -q "com.jacquesvdm.logcleaner"; then
    echo "Unloading log cleaner service..."
    launchctl unload "$LAUNCH_AGENTS_DIR/$LOG_PLIST"
fi

# Remove the plist files
if [ -f "$LAUNCH_AGENTS_DIR/$TEMP_PLIST" ]; then
    echo "Removing temp file deleter configuration..."
    rm "$LAUNCH_AGENTS_DIR/$TEMP_PLIST"
fi

if [ -f "$LAUNCH_AGENTS_DIR/$LOG_PLIST" ]; then
    echo "Removing log cleaner configuration..."
    rm "$LAUNCH_AGENTS_DIR/$LOG_PLIST"
fi

echo "Uninstallation complete!"
echo ""
echo "Note: Log files in ~/Library/Logs/ were not removed."
echo "Remove them manually if desired:"
echo "  rm ~/Library/Logs/tempfiledeleter.log"
echo "  rm ~/Library/Logs/tempfiledeleter_error.log"