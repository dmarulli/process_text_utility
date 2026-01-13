#!/bin/bash

# Process Text Utility - Uninstallation Script

echo "Uninstalling Process Text Utility..."

rm -rf "$HOME/Library/Scripts/ProcessText"
rm -rf "$HOME/Library/Services/Process Text.workflow"

echo "Uninstalled. You may want to also remove:"
echo "  - ~/.config/process_text/ (contains your API key)"
echo ""
echo "Run '/System/Library/CoreServices/pbs -flush' to refresh the Services menu."
