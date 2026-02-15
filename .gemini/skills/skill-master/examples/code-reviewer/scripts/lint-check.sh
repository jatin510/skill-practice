#!/bin/bash
# lint-check.sh — Example linting script for the code-reviewer skill
#
# This is a demonstration script that shows how skills can integrate
# with executable tools. In a real project, this would run actual linters.

set -e

if [ -z "$1" ]; then
  echo "Usage: lint-check.sh <file-or-directory>"
  echo ""
  echo "Runs linting checks on the specified path."
  echo "Supports: .js, .ts, .py, .sh files"
  exit 1
fi

TARGET="$1"

if [ ! -e "$TARGET" ]; then
  echo "Error: '$TARGET' does not exist."
  exit 1
fi

echo "🔍 Linting: $TARGET"
echo "─────────────────────────────────"

# Count files by type
if [ -d "$TARGET" ]; then
  JS_COUNT=$(find "$TARGET" -name "*.js" -o -name "*.ts" 2>/dev/null | wc -l | tr -d ' ')
  PY_COUNT=$(find "$TARGET" -name "*.py" 2>/dev/null | wc -l | tr -d ' ')
  SH_COUNT=$(find "$TARGET" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')

  echo "Found files:"
  echo "  JavaScript/TypeScript: $JS_COUNT"
  echo "  Python:                $PY_COUNT"
  echo "  Shell:                 $SH_COUNT"
  echo ""
else
  echo "Checking single file: $TARGET"
  echo ""
fi

# Demo: check for common issues
echo "Checking for common issues..."

# Check for TODO/FIXME comments
TODOS=$(grep -rn "TODO\|FIXME\|HACK\|XXX" "$TARGET" 2>/dev/null | head -10 || true)
if [ -n "$TODOS" ]; then
  echo ""
  echo "⚠️  Found TODO/FIXME comments:"
  echo "$TODOS"
else
  echo "✅ No TODO/FIXME comments found"
fi

# Check for console.log / print statements
DEBUGS=$(grep -rn "console\.log\|print(" "$TARGET" 2>/dev/null | head -10 || true)
if [ -n "$DEBUGS" ]; then
  echo ""
  echo "⚠️  Found debug output statements:"
  echo "$DEBUGS"
else
  echo "✅ No debug output statements found"
fi

echo ""
echo "─────────────────────────────────"
echo "Lint check complete."
