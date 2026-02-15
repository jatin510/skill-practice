#!/bin/bash
# create-skill.sh — Scaffold a new AI agent skill
#
# Usage:
#   create-skill.sh <skill-name> [target-dir]
#
# Creates a new skill directory with a templated SKILL.md and
# optional subdirectories (scripts/, references/).
#
# Arguments:
#   skill-name   Name of the new skill (lowercase-with-hyphens)
#   target-dir   Optional. Where to create the skill.
#                 Default: skills/ in the current workspace

set -e

# ─── Colors ───────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ─── Help ─────────────────────────────────────────────
if [ -z "$1" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo ""
  echo -e "${BOLD}create-skill.sh${NC} — Scaffold a new AI agent skill"
  echo ""
  echo -e "${CYAN}Usage:${NC}"
  echo "  create-skill.sh <skill-name> [target-dir]"
  echo ""
  echo -e "${CYAN}Arguments:${NC}"
  echo "  skill-name   Name of the skill (lowercase-with-hyphens)"
  echo "  target-dir   Where to create the skill (default: skills/)"
  echo ""
  echo -e "${CYAN}Examples:${NC}"
  echo "  create-skill.sh api-tester"
  echo "  create-skill.sh doc-gen ~/my-project/skills"
  echo ""
  exit 0
fi

SKILL_NAME="$1"
TARGET_DIR="${2:-skills}"

# ─── Validate name ────────────────────────────────────
if [[ ! "$SKILL_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo -e "${RED}Error:${NC} Skill name must be lowercase with hyphens only."
  echo "  Got: '$SKILL_NAME'"
  echo "  Example: 'api-tester', 'code-reviewer', 'deploy-helper'"
  exit 1
fi

SKILL_DIR="$TARGET_DIR/$SKILL_NAME"

# ─── Check if already exists ──────────────────────────
if [ -d "$SKILL_DIR" ]; then
  echo -e "${RED}Error:${NC} Directory '$SKILL_DIR' already exists."
  echo "  Remove it first or choose a different name."
  exit 1
fi

# ─── Create the structure ─────────────────────────────
echo ""
echo -e "${BOLD}🛠  Creating skill: ${CYAN}$SKILL_NAME${NC}"
echo -e "   Location: ${SKILL_DIR}"
echo ""

mkdir -p "$SKILL_DIR/scripts"
mkdir -p "$SKILL_DIR/references"

# ─── SKILL.md ─────────────────────────────────────────
cat > "$SKILL_DIR/SKILL.md" << 'TEMPLATE'
---
name: SKILL_NAME_PLACEHOLDER
description: >
  TODO: Write a clear, specific description of what this skill does and when
  the agent should activate it. Be specific about the types of tasks, questions,
  or situations that should trigger this skill.
---

# SKILL_NAME_PLACEHOLDER

Brief overview of what this skill does.

## Capabilities

- TODO: List what the agent can do when this skill is active
- TODO: Add more capabilities

## Instructions

### When the user asks to [do something]
1. First, ...
2. Then, ...
3. Finally, ...

### When the user asks about [something else]
1. Read `references/` for context
2. Provide a clear explanation

## Available Tools

- `scripts/` — Add executable scripts here and document their usage

## Constraints

- TODO: Add any limitations or guardrails
TEMPLATE

# Replace placeholder with actual skill name
sed -i '' "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_DIR/SKILL.md"

# ─── .gitkeep for empty dirs ─────────────────────────
touch "$SKILL_DIR/scripts/.gitkeep"
touch "$SKILL_DIR/references/.gitkeep"

# ─── Summary ──────────────────────────────────────────
echo -e "${GREEN}✅ Skill created successfully!${NC}"
echo ""
echo "   Files:"
echo -e "   ${CYAN}$SKILL_DIR/SKILL.md${NC}          ← Edit this with your instructions"
echo -e "   ${CYAN}$SKILL_DIR/scripts/${NC}           ← Add executable scripts here"
echo -e "   ${CYAN}$SKILL_DIR/references/${NC}        ← Add reference docs here"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Edit SKILL.md — fill in the description and instructions"
echo "  2. Add any scripts to scripts/"
echo "  3. Add any reference docs to references/"
echo "  4. Validate: bash skills/skill-master/scripts/validate-skill.sh $SKILL_DIR"
echo ""
