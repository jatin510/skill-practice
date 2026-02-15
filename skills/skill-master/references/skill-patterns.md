# Common Skill Patterns

A collection of real-world skill patterns you can adapt for your own use.

## Pattern 1: Code Review Skill

**Use case**: Enforce team coding standards automatically.

```yaml
---
name: code-reviewer
description: >
  Reviews code changes for style, correctness, and best practices specific
  to this project. Activate when the user asks for a code review or submits
  changes for review.
---
```

**Key elements**:
- Instructions referencing a `references/style-guide.md`
- A script `scripts/lint.sh` that runs project linters
- Checklists for common issues (null checks, error handling, naming)

---

## Pattern 2: Deployment Skill

**Use case**: Automate deployment to staging/production.

```yaml
---
name: deploy
description: >
  Handles deployment of the application to staging and production environments.
  Activate when the user wants to deploy, check deployment status, or rollback.
---
```

**Key elements**:
- Step-by-step deployment instructions in the body
- Scripts: `scripts/deploy-staging.sh`, `scripts/deploy-prod.sh`, `scripts/rollback.sh`
- References: `references/env-config.md` with environment variables
- Safety constraints: require explicit confirmation before production deploys

---

## Pattern 3: Test Generator Skill

**Use case**: Automatically generate test files for new code.

```yaml
---
name: test-gen
description: >
  Generates unit and integration tests for code files. Activate when the user
  creates a new file and needs tests, or asks for help writing tests.
---
```

**Key elements**:
- Templates in `examples/` for different test frameworks (Jest, pytest, Go testing)
- Instructions on how to analyze the source file and generate matching tests
- A script that discovers untested files

---

## Pattern 4: Documentation Skill

**Use case**: Keep docs in sync with code.

```yaml
---
name: doc-gen
description: >
  Generates and updates documentation for the project. Activate when the user
  asks to document code, update README, or generate API docs.
---
```

**Key elements**:
- Templates for README, API docs, CHANGELOG
- Instructions on extracting info from code comments and types
- References: `references/doc-style.md` with formatting conventions

---

## Pattern 5: Project Scaffolding Skill

**Use case**: Bootstrap new components, features, or services.

```yaml
---
name: scaffold
description: >
  Creates new project components from templates. Activate when the user wants
  to add a new feature, service, component, or module to the project.
---
```

**Key elements**:
- Template files in `examples/` for each component type
- A script that copies templates and replaces placeholders
- Instructions on project conventions (file naming, directory structure)

---

## Pattern 6: Database Migration Skill

**Use case**: Manage database schema changes safely.

```yaml
---
name: db-migrate
description: >
  Creates and manages database migrations. Activate when the user wants to
  modify the database schema, add tables, or update columns.
---
```

**Key elements**:
- References: `references/schema.md` with current database state
- Scripts for generating migration files with timestamps
- Safety constraints: always generate rollback/down migrations

---

## Anti-Patterns to Avoid

### ❌ The "Everything" Skill

```yaml
description: Helps with all aspects of the project
```

Too broad. Will always activate and flood the context. Split by domain.

### ❌ The "Invisible" Skill

```yaml
description: Does things
```

Too vague. Will never activate because the agent can't match user intent.

### ❌ The "Novel" Skill

A SKILL.md body that's 500+ lines of instructions. The agent won't effectively
follow all of them. Keep instructions concise and modular — use references for
the deep details.

### ❌ The "Hardcoded" Skill

A skill that references absolute paths like `/Users/john/projects/my-app/`.
Always use relative paths from the skill directory or the workspace root.

---

## Tips for Writing Great Skills

1. **Start with the description** — if you can't write a clear one, the skill is too vague
2. **Use headers in the body** — the agent navigates them like a table of contents
3. **Give explicit examples** — show the agent what good output looks like
4. **Include error handling** — tell the agent what to do when things go wrong
5. **Keep scripts simple** — one script, one job. Compose them in the SKILL.md body
6. **Test with real prompts** — try 5 different phrasings of what users might ask
7. **Iterate** — your first version won't be perfect. Refine based on how the agent uses it
