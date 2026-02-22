# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MacBootTmpDeleter is a macOS utility that automatically deletes temporary files from a designated downloads folder on system boot/login. It uses AppleScript and macOS LaunchAgents to run automatically.

## Project Structure

- `TempFileDeleter.applescript` - Main AppleScript that handles file deletion
- `LogCleaner.applescript` - AppleScript that cleans up log files weekly
- `com.jacquesvdm.tempfiledeleter.plist` - LaunchAgent for temp file deletion on login
- `com.jacquesvdm.logcleaner.plist` - LaunchAgent for weekly log cleanup
- `install.sh` - Installation script to set up both LaunchAgents

## Installation and Usage

1. Run the installation script: `./install.sh`
2. The script will:
   - Copy AppleScripts to `~/Library/Application Support/MacBootTmpDeleter/`
   - Copy both plist files to `~/Library/LaunchAgents/` and load them
3. The temp file deleter will run automatically on every login
4. The log cleaner will run automatically every 7 days (weekly) starting from installation

## Target Directory

The application deletes all files and folders in:
`/Users/jacquesvandermerwe/Downloads/_tmp_folder`

## Logs

- Standard output: `~/Library/Logs/tempfiledeleter.log`
- Error output: `~/Library/Logs/tempfiledeleter_error.log`
- Log files are automatically deleted every 7 days to prevent accumulation (runs even if machine was off during scheduled time)

## Uninstalling

```bash
./uninstall.sh
```

This unloads the services and removes the LaunchAgents and application scripts from `~/Library/Application Support/MacBootTmpDeleter/`.

## Testing

To test the scripts manually:
```bash
# Test temp file deletion
osascript TempFileDeleter.applescript

# Test log cleanup
osascript LogCleaner.applescript
```

## Development Notes

- Uses AppleScript for reliable macOS file operations
- LaunchAgents provide robust scheduling that survives system reboots
- `StartInterval` with `RunAtLoad` ensures missed cleanups are caught up

## Troubleshooting

Check LaunchAgent status:
```bash
launchctl list | grep jacquesvdm
```

View logs:
```bash
tail -f ~/Library/Logs/tempfiledeleter.log
```

Reload services:
```bash
./uninstall.sh && ./install.sh
```