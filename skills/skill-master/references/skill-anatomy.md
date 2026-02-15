# Anatomy of an AI Agent Skill

## What Is a Skill?

A skill is a **self-contained directory** that gives an AI coding agent specialized expertise
on a topic. Think of it as a "knowledge pack" — the agent loads it when it recognizes a task that
matches the skill's description.

**Key insight**: Skills use **progressive disclosure**. Only the `name` and `description` from the
frontmatter are loaded initially. The full body is only read when the agent decides to activate the
skill, keeping the context window clean.

## Required File

### `SKILL.md`

This is the **only required file**. It has two parts:

### 1. YAML Frontmatter (Metadata)

```yaml
---
name: my-skill
description: >
  A concise explanation of what this skill does and when
  the agent should consider using it.
---
```

| Field         | Required | Purpose                                                        |
|---------------|----------|----------------------------------------------------------------|
| `name`        | Yes      | Unique identifier. Should match the directory name.            |
| `description` | Yes      | Tells the agent WHEN to activate this skill. Be specific.      |

> **Tip**: The `description` is critical — the agent autonomously decides whether to use a skill
> based on this text. A vague description means the skill may never activate.

### 2. Markdown Body (Instructions)

The body contains the detailed instructions the agent follows when the skill is active. This is
where you put:

- **What** the agent should do (behavior)
- **How** it should do it (process, constraints)
- **What tools/scripts** are available
- **What references** to consult

## Optional Directories

```
my-skill/
├── SKILL.md              # Required — instructions + metadata
├── scripts/              # Optional — executable scripts & utilities
│   ├── build.sh
│   └── validate.py
├── references/           # Optional — static docs, guides, specs
│   ├── api-spec.md
│   └── style-guide.md
├── examples/             # Optional — example code, templates
│   └── template.yaml
└── assets/               # Optional — images, configs, data files
    └── logo.png
```

| Directory    | Purpose                                                      |
|-------------|--------------------------------------------------------------|
| `scripts/`   | Executable scripts the agent can run on your behalf          |
| `references/`| Static documentation the agent reads for context             |
| `examples/`  | Example code, templates, or sample configurations            |
| `assets/`    | Binary files, images, config templates, or data files        |

## Where Skills Live (Discovery Locations)

Skills are typically discovered from three locations, in order of **precedence**:

| Priority | Location                          | Scope                        | Version Control |
|----------|-----------------------------------|------------------------------|-----------------|
| 1 (High) | `<workspace>/skills/` or similar  | Workspace (project-level)    | ✅ Commit it    |
| 2        | `~/skills/` or user-level dir     | User (all your workspaces)   | Optional        |
| 3 (Low)  | Extension-bundled skills          | Per extension                | N/A             |

**Override rule**: If two skills share the same `name`, the higher-precedence location wins.
A workspace skill overrides a user skill with the same name.

### When to Use Each Location

- **Workspace**: Project-specific skills shared with your team (code review standards, deployment steps)
- **User**: Personal skills you want everywhere (your coding style, personal templates)
- **Extensions**: Third-party skills from installed agent extensions

## How Activation Works

```
┌─────────────────────────┐
│  User asks a question    │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Agent reads skill       │
│  names + descriptions    │
│  (lightweight check)     │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Does any skill match?   │──── No ──→ Normal response
└────────────┬────────────┘
             │ Yes
             ▼
┌─────────────────────────┐
│  User gets a consent     │
│  prompt (name + purpose) │
└────────────┬────────────┘
             │ Approved
             ▼
┌─────────────────────────┐
│  Full SKILL.md body +    │
│  references loaded       │
└─────────────────────────┘
```

## Key Differences: Skill vs System Instructions

| Aspect        | System Instructions (e.g. GEMINI.md, CLAUDE.md)  | Skill                              |
|---------------|--------------------------------------------------|------------------------------------|
| Loading       | Always loaded                                    | On-demand (progressive disclosure) |
| Purpose       | Persistent workspace context                     | Specialized, task-specific expertise|
| Scope         | Background instructions                          | Active tool with scripts + docs    |
| Best for      | Coding style, repo conventions                   | Complex workflows, automation      |
