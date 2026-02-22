# MacBootTmpDeleter

A macOS utility that automatically cleans temporary files from your downloads folder on system boot/login and manages log files to prevent accumulation.

## Overview

MacBootTmpDeleter uses AppleScript and macOS LaunchAgents to automatically:
- Delete all files and folders in your designated temporary downloads folder on every login
- Clean up log files weekly to prevent disk space issues
- Run reliably even if your machine was offline during scheduled cleanup times

## Features

- **Automatic temp file cleanup**: Runs on every system login
- **Weekly log maintenance**: Prevents log file accumulation
- **Robust scheduling**: Catches up on missed cleanups when system restarts
- **Error handling**: Comprehensive logging and user notifications
- **Easy installation/uninstallation**: Simple scripts for setup and removal

## Installation

1. Clone or download this repository
2. Navigate to the project directory
3. Run the installation script:
   ```bash
   ./install.sh
   ```

The installer will:
- Create a directory at `~/Library/Application Support/MacBootTmpDeleter/` and copy the logic scripts there
- Copy LaunchAgent configuration files to `~/Library/LaunchAgents/`
- Load both the temp file deleter and log cleaner services
- Start automatic operation

## Configuration

### Target Directory
By default, the application cleans:
```
/Users/jacquesvandermerwe/Downloads/_tmp_folder
```

To change this path, edit the `tmpFolderPath` variable in `TempFileDeleter.applescript`.

### Scheduling
- **Temp file cleanup**: Every login/boot
- **Log cleanup**: Every 7 days from installation

## Logs

Activity is logged to:
- Standard output: `~/Library/Logs/tempfiledeleter.log`
- Error output: `~/Library/Logs/tempfiledeleter_error.log`

Log files are automatically cleaned every 7 days to prevent disk space issues.

## Testing

Test the scripts manually before installation:
```bash
# Test temp file deletion
osascript TempFileDeleter.applescript

# Test log cleanup
osascript LogCleaner.applescript
```

## Uninstallation

Run the uninstall script:
```bash
./uninstall.sh
```

This will unload the services and remove both the LaunchAgent configurations and the application scripts from `~/Library/Application Support/MacBootTmpDeleter/`.

## File Structure

```
MacBootTmpDeleter/
├── README.md                              # This file
├── CLAUDE.md                              # Development guidance
├── TempFileDeleter.applescript            # Main cleanup script
├── LogCleaner.applescript                 # Log maintenance script
├── com.jacquesvdm.tempfiledeleter.plist  # Login cleanup LaunchAgent
├── com.jacquesvdm.logcleaner.plist       # Weekly log cleanup LaunchAgent
├── install.sh                            # Installation script
└── uninstall.sh                          # Uninstallation script
```

## Requirements

- macOS (tested on modern versions)
- User permissions to create LaunchAgents
- AppleScript support (built into macOS)

## Troubleshooting

### Service not running
Check if LaunchAgents are loaded:
```bash
launchctl list | grep jacquesvdm
```

### Permission issues
Ensure the script files are readable:
```bash
chmod +r *.applescript
```

### Manual service management
```bash
# Reload services
launchctl unload ~/Library/LaunchAgents/com.jacquesvdm.*.plist
launchctl load ~/Library/LaunchAgents/com.jacquesvdm.*.plist
```

## License

This project is provided as-is for personal use.