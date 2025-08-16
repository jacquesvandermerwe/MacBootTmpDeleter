-- MacBootTmpDeleter
-- Deletes all files in the temporary downloads folder on system boot
-- Author: Created for Jacques van der Merwe

on run
	try
		set tmpFolderPath to "/Users/jacquesvandermerwe/Downloads/_tmp_folder"
		
		-- Check if the folder exists
		tell application "System Events"
			if exists folder tmpFolderPath then
				-- Get all files in the folder
				set fileList to every file of folder tmpFolderPath
				
				-- Delete each file
				repeat with aFile in fileList
					try
						set fileName to name of aFile
						delete aFile
						log "Deleted: " & fileName
					on error errMsg
						try
							set fileName to name of aFile
						on error
							set fileName to "unknown file"
						end try
						log "Error deleting " & fileName & ": " & errMsg
					end try
				end repeat
				
				-- Also delete any folders in the tmp directory
				set folderList to every folder of folder tmpFolderPath
				repeat with aFolder in folderList
					try
						set folderName to name of aFolder
						delete aFolder
						log "Deleted folder: " & folderName
					on error errMsg
						try
							set folderName to name of aFolder
						on error
							set folderName to "unknown folder"
						end try
						log "Error deleting folder " & folderName & ": " & errMsg
					end try
				end repeat
				
				log "Temp folder cleanup completed successfully"
			else
				log "Temp folder does not exist: " & tmpFolderPath
			end if
		end tell
		
	on error errMsg
		log "Error in temp file cleanup: " & errMsg
		display notification "Error cleaning temp files: " & errMsg with title "MacBootTmpDeleter"
	end try
end run