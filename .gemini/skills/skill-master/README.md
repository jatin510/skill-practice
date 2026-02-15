# 🧠 Skill-Master — The Complete Guide to Gemini Agent Skills

> **A meta-skill that teaches you everything about creating, structuring, and orchestrating Gemini CLI agent skills.**

---

## Table of Contents

- [What Is This?](#what-is-this)
- [Quick Start](#quick-start)
- [Concepts](#concepts)
  - [What Is a Skill?](#what-is-a-skill)
  - [Skill vs GEMINI.md](#skill-vs-geminimd)
  - [Progressive Disclosure](#progressive-disclosure)
- [Anatomy of a Skill](#anatomy-of-a-skill)
  - [SKILL.md — The Only Required File](#skillmd--the-only-required-file)
  - [YAML Frontmatter](#yaml-frontmatter)
  - [Markdown Body](#markdown-body)
  - [Optional Directories](#optional-directories)
- [Creating a Skill Step-by-Step](#creating-a-skill-step-by-step)
- [Writing Great Descriptions](#writing-great-descriptions)
- [Where Skills Live](#where-skills-live)
- [How Activation Works](#how-activation-works)
- [Multi-Skill Orchestration](#multi-skill-orchestration)
  - [Precedence Rules](#precedence-rules)
  - [Composition Patterns](#composition-patterns)
  - [When to Split vs Combine](#when-to-split-vs-combine)
- [Common Patterns](#common-patterns)
- [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
- [Helper Scripts](#helper-scripts)
- [Examples in This Repo](#examples-in-this-repo)
- [Cheat Sheet](#cheat-sheet)
- [Troubleshooting](#troubleshooting)

---

## What Is This?

This is a **Gemini CLI agent skill** that teaches you about skills themselves. It lives at:

```
.gemini/skills/skill-master/
```

When you ask Gemini about skills (e.g., *"How do I create a skill?"*), this skill activates and
guides you using the reference docs, examples, and scripts included here.

---

## Quick Start

```bash
# 1. Scaffold a new skill
bash .gemini/skills/skill-master/scripts/create-skill.sh my-skill

# 2. Edit the generated SKILL.md
#    → Fill in the description and instructions

# 3. Validate your skill
bash .gemini/skills/skill-master/scripts/validate-skill.sh .gemini/skills/my-skill

# 4. Test it — open Gemini CLI and ask a question your skill should handle
```

---

## Concepts

### What Is a Skill?

A skill is a **self-contained directory** that gives the Gemini CLI agent specialised expertise.
Think of it as a "knowledge pack" — the agent loads it only when it recognises a task that
matches the skill's description.

```
my-skill/
├── SKILL.md          ← Required: instructions + metadata
├── scripts/          ← Optional: runnable tools
├── references/       ← Optional: static docs
└── examples/         ← Optional: templates, samples
```

### Skill vs GEMINI.md

| Aspect        | `GEMINI.md`                           | Skill                                  |
|---------------|---------------------------------------|----------------------------------------|
| **Loading**   | Always loaded (every conversation)    | On-demand (only when matched)          |
| **Purpose**   | Persistent workspace context          | Specialised, task-specific expertise   |
| **Scope**     | Background instructions               | Active tool with scripts + docs        |
| **Best for**  | Coding style, repo conventions        | Complex workflows, automation          |
| **Context**   | Always uses context window space      | Zero cost until activated              |

**Rule of thumb:** If it applies to every conversation → `GEMINI.md`. If it's task-specific → Skill.

### Progressive Disclosure

Skills are efficient because of **progressive disclosure**:

1. **Initially loaded:** Only the `name` and `description` from YAML frontmatter (tiny footprint)
2. **On activation:** The full body, references, scripts are loaded (only when needed)

This means you can have 50 skills installed and the agent's context window stays clean.

---

## Anatomy of a Skill

### SKILL.md — The Only Required File

A single `SKILL.md` is all you need for a working skill. Everything else is optional.

### YAML Frontmatter

The metadata block at the top of `SKILL.md`:

```yaml
---
name: my-skill
description: >
  A concise explanation of what this skill does and WHEN
  the agent should consider using it.
---
```

| Field         | Required | Purpose                                                     |
|---------------|----------|-------------------------------------------------------------|
| `name`        | ✅       | Unique identifier. Should match the directory name.         |
| `description` | ✅       | Tells the agent WHEN to activate. **This is critical.**     |

### Markdown Body

Everything below the closing `---` is the instruction body:

```markdown
# Skill Title

Brief overview.

## Capabilities
- What the agent can do with this skill

## Instructions
### When the user asks [X]
1. Step one
2. Step two

### When the user asks [Y]
1. Different steps

## Available Tools
- `scripts/do-thing.sh <arg>` — description

## Constraints
- Things NOT to do
```

**Best practices for the body:**
- Use **headers** — the agent navigates them like a table of contents
- Use **"When the user asks..."** sections — gives the agent clear scenarios
- Include **explicit examples** of good output
- Keep it **under 200 lines** — use `references/` for deep detail

### Optional Directories

| Directory      | Purpose                                                   | Examples                          |
|----------------|-----------------------------------------------------------|-----------------------------------|
| `scripts/`     | Executable tools the agent can run                        | `build.sh`, `validate.py`        |
| `references/`  | Static docs the agent reads for context                   | `api-spec.md`, `style-guide.md`  |
| `examples/`    | Templates, sample code, reference implementations         | `template.yaml`, `sample.ts`     |
| `assets/`      | Binary files, images, configs                             | `logo.png`, `config.json`        |

---

## Creating a Skill Step-by-Step

### Step 1: Choose a Name

```
✅ Good: api-tester, code-reviewer, deploy-helper, react-component-gen
❌ Bad:  skill1, my-stuff, helper, utils, do-things
```

Rules: lowercase, hyphens only, descriptive, unique.

### Step 2: Create the Directory

```bash
# Using the scaffolding script (recommended)
bash .gemini/skills/skill-master/scripts/create-skill.sh api-tester

# Or manually
mkdir -p .gemini/skills/api-tester
```

### Step 3: Write SKILL.md

Fill in the frontmatter (especially the description!) and the body instructions.

### Step 4: Add Scripts (Optional)

```bash
mkdir -p .gemini/skills/api-tester/scripts
# Create your script, then:
chmod +x .gemini/skills/api-tester/scripts/run-tests.sh
```

Script rules:
- ✅ Use a shebang (`#!/bin/bash`)
- ✅ Print help when called with no args or `--help`
- ✅ Exit with meaningful codes (`0` = success)
- ✅ Be idempotent (safe to run multiple times)
- ✅ Make executable via `chmod +x`

### Step 5: Add References (Optional)

Place `.md` files in `references/` for detailed docs the agent can read when needed.

### Step 6: Validate

```bash
bash .gemini/skills/skill-master/scripts/validate-skill.sh .gemini/skills/api-tester
```

### Step 7: Test

Open Gemini CLI → ask a question your skill should handle → verify it activates and behaves correctly.

---

## Writing Great Descriptions

The `description` is the **single most important line** in your entire skill. The agent decides
whether to activate your skill based purely on this text.

```yaml
# ❌ Too vague — agent doesn't know when to use it
description: Helps with code stuff

# ❌ Too broad — will activate for everything
description: Helps with all programming tasks

# ❌ Too narrow — misses valid use cases
description: Runs pytest on test_login.py only

# ✅ Specific and actionable
description: >
  Expertise in writing and reviewing Python unit tests using pytest.
  Activate when the user asks about testing, wants to create test files,
  or needs help with test fixtures, mocking, or assertions.
```

**Formula:** `[What it does] + [When to activate] + [Key technologies/domains]`

---

## Where Skills Live

Skills are discovered from three locations:

| Priority | Location                | Scope                       | Use Case                           |
|----------|-------------------------|-----------------------------|-------------------------------------|
| 1 (High) | `.gemini/skills/`       | Workspace (project-level)   | Team shared, project-specific       |
| 2        | `~/.gemini/skills/`     | User (all workspaces)       | Personal defaults                   |
| 3 (Low)  | Extension-bundled       | Per extension               | Third-party skills                  |

**Override rule:** Higher priority wins when two skills share the same `name`.

**Strategy:**
```
~/.gemini/skills/              ← Your personal defaults
├── my-coding-style/           ← Your preferred patterns
└── git-workflow/              ← Your branching strategy

project/.gemini/skills/        ← Project-specific (overrides personal)
├── coding-style/              ← Team standards (overrides personal)
└── deploy/                    ← This project's deployment
```

---

## How Activation Works

```
User asks a question
        │
        ▼
Agent reads skill names + descriptions  ← lightweight, all skills
        │
        ▼
Any skill match?
   │         │
   No        Yes
   │         │
   ▼         ▼
Normal    User gets consent prompt
response  (skill name + purpose)
              │
              ▼ Approved
          Full SKILL.md body +
          references loaded
```

---

## Multi-Skill Orchestration

### Precedence Rules

```
Workspace (.gemini/skills/)  →  WINS (highest priority)
User (~/.gemini/skills/)     →  overridden by workspace
Extension (bundled)          →  overridden by both
```

### Composition Patterns

#### Pattern 1: Independent Skills
Separate domains, no cross-references.
```
.gemini/skills/
├── linting/        ← Code style
├── database/       ← SQL and migrations
└── docs/           ← Documentation
```

#### Pattern 2: Layered Skills
One skill builds on another.
```
.gemini/skills/
├── git-basics/         ← Foundation
└── release-manager/    ← Uses git-basics + adds workflow
```

#### Pattern 3: Workflow Skills
A "conductor" skill orchestrates a multi-step process.
```
.gemini/skills/
├── build/
├── test/
├── deploy/
└── release-flow/    ← Orchestrates: build → test → deploy
```

### When to Split vs Combine

| Split when...                              | Combine when...                           |
|--------------------------------------------|-------------------------------------------|
| `SKILL.md` > 200 lines                    | Two skills always activate together       |
| Covers 3+ unrelated topics                | Splitting creates circular dependencies    |
| Different owners for different parts        | Combined skill is still < 100 lines       |
| Some parts change often, others don't       |                                           |

### Avoiding Conflicts

If two skills have overlapping descriptions, they compete for activation. Fix by making descriptions non-overlapping:

```yaml
# ❌ Overlapping — both match "review my code"
skill-a: Reviews code quality
skill-b: Reviews code for bugs

# ✅ Non-overlapping — clear division
skill-a: Reviews code STYLE (formatting, naming, linting)
skill-b: Reviews code LOGIC (bugs, edge cases, security)
```

---

## Common Patterns

| Pattern              | Description                                             | Key Elements                          |
|----------------------|---------------------------------------------------------|---------------------------------------|
| **Code Reviewer**    | Enforce team coding standards                           | Style guide ref + lint script         |
| **Deployer**         | Automate staging/production deploys                     | Deploy scripts + safety constraints   |
| **Test Generator**   | Auto-generate tests for new code                        | Templates + test framework knowledge  |
| **Doc Generator**    | Keep documentation in sync with code                    | Templates + extraction instructions   |
| **Scaffolder**       | Bootstrap new components/features                       | Templates + naming conventions        |
| **DB Migrator**      | Manage schema changes safely                            | Schema ref + migration scripts        |

---

## Anti-Patterns to Avoid

### ❌ The "Everything" Skill
```yaml
description: Helps with all aspects of the project
```
Too broad → always activates → floods context. **Fix:** Split by domain.

### ❌ The "Invisible" Skill
```yaml
description: Does things
```
Too vague → never activates. **Fix:** Be specific about WHEN to activate.

### ❌ The "Novel" Skill
SKILL.md body is 500+ lines. Agent can't follow all instructions effectively.
**Fix:** Keep body concise, move deep detail into `references/`.

### ❌ The "Hardcoded" Skill
References absolute paths like `/Users/john/projects/my-app/`.
**Fix:** Always use relative paths from the skill or workspace root.

---

## Helper Scripts

### `create-skill.sh` — Scaffold New Skills

```bash
# Basic usage
bash .gemini/skills/skill-master/scripts/create-skill.sh my-new-skill

# Custom location
bash .gemini/skills/skill-master/scripts/create-skill.sh my-skill ~/other-project/.gemini/skills

# What it creates:
# .gemini/skills/my-new-skill/
# ├── SKILL.md          ← Templated, ready to edit
# ├── scripts/          ← Empty, add your tools here
# └── references/       ← Empty, add your docs here
```

### `validate-skill.sh` — Validate Skill Structure

```bash
bash .gemini/skills/skill-master/scripts/validate-skill.sh .gemini/skills/my-skill
```

Checks: SKILL.md exists, valid frontmatter, name present, description present, body content exists, scripts executable.

---

## Examples in This Repo

### 1. Hello World (`examples/hello-world/`)
**Complexity:** ⭐  
The simplest possible skill. Just a `SKILL.md` with frontmatter and a short body.
Study this to understand the bare minimum.

### 2. Code Reviewer (`examples/code-reviewer/`)
**Complexity:** ⭐⭐  
A practical skill with a `scripts/lint-check.sh` helper. Shows how to integrate
executable tools and structure a review workflow.

### 3. Multi-Skill Project (`examples/multi-skill-project/`)
**Complexity:** ⭐⭐⭐  
Three skills (`frontend/`, `backend/`, `deploy/`) working together in one project.
Demonstrates orchestration, non-overlapping descriptions, and domain separation.

---

## Cheat Sheet

### Minimal Skill (Copy-Paste Starter)

```yaml
---
name: my-skill
description: >
  [What it does]. Activate when [trigger conditions].
---

# My Skill

[Brief overview]

## Capabilities
- [Capability 1]
- [Capability 2]

## Instructions
### When the user asks [scenario]
1. [Step 1]
2. [Step 2]
```

### Key Commands

| Action                 | Command                                                                  |
|------------------------|--------------------------------------------------------------------------|
| Create a skill         | `bash .gemini/skills/skill-master/scripts/create-skill.sh <name>`        |
| Validate a skill       | `bash .gemini/skills/skill-master/scripts/validate-skill.sh <path>`      |
| List workspace skills  | `ls .gemini/skills/`                                                     |
| List user skills       | `ls ~/.gemini/skills/`                                                   |

### Description Formula

```
[What it does] + [When to activate] + [Key technologies/domains]
```

### Body Structure

```
# Title → Overview → Capabilities → Instructions (per scenario) → Tools → Constraints
```

### Directory Checklist

```
skill-dir/
├── SKILL.md              ✅ Required — name + description + instructions
├── scripts/              ☐  Optional — chmod +x, shebang, help flag
├── references/           ☐  Optional — .md files for deep context
├── examples/             ☐  Optional — templates and samples
└── assets/               ☐  Optional — binary files, images
```

---

## Troubleshooting

| Problem                             | Cause                                 | Fix                                           |
|--------------------------------------|---------------------------------------|-----------------------------------------------|
| Skill never activates                | Vague description                     | Rewrite to match user's likely phrasing       |
| Skill activates for wrong tasks      | Description too broad                 | Narrow to specific task types                 |
| Agent ignores scripts                | Not mentioned in SKILL.md body        | Add explicit instructions on when to run them |
| Agent can't find references          | Wrong paths                           | Use relative paths from skill directory       |
| Two skills compete                   | Overlapping descriptions              | Make descriptions non-overlapping             |
| Skill overridden unexpectedly        | Same name in higher-priority location | Rename one or remove the override             |
| Scripts fail to run                  | Not executable                        | `chmod +x scripts/my-script.sh`               |
| Validation fails on frontmatter      | Missing `---` delimiters              | Ensure `---` on line 1 and after metadata     |

---

*Built with ❤️ as a learning MVP. Explore the `references/` and `examples/` directories for deeper dives into each topic.*
