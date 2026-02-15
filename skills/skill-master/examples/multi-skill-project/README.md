# Multi-Skill Project Example

This directory demonstrates how **three independent skills** can coexist in a single project,
each covering a different domain.

## Project Layout

```
multi-skill-project/
├── README.md              ← You are here
├── frontend/
│   └── SKILL.md           ← React/UI component expertise
├── backend/
│   └── SKILL.md           ← API and database expertise
└── deploy/
    └── SKILL.md           ← Deployment and infrastructure
```

## How They Work Together

Each skill has a **non-overlapping description**, so the agent picks the right one
based on what you ask:

| You ask about...                | Skill activated |
|---------------------------------|-----------------|
| "Create a new React component"  | `frontend`      |
| "Add an API endpoint"           | `backend`       |
| "Deploy to staging"             | `deploy`        |

## Key Takeaways

1. **One skill per domain** — each skill stays focused
2. **Non-overlapping descriptions** — prevents conflicts
3. **Independent evolution** — change one without affecting others
4. **Shared workspace** — all live under `skills/`

## How to Use This in Your Project

Copy these three skill directories into your project's `skills/`:

```bash
cp -r frontend/ /your-project/skills/frontend/
cp -r backend/ /your-project/skills/backend/
cp -r deploy/ /your-project/skills/deploy/
```

Then customize each `SKILL.md` for your project's specific tech stack and conventions.
