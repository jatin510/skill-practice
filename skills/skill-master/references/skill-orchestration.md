# Skill Orchestration: Managing Multiple Skills

## Why Multiple Skills?

As your project grows, you'll need different areas of expertise. Instead of one massive skill
that knows everything, you split concerns:

```
skills/
├── frontend/         # React component patterns
├── backend/          # API design, database queries
├── deploy/           # CI/CD, Docker, deployment
└── testing/          # Test strategies, coverage
```

This keeps each skill **focused**, **maintainable**, and **independently testable**.

## Precedence Rules

When skills from different locations share the same name:

```
Workspace (skills/)  ──→  WINS (highest priority)
User (~/skills/)     ──→  overridden if workspace has same name
Extension (bundled)          ──→  overridden by both above
```

### Use Case: Override an Extension Skill

If an extension provides a `code-review` skill, but you want custom review rules for your
project, just create `skills/code-review/SKILL.md` in your workspace — it will
override the extension's version.

## Composition Patterns

### Pattern 1: Independent Skills

Skills that cover completely separate domains. No cross-references needed.

```
skills/
├── linting/          # Code style and linting
├── database/         # SQL queries and migrations
└── documentation/    # Doc generation
```

**When to use**: When skills have zero overlap in functionality.

### Pattern 2: Layered Skills

Skills that build on each other. The higher-level skill references the lower-level one.

```
skills/
├── git-basics/       # Git commands, branching
└── release-manager/  # Uses git-basics + adds release workflow
```

In `release-manager/SKILL.md`:
```markdown
## Dependencies
This skill builds on the `git-basics` skill. When performing release tasks,
the agent may also need to use git-basics for branching and merging operations.
```

**When to use**: When one skill needs capabilities from another.

### Pattern 3: Workflow Skills

A "conductor" skill that orchestrates a multi-step workflow across other skills.

```
skills/
├── build/            # Build the project
├── test/             # Run tests
├── deploy/           # Deploy to production
└── release-flow/     # Orchestrates: build → test → deploy
```

In `release-flow/SKILL.md`:
```markdown
## Workflow Steps

1. Activate the `build` skill to compile the project
2. Activate the `test` skill to run the full test suite
3. If tests pass, activate the `deploy` skill to push to production
4. Report results back to the user
```

**When to use**: For multi-step processes that span multiple skill domains.

## When to Split vs. Combine

### Split When...

| Signal                                          | Action                    |
|-------------------------------------------------|---------------------------|
| SKILL.md is > 200 lines                         | Split by responsibility   |
| Skill covers 3+ unrelated topics                | Split each into own skill |
| Different team members own different parts       | Split by ownership        |
| Some parts change frequently, others don't       | Split stable from volatile|

### Combine When...

| Signal                                          | Action                    |
|-------------------------------------------------|---------------------------|
| Two skills always activate together              | Merge them                |
| Splitting would create circular dependencies     | Keep as one skill         |
| The combined skill is still < 100 lines          | Keep as one skill         |

## Managing Skill Conflicts

### Same Name, Different Locations

The precedence rule handles this automatically. But if you have TWO skills in the
SAME location with overlapping descriptions, they might compete for activation.

### Fix: Make Descriptions Non-Overlapping

```yaml
# ❌ Overlapping — both might activate for "review my code"
# skill-a
description: Helps review code quality
# skill-b
description: Reviews code for bugs and issues

# ✅ Non-overlapping — clear division
# skill-a
description: Reviews code STYLE (formatting, naming conventions, linting)
# skill-b
description: Reviews code LOGIC (bugs, edge cases, security vulnerabilities)
```

## Workspace vs. User Skills Strategy

```
~/skills/           # Your personal defaults
├── my-coding-style/        # Your preferred patterns & conventions
├── git-workflow/            # Your standard branching strategy
└── template-gen/            # Your project templates

project/skills/     # Project-specific overrides
├── coding-style/            # Team standards (overrides personal)
├── api-design/              # Project-specific API conventions
└── deploy/                  # This project's deployment process
```

## Example: Multi-Skill Project

See the `examples/multi-skill-project/` directory for a working example of three
skills (`frontend/`, `backend/`, `deploy/`) orchestrated together in a single project.
