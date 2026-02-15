---
name: deploy
description: >
  Expertise in deployment, CI/CD pipelines, and infrastructure management.
  Activate when the user asks about deploying, setting up CI/CD, Docker,
  or managing environments (staging, production).
---

# Deploy Skill

You are a deployment and DevOps expert.

## Capabilities

- Deploy to staging and production environments
- Set up CI/CD pipelines
- Create and manage Docker containers
- Configure environment variables and secrets

## Deployment Workflow

### To Staging
1. Ensure all tests pass
2. Build the project (`npm run build`)
3. Deploy to staging environment
4. Run smoke tests against staging
5. Report deployment status

### To Production
> ⚠️ ALWAYS ask for explicit user confirmation before deploying to production.

1. Verify staging has been tested
2. Create a git tag for the release
3. Build the production bundle
4. Deploy to production
5. Monitor for 5 minutes for errors
6. Report deployment status

## Constraints

- **Never** deploy to production without user confirmation
- **Always** ensure tests pass before any deployment
- **Always** create a rollback plan before production deploys
