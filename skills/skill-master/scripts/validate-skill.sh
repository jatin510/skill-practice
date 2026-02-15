#!/bin/bash
# validate-skill.sh — Validate an AI agent skill directory
#
# Usage:
#   validate-skill.sh <path-to-skill-dir>
#
# Checks that a skill has:
#   ✅ A SKILL.md file
#   ✅ Valid YAML frontmatter with '---' delimiters
#   ✅ A 'name' field in the frontmatter
#   ✅ A 'description' field in the frontmatter
#   ✅ Body content below the frontmatter
#   ✅ Scripts are executable (if scripts/ exists)

set -e

# ─── Colors ───────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# ─── Help ─────────────────────────────────────────────
if [ -z "$1" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo ""
  echo -e "${BOLD}validate-skill.sh${NC} — Validate an AI agent skill"
  echo ""
  echo -e "${CYAN}Usage:${NC}"
  echo "  validate-skill.sh <path-to-skill-dir>"
  echo ""
  echo -e "${CYAN}Example:${NC}"
  echo "  validate-skill.sh skills/my-skill"
  echo ""
  exit 0
fi

SKILL_DIR="$1"
SKILL_FILE="$SKILL_DIR/SKILL.md"
ERRORS=0
WARNINGS=0

echo ""
echo -e "${BOLD}🔍 Validating skill: ${CYAN}$SKILL_DIR${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ─── Check 1: SKILL.md exists ────────────────────────
if [ ! -f "$SKILL_FILE" ]; then
  echo -e "${RED}✘ SKILL.md not found${NC}"
  echo "  Expected: $SKILL_FILE"
  echo ""
  echo -e "${RED}FAILED${NC} — Cannot continue without SKILL.md"
  exit 1
else
  echo -e "${GREEN}✔ SKILL.md exists${NC}"
fi

# ─── Check 2: Frontmatter exists ─────────────────────
FIRST_LINE=$(head -1 "$SKILL_FILE")
if [ "$FIRST_LINE" != "---" ]; then
  echo -e "${RED}✘ Missing YAML frontmatter${NC}"
  echo "  First line should be '---' but found: '$FIRST_LINE'"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✔ YAML frontmatter detected${NC}"
fi

# Find the closing '---'
CLOSING_LINE=$(awk 'NR>1 && /^---$/{print NR; exit}' "$SKILL_FILE")
if [ -z "$CLOSING_LINE" ]; then
  echo -e "${RED}✘ Missing closing '---' for frontmatter${NC}"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✔ Frontmatter properly closed (line $CLOSING_LINE)${NC}"
fi

# ─── Check 3: 'name' field ───────────────────────────
if [ -n "$CLOSING_LINE" ]; then
  FRONTMATTER=$(sed -n "2,$((CLOSING_LINE - 1))p" "$SKILL_FILE")

  NAME_VALUE=$(echo "$FRONTMATTER" | grep -E "^name:" | sed 's/^name:[[:space:]]*//' | sed 's/[[:space:]]*$//')
  if [ -z "$NAME_VALUE" ]; then
    echo -e "${RED}✘ Missing 'name' field in frontmatter${NC}"
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}✔ name: ${CYAN}$NAME_VALUE${NC}"

    # Check naming convention: lowercase letters, numbers, and hyphens only
    if [[ ! "$NAME_VALUE" =~ ^[a-z][a-z0-9-]*$ ]]; then
      echo -e "${RED}✘ Invalid name '${NAME_VALUE}' — must be lowercase letters, numbers, and hyphens only${NC}"
      echo "  Try: '$(echo "$NAME_VALUE" | tr '[:upper:] ' '[:lower:]-' | sed 's/[^a-z0-9-]//g')'"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # ─── Check 4: 'description' field ────────────────────
  HAS_DESCRIPTION=$(echo "$FRONTMATTER" | grep -c "^description:" || true)
  if [ "$HAS_DESCRIPTION" -eq 0 ]; then
    echo -e "${RED}✘ Missing 'description' field in frontmatter${NC}"
    ERRORS=$((ERRORS + 1))
  else
    # Check if description contains TODO
    DESC_CONTENT=$(echo "$FRONTMATTER" | sed -n '/^description:/,/^[a-z]/p' | head -5)
    if echo "$DESC_CONTENT" | grep -qi "TODO"; then
      echo -e "${YELLOW}⚠ Description contains TODO — please fill it in${NC}"
      WARNINGS=$((WARNINGS + 1))
    else
      echo -e "${GREEN}✔ description field present${NC}"
    fi
  fi

  # ─── Check 5: Body content ──────────────────────────
  TOTAL_LINES=$(wc -l < "$SKILL_FILE" | tr -d ' ')
  BODY_LINES=$((TOTAL_LINES - CLOSING_LINE))
  if [ "$BODY_LINES" -le 1 ]; then
    echo -e "${RED}✘ No body content below frontmatter${NC}"
    echo "  The body should contain instructions for the agent."
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}✔ Body content present ($BODY_LINES lines)${NC}"
  fi
fi

# ─── Check 6: Scripts are executable ──────────────────
if [ -d "$SKILL_DIR/scripts" ]; then
  SCRIPT_COUNT=0
  NON_EXEC_COUNT=0

  while IFS= read -r -d '' script; do
    # Skip .gitkeep files
    if [[ "$(basename "$script")" == ".gitkeep" ]]; then
      continue
    fi
    SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
    if [ ! -x "$script" ]; then
      echo -e "${YELLOW}⚠ Script not executable: $script${NC}"
      echo "  Fix: chmod +x $script"
      NON_EXEC_COUNT=$((NON_EXEC_COUNT + 1))
      WARNINGS=$((WARNINGS + 1))
    fi
  done < <(find "$SKILL_DIR/scripts" -type f -print0)

  if [ "$SCRIPT_COUNT" -gt 0 ] && [ "$NON_EXEC_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✔ All $SCRIPT_COUNT script(s) are executable${NC}"
  elif [ "$SCRIPT_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠ scripts/ directory exists but is empty${NC}"
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# ─── Check 7: References exist ────────────────────────
if [ -d "$SKILL_DIR/references" ]; then
  REF_COUNT=$(find "$SKILL_DIR/references" -name "*.md" | wc -l | tr -d ' ')
  if [ "$REF_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✔ $REF_COUNT reference doc(s) found${NC}"
  else
    echo -e "${YELLOW}⚠ references/ directory exists but has no .md files${NC}"
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# ─── Summary ──────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "${GREEN}${BOLD}✅ PASSED${NC} — Skill is valid!"
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "${YELLOW}${BOLD}⚠  PASSED with $WARNINGS warning(s)${NC}"
else
  echo -e "${RED}${BOLD}❌ FAILED with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
  exit 1
fi

echo ""
