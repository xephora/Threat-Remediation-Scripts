#!/bin/bash

USERNAME="USERNAME_HERE"
USER_PROFILE="/Users/$USERNAME" 
SLEUTH_PATH="$USER_PROFILE/Library/Application Support/sleuth"
INSTALLATION_INSTRUCTIONS_DIR="$USER_PROFILE/Library/Application Support/installation_instructions"
LAUNCHAGENTS_PATH="$USER_PROFILE/Library/LaunchAgents"
INSTALLATION_INSTRUCTIONS="$LAUNCHAGENTS_PATH/com.installation_instructions.plist"
SLEUTH_PLIST="$LAUNCHAGENTS_PATH/com.sleuth.plist"

remove_file() {
    if [ -f "$1" ]; then
        echo "Removing file: $1"
        rm -f "$1"
    elif [ -d "$1" ]; then
        echo "Removing directory: $1"
        rm -rf "$1"
    else
        echo "File or directory not found: $1"
    fi
}

kill_process() {
    pid=$(pgrep -f "$1")
    if [ -n "$pid" ]; then
        echo "Killing process: $pid"
        kill -9 "$pid"
    else
        echo "Process not found: $1"
    fi
}

kill_process "sleuth"
remove_file "$SLEUTH_PATH"
remove_file "$INSTALLATION_INSTRUCTIONS_DIR"

if [ -f "$INSTALLATION_INSTRUCTIONS" ]; then
    echo "Unloading and removing com.installation_instructions.plist..."
    launchctl bootout user/$UID "$INSTALLATION_INSTRUCTIONS" 2>/dev/null
    remove_file "$INSTALLATION_INSTRUCTIONS"
fi

if [ -f "$SLEUTH_PLIST" ]; then
    echo "Unloading and removing com.sleuth.plist..."
    launchctl bootout user/$UID "$SLEUTH_PLIST" 2>/dev/null
    remove_file "$SLEUTH_PLIST"
fi

kill_process "com.installation_instructions"
kill_process "com.sleuth"
