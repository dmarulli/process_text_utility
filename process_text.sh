#!/bin/bash

# Process Text Utility
# Sends selected text to Ollama with a custom prompt and copies result to clipboard

# Read selected text from stdin
SELECTED_TEXT=$(cat)

if [ -z "$SELECTED_TEXT" ]; then
    osascript -e 'display notification "No text selected" with title "Process Text"'
    exit 1
fi

# Check if Ollama is running
if ! curl -s --connect-timeout 2 http://localhost:11434/api/tags > /dev/null 2>&1; then
    osascript -e 'display alert "Ollama Not Running" message "Please start Ollama first. Run: brew services start ollama"'
    exit 1
fi

# Prompt user for the instruction
PROMPT=$(osascript -e 'tell application "System Events"
    activate
    set userInput to display dialog "How should I process this text?" default answer "" buttons {"Cancel", "Process"} default button "Process" with title "Process Text"
    return text returned of userInput
end tell' 2>/dev/null)

# Check if user cancelled
if [ -z "$PROMPT" ]; then
    exit 0
fi

# Show processing notification
osascript -e 'display notification "Processing text with Ollama..." with title "Process Text"'

# Use Python to handle JSON properly and make the API call
export SELECTED_TEXT
export PROMPT
RESULT=$(python3 << 'PYTHON_SCRIPT'
import json
import urllib.request
import urllib.error
import sys
import os

selected_text = os.environ.get('SELECTED_TEXT', '')
prompt = os.environ.get('PROMPT', '')

full_prompt = f"""{prompt}

Here is the text to process:

{selected_text}

Respond with ONLY the processed text, no explanations or additional commentary."""

payload = {
    "model": "gemma2:2b",
    "stream": False,
    "messages": [
        {
            "role": "user",
            "content": full_prompt
        }
    ]
}

try:
    req = urllib.request.Request(
        "http://localhost:11434/api/chat",
        data=json.dumps(payload).encode('utf-8'),
        headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=120) as response:
        data = json.loads(response.read().decode('utf-8'))
        if 'message' in data and 'content' in data['message']:
            print(data['message']['content'], end='')
        else:
            print("ERROR: Unexpected response format", file=sys.stderr)
            sys.exit(1)
except urllib.error.URLError as e:
    print(f"ERROR: Connection failed - {e}", file=sys.stderr)
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f"ERROR: Invalid JSON response - {e}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"ERROR: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT
)

# Check exit status
if [ $? -ne 0 ]; then
    osascript -e "display alert \"Process Text Error\" message \"$RESULT\""
    exit 1
fi

# Copy result to clipboard
echo -n "$RESULT" | pbcopy

# Show success notification
osascript -e 'display notification "Result copied to clipboard!" with title "Process Text" sound name "Glass"'
