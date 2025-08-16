-- MacBootTmpDeleter Log Cleaner
-- Deletes old log files weekly to prevent log accumulation
-- Author: Created for Jacques van der Merwe

on run
	try
		set logFilePath to "/Users/jacquesvandermerwe/Library/Logs/tempfiledeleter.log"
		set errorLogFilePath to "/Users/jacquesvandermerwe/Library/Logs/tempfiledeleter_error.log"
		
		-- Check and delete main log file if it exists
		tell application "System Events"
			if exists file logFilePath then
				try
					delete file logFilePath
					log "Deleted log file: " & logFilePath
				on error errMsg
					log "Error deleting log file " & logFilePath & ": " & errMsg
				end try
			end if
			
			-- Check and delete error log file if it exists
			if exists file errorLogFilePath then
				try
					delete file errorLogFilePath
					log "Deleted error log file: " & errorLogFilePath
				on error errMsg
					log "Error deleting error log file " & errorLogFilePath & ": " & errMsg
				end try
			end if
		end tell
		
		log "Weekly log cleanup completed successfully"
		
	on error errMsg
		log "Error in weekly log cleanup: " & errMsg
		display notification "Error cleaning log files: " & errMsg with title "MacBootTmpDeleter Log Cleaner"
	end try
end run