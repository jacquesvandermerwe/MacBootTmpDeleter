on run
    try
        set tmpFolderPath to "/Users/jacquesvandermerwe/Downloads/_tmp_folder"

        -- Use the shell to delete contents directly; faster than Finder
        do shell script "rm -rf " & quoted form of tmpFolderPath & "/*"

        display notification "Cleaned _tmp_folder." with title "MacBootTmpDeleter"
    on error errMsg
        -- Ensure errMsg is a string to avoid error -1700 during logging
        set errStr to errMsg as string
        -- Log error to stderr so it appears in tempfiledeleter_error.log
        do shell script "echo " & quoted form of ("Error: " & errStr) & " >&2"
        display notification "Error: " & errStr with title "MacBootTmpDeleter Failed"
    end try
end run