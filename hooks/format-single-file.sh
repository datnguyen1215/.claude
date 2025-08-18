#!/bin/bash

# Claude Code hook script to format a single file after modification
# Reads JSON input from stdin and formats only the modified file

# Debug logging
echo "[$(date)] Hook started" >> /tmp/claude-hook.log

# Read JSON input from stdin
JSON_INPUT=$(cat)
echo "[$(date)] JSON Input: $JSON_INPUT" >> /tmp/claude-hook.log

# Extract file path from the JSON input
# Try both tool_input.file_path and tool_response.filePath
FILE_PATH=$(echo "$JSON_INPUT" | jq -r '.tool_input.file_path // .tool_response.filePath // empty')

# Exit if no file path found
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Exit if file doesn't exist
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# Resolve symlinks to get the real path
REAL_FILE_PATH=$(realpath "$FILE_PATH" 2>/dev/null || echo "$FILE_PATH")
FILE_PATH="$REAL_FILE_PATH"

echo "[$(date)] File path: $FILE_PATH" >> /tmp/claude-hook.log

# Get file extension
EXTENSION="${FILE_PATH##*.}"
FILENAME=$(basename "$FILE_PATH")

echo "[$(date)] Extension: $EXTENSION" >> /tmp/claude-hook.log

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to find and run formatter in project directory
find_project_formatter() {
    local project_dir="$1"
    local formatter_cmd="$2"

    # Check for node_modules in project
    if [ -d "$project_dir/node_modules/.bin" ]; then
        local local_formatter="$project_dir/node_modules/.bin/$formatter_cmd"
        if [ -x "$local_formatter" ]; then
            echo "$local_formatter"
            return 0
        fi
    fi

    # Check parent directories for node_modules
    local current_dir="$project_dir"
    while [ "$current_dir" != "/" ]; do
        if [ -x "$current_dir/node_modules/.bin/$formatter_cmd" ]; then
            echo "$current_dir/node_modules/.bin/$formatter_cmd"
            return 0
        fi
        current_dir=$(dirname "$current_dir")
    done

    return 1
}

# Wait a moment to ensure the file is fully written
sleep 0.1

# Remove trailing spaces from all lines (including empty lines with only spaces)
# This runs before any formatter to ensure clean input
echo "[$(date)] Removing trailing spaces from $FILE_PATH" >> /tmp/claude-hook.log
sed -i 's/[[:space:]]*$//' "$FILE_PATH" 2>/dev/null
echo "[$(date)] Trailing spaces removed" >> /tmp/claude-hook.log

# Get the directory of the file
FILE_DIR=$(dirname "$FILE_PATH")

# Format based on file extension
case "$EXTENSION" in
    js|jsx|ts|tsx|mjs|cjs)
        # Try prettier first
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            "$PRETTIER" --write "$FILE_PATH" 2>/dev/null
        elif command_exists prettier; then
            prettier --write "$FILE_PATH" 2>/dev/null
        # Try eslint as fallback
        elif ESLINT=$(find_project_formatter "$FILE_DIR" "eslint"); then
            "$ESLINT" --fix "$FILE_PATH" 2>/dev/null
        elif command_exists eslint; then
            eslint --fix "$FILE_PATH" 2>/dev/null
        fi
        ;;

    svelte)
        echo "[$(date)] Processing Svelte file" >> /tmp/claude-hook.log
        # Prettier with svelte plugin
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            echo "[$(date)] Running: $PRETTIER --write $FILE_PATH" >> /tmp/claude-hook.log
            "$PRETTIER" --write "$FILE_PATH" 2>>/tmp/claude-hook.log
            echo "[$(date)] Prettier exit code: $?" >> /tmp/claude-hook.log
        elif command_exists prettier; then
            echo "[$(date)] Running global prettier" >> /tmp/claude-hook.log
            prettier --write "$FILE_PATH" 2>>/tmp/claude-hook.log
        fi
        ;;

    json)
        # Format JSON files with prettier
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            "$PRETTIER" --write "$FILE_PATH" 2>/dev/null
        elif command_exists prettier; then
            prettier --write "$FILE_PATH" 2>/dev/null
        elif command_exists jq; then
            # Use jq as fallback for JSON
            jq . "$FILE_PATH" > "$FILE_PATH.tmp" && mv "$FILE_PATH.tmp" "$FILE_PATH" 2>/dev/null
        fi
        ;;

    py)
        # Python formatting
        if command_exists black; then
            black "$FILE_PATH" 2>/dev/null
        elif command_exists ruff; then
            ruff format "$FILE_PATH" 2>/dev/null
        elif command_exists autopep8; then
            autopep8 --in-place "$FILE_PATH" 2>/dev/null
        fi
        ;;

    cs)
        # C# formatting
        if command_exists dotnet; then
            # Try to format the specific file
            dotnet format whitespace "$FILE_PATH" --include "$FILE_PATH" 2>/dev/null
        fi
        ;;

    sh|bash)
        # Shell script formatting
        if command_exists shfmt; then
            shfmt -w "$FILE_PATH" 2>/dev/null
        fi
        ;;

    go)
        # Go formatting
        if command_exists gofmt; then
            gofmt -w "$FILE_PATH" 2>/dev/null
        fi
        ;;

    rs)
        # Rust formatting
        if command_exists rustfmt; then
            rustfmt "$FILE_PATH" 2>/dev/null
        fi
        ;;

    css|scss|sass|less)
        # CSS formatting
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            "$PRETTIER" --write "$FILE_PATH" 2>/dev/null
        elif command_exists prettier; then
            prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;

    html|htm)
        # HTML formatting
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            "$PRETTIER" --write "$FILE_PATH" 2>/dev/null
        elif command_exists prettier; then
            prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;

    md|markdown)
        # Markdown formatting
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            "$PRETTIER" --write "$FILE_PATH" 2>/dev/null
        elif command_exists prettier; then
            prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;

    yaml|yml)
        # YAML formatting
        if PRETTIER=$(find_project_formatter "$FILE_DIR" "prettier"); then
            "$PRETTIER" --write "$FILE_PATH" 2>/dev/null
        elif command_exists prettier; then
            prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;
esac

# Always exit successfully to not block Claude Code
exit 0