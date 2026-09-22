## x3 — Ephemeral File Explorer
x3 is a lightweight Linux utility designed to streamline analyst workflows by launching a graphical file manager in a context-aware way. It supports direct directory browsing, as well as isolated, temporary workspaces for one or more files.

## Core Functionality

### Directory Explorer Mode

When invoked with no arguments or with a directory path, x3 behaves like a standard file explorer launcher:
```
x3
```
Opens the current working directory in the system’s graphical file manager.
```
x3 ../some/path
```
Resolves and opens the specified directory.

In this mode:
- No temporary directories are created.
- No cleanup logic is triggered.
- The tool simply forks and launches the file manager, then exits when it closes

### Isolated File Workspace Mode

When invoked with one or more file paths, x3 creates a temporary, isolated workspace:
```
x3 sample.bin

x3 file1.dll file2.txt config.json
```

Behavior:
- All file paths are resolved to their absolute canonical locations.
- Duplicate inputs (same resolved file path) are deduplicated.
- A temporary directory is created under /tmp using secure random naming.
- Each file is copied into that directory:
- Files are marked read-only.
- Filename collisions are handled automatically (e.g. file.txt, file_2.txt).
- A graphical file manager is opened directly to that temporary directory.
- When the file manager closes—or if the process is interrupted—the temporary directory is recursively deleted.

This provides a clean, file-centric workspace without modifying or navigating the original source directories.

### Installation
```
gcc -Wall -Wextra -Wpedantic -O2 -o x3 x3.c
sudo mv x3 /usr/local/bin/
```

### Multiple keyword AND search (default)

```
/
/ bin
// bin dll → finds files matching both "bin" and "dll" (in path or filename)
OR search
// bin | dll → finds files matching "bin" OR "dll"
// *.exe | *.dll → all executables OR DLLs
NOT/exclusion search
// *.dll !test → DLL files excluding those with "test" in name/path
// config !backup → config files, excluding backup directories
Path vs filename targeting
// path:bin name:*.dll → DLL files in directories with "bin" in path
// name:config path:etc → files named "config" in "etc" directories
// ext:dll dir:bin → DLL extension in "bin" directories
Multiple patterns
// *.dll *.exe *.bat → files matching any of these patterns (OR logic)
// config.* settings.* → files starting with "config" or "settings"
```
