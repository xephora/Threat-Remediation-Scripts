<#
.SYNOPSIS
    Collects user documents of specified file types from common directories and 
    consolidates them into C:\temp\SIRT for review or evidence preservation.

.DESCRIPTION
    This script gathers files (DOC, DOCX, CSV, XLSX, TXT, PDF, EML by default) 
    from a specified user's Downloads, Documents, and Desktop directories. 

    It automatically creates the required folders (C:\temp and C:\temp\SIRT) 
    if they do not exist.

.NOTES
    - All customizable parameters are grouped at the top for analyst convenience.
    - Modify values as needed based on investigation requirements.

.CUSTOMIZABLE PARAMETERS
    $username:
        - Set this to the Windows username whose files you want to collect.
        - Example: "jdoe"

    $extensions:
        - Add or remove file extensions depending on the case.
        - Supports patterns like "*.pdf", "*.txt", etc.

    $sourcePaths:
        - Modify or expand the list of directories to search.
        - Common additions include "Pictures", "Desktop\Projects", etc.

.OUTPUT
    - Files copied into: C:\temp\SIRT
    - Console output includes copied files and any failures encountered.
#>

# ================================
#       CONFIGURATION SECTION
# ================================
# target user (Modify as needed)
$username = "USERNAME_HERE"

# File extensions to collect (modify as needed)
$extensions = @(
    "*.doc", "*.docx", "*.csv", "*.xlsx", "*.txt", "*.pdf", "*.eml"
)

# Directories to search for this user's files (modify as needed)
$sourcePaths = @(
    "C:\Users\$username\Downloads",
    "C:\Users\$username\Documents",
    "C:\Users\$username\Desktop"
)

# Destination directory for collection (modify as needed)
$dest = "C:\temp\SIRT"

# ================================
#       PREPARATION SECTION
# ================================

# Ensure base temp directory exists
if (!(Test-Path "C:\temp")) {
    New-Item -ItemType Directory -Path "C:\temp" | Out-Null
}
if (!(Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
}

# ================================
#       COLLECTION LOGIC
# ================================
foreach ($src in $sourcePaths) {
    if (Test-Path $src) {
        foreach ($ext in $extensions) {
            $files = Get-ChildItem -Path $src -Filter $ext -ErrorAction SilentlyContinue

            foreach ($file in $files) {
                try {
                    Copy-Item -Path $file.FullName -Destination $dest -Force -ErrorAction Stop
                    "Copied => $($file.FullName)"
                }
                catch {
                    "Failed => $($file.FullName): $($_.Exception.Message)"
                }
            }
        }
    }
}
