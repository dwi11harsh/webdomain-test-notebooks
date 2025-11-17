#!/bin/bash
# Wrapper script for baml-cli generate that automatically fixes path issues
# Usage: ./regenerate_baml.sh
# Or: poetry run ./regenerate_baml.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Regenerating BAML client..."
cd "$SCRIPT_DIR"
poetry run baml-cli generate

echo "🔧 Fixing baml_client paths to use absolute paths..."
poetry run python3 "$SCRIPT_DIR/fix_baml_paths.py"

echo "✅ Done! Your baml_client now always uses the correct project's baml_src directory."

