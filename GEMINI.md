# GEMINI.md

This file provides foundational mandates and guidance for Gemini CLI when working with MacBootTmpDeleter. Instructions in this file take absolute precedence over general defaults.

## Project Mandates

1. **Path Integrity:** Always use `~/Library/Application Support/MacBootTmpDeleter/` as the target for logic scripts. Do not revert to hardcoded absolute paths within the source directory for installation.
2. **Log Safety:** Never attempt to delete log files from within the same script that `launchd` is using for `StandardOutPath` or `StandardErrorPath`. Use the dedicated `LogCleaner.applescript` for log maintenance.
3. **Surgical Updates:** When modifying AppleScripts, prefer shell-based operations (`do shell script`) for speed and reliability unless complex Finder-specific logic is required.

## Project Structure

- `TempFileDeleter.applescript` - Main cleanup script (runs on login).
- `LogCleaner.applescript` - Log maintenance script (runs weekly).
- `com.jacquesvdm.tempfiledeleter.plist` - LaunchAgent for temp file deletion.
- `com.jacquesvdm.logcleaner.plist` - LaunchAgent for log cleanup.
- `install.sh` - Installation script (handles unloading, copying to App Support, and loading).
- `uninstall.sh` - Uninstallation script (handles unloading and removal of all artifacts).

## System Architecture

```mermaid
graph TD
    subgraph "Triggers (via launchd)"
        Login([User Login]) --> |Runs at Load| Agent1[com.jacquesvdm.tempfiledeleter.plist]
        Weekly([7-Day Interval]) --> |Scheduled| Agent2[com.jacquesvdm.logcleaner.plist]
    end

    subgraph "Temp File Cleanup Flow"
        Agent1 --> |Executes| AS1[TempFileDeleter.applescript]
        AS1 --> Path1{Check Folder Path}
        Path1 --> |Downloads/_tmp_folder| Shell1[do shell script: rm -rf contents]
        Shell1 --> Notify1[Display macOS Notification]
        
        %% Logging captured by launchd
        AS1 -.-> |Stdout| LogFile[~/Library/Logs/tempfiledeleter.log]
        AS1 -.-> |Stderr/Errors| ErrFile[~/Library/Logs/tempfiledeleter_error.log]
    end

    subgraph "Log Maintenance Flow"
        Agent2 --> |Executes| AS2[LogCleaner.applescript]
        AS2 --> FindLogs[Check if logs exist in ~/Library/Logs/]
        FindLogs --> |Found| DeleteLogs[Delete .log and _error.log]
        DeleteLogs --> LogFinish[Log Cleanup Success]
    end

    style Agent1 fill:#f9f,stroke:#333,stroke-width:2px
    style Agent2 fill:#bbf,stroke:#333,stroke-width:2px
    style LogFile fill:#fff,stroke:#333,stroke-dasharray: 5 5
    style ErrFile fill:#fff,stroke:#333,stroke-dasharray: 5 5
```

## Technical Context

- **Target Directory:** `/Users/jacquesvandermerwe/Downloads/_tmp_folder`
- **Logs:** `~/Library/Logs/tempfiledeleter.log` and `tempfiledeleter_error.log`.
- **Scheduling:** Uses `RunAtLoad` for immediate execution on login and `StartInterval` for weekly cleanup.

## Commands for Gemini

### Installation/Management
```bash
./install.sh    # Install or update the service
./uninstall.sh  # Remove the service and its files
```

### Verification
```bash
# Check service status
launchctl list | grep jacquesvdm

# Check for cleanup success (if folder is empty)
ls -A ~/Downloads/_tmp_folder

# View logs
tail -f ~/Library/Logs/tempfiledeleter.log
tail -f ~/Library/Logs/tempfiledeleter_error.log
```

### Testing
```bash
# Test scripts manually (requires files in target folder)
osascript TempFileDeleter.applescript
osascript LogCleaner.applescript
```
