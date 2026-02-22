#!/bin/bash

# MacBootTmpDeleter Installation Script
# This script installs the temp file deleter and log cleaner

TEMP_PLIST="com.jacquesvdm.tempfiledeleter.plist"
LOG_PLIST="com.jacquesvdm.logcleaner.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
APP_SUPPORT_DIR="$HOME/Library/Application Support/MacBootTmpDeleter"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing MacBootTmpDeleter..."

# Create necessary directories
mkdir -p "$LAUNCH_AGENTS_DIR"
mkdir -p "$APP_SUPPORT_DIR"

# Copy AppleScripts to Application Support
cp "$PROJECT_DIR/TempFileDeleter.applescript" "$APP_SUPPORT_DIR/"
cp "$PROJECT_DIR/LogCleaner.applescript" "$APP_SUPPORT_DIR/"

# Copy both plist files to LaunchAgents
cp "$PROJECT_DIR/$TEMP_PLIST" "$LAUNCH_AGENTS_DIR/"
cp "$PROJECT_DIR/$LOG_PLIST" "$LAUNCH_AGENTS_DIR/"

# Unload first if already loaded to avoid "Input/output error 5"
launchctl unload "$LAUNCH_AGENTS_DIR/$TEMP_PLIST" 2>/dev/null
launchctl unload "$LAUNCH_AGENTS_DIR/$LOG_PLIST" 2>/dev/null

# Load both launch agents
launchctl load "$LAUNCH_AGENTS_DIR/$TEMP_PLIST"
launchctl load "$LAUNCH_AGENTS_DIR/$LOG_PLIST"

echo "Installation complete!"
echo "- Temp file deleter will run on every login"
echo "- Log cleaner will run every 7 days starting from installation"
echo "- Logs will be written to ~/Library/Logs/tempfiledeleter.log"
echo ""
echo "To uninstall, run:"
echo "launchctl unload ~/Library/LaunchAgents/$TEMP_PLIST"
echo "launchctl unload ~/Library/LaunchAgents/$LOG_PLIST"
echo "rm ~/Library/LaunchAgents/$TEMP_PLIST"
echo "rm ~/Library/LaunchAgents/$LOG_PLIST"