# Creating a Skill: Step-by-Step Guide

## Overview

This guide walks you through creating an AI agent skill from scratch. By the end,
you'll have a fully functional skill with proper structure, a clear description, and
optional scripts and references.

## Step 1: Choose a Name

Your skill name should be:
- **Lowercase with hyphens** (e.g., `api-tester`, `code-reviewer`, `deploy-helper`)
- **Descriptive** — someone should guess what it does from the name
- **Unique** — no conflicts with other skills in the same scope

```
✅ Good names: api-auditor, react-component-gen, db-migration-helper
❌ Bad names: skill1, my-stuff, helper, utils
```

## Step 2: Create the Directory

```bash
# In your workspace
mkdir -p skills/my-skill

# Or use the scaffolding script
bash skills/skill-master/scripts/create-skill.sh my-skill
```

## Step 3: Write the SKILL.md

### The Frontmatter

```yaml
---
name: my-skill
description: >
  Describe WHEN the agent should use this skill. Be specific about
  the types of tasks, questions, or situations that should trigger it.
---
```

> **Critical**: The `description` determines whether your skill ever gets used. Think about it
> from the agent's perspective — what user request would make this skill relevant?

#### Writing Good Descriptions

```yaml
# ❌ Too vague — agent won't know when to use it
description: Helps with code stuff

# ❌ Too broad — will activate too often
description: Helps with all programming tasks

# ✅ Specific and actionable
description: >
  Expertise in writing and reviewing Python unit tests using pytest.
  Activate when the user asks about testing, wants to create test files,
  or needs help with test fixtures, mocking, or assertions.
```

### The Body

Structure the body to clearly tell the agent:

```markdown
# Skill Title

Brief overview of what this skill does.

## Capabilities

List what the agent can do when this skill is active.

## Instructions

### When the user asks X
Step-by-step behavior for scenario X.

### When the user asks Y
Step-by-step behavior for scenario Y.

## Constraints
- Things the agent should NOT do
- Guardrails and limits

## Available Tools
- Scripts in `scripts/` and how to use them
- References in `references/` and when to read them
```

## Step 4: Add Scripts (Optional)

Scripts extend your skill with executable tools. Place them in `scripts/`:

```bash
mkdir -p skills/my-skill/scripts
```

### Script Best Practices

1. **Use a shebang** (`#!/bin/bash` or `#!/usr/bin/env python3`)
2. **Add usage info** — print help when called with no args or `--help`
3. **Exit with meaningful codes** — `0` for success, non-zero for errors
4. **Be idempotent** — safe to run multiple times
5. **Make them executable** — `chmod +x scripts/my-script.sh`

### Example Script

```bash
#!/bin/bash
# scripts/lint-check.sh — Runs linting on a file or directory

if [ -z "$1" ]; then
  echo "Usage: lint-check.sh <path>"
  echo "Runs linting checks on the specified path."
  exit 1
fi

TARGET="$1"

if [ ! -e "$TARGET" ]; then
  echo "Error: '$TARGET' does not exist."
  exit 1
fi

echo "Running lint check on: $TARGET"
# Your linting logic here
```

## Step 5: Add References (Optional)

References are static documentation the agent reads when it needs context:

```bash
mkdir -p skills/my-skill/references
```

Good candidates for references:
- API specifications
- Style guides
- Architecture documentation
- Decision logs
- Checklists

## Step 6: Validate Your Skill

```bash
bash skills/skill-master/scripts/validate-skill.sh skills/my-skill
```

The validator checks:
- ✅ `SKILL.md` exists
- ✅ YAML frontmatter is present
- ✅ `name` field exists and is non-empty
- ✅ `description` field exists and is non-empty
- ✅ Body content exists below the frontmatter
- ✅ Scripts are executable (if any)

## Step 7: Test Your Skill

1. Open your AI coding agent in your workspace
2. Ask a question that should trigger your skill
3. You should see a consent prompt with your skill's name
4. Approve and verify the agent uses your skill correctly

### Troubleshooting

| Problem                          | Likely Cause                                          | Fix                                                    |
|----------------------------------|-------------------------------------------------------|--------------------------------------------------------|
| Skill doesn't activate           | Vague or misleading `description`                    | Rewrite description to match user's likely phrasing    |
| Skill activates for wrong tasks  | Description is too broad                              | Narrow the description to specific task types          |
| Agent ignores scripts            | Scripts not mentioned in SKILL.md body               | Add explicit instructions in body about when to run    |
| Agent can't find references      | Wrong path in SKILL.md                                | Use relative paths from the skill directory            |

## Quick Reference: Minimal Skill

```
my-skill/
└── SKILL.md
```

```yaml
---
name: my-skill
description: >
  One-sentence description of when to activate.
---

# My Skill

Instructions for the agent when this skill is active.
```

That's it. A single file is all you need to get started!
