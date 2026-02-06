# Waraq Project Guidelines

Cloud-native note-taking system: **Katib** (Go backend), **Daftar** (Hugo frontend), deployed via Terraform + ArgoCD on k3s with LocalStack.

## Build and Test

```bash
# Backend (katib/)
make build          # Build binary
make run            # Build and run locally
make test           # Run tests

# Frontend (daftar/)
make dev            # Hugo dev server (http://localhost:1313)
make build          # Production build

# Infrastructure (devops/terraform/)
./bootstrap.sh      # Initial setup: k3s, LocalStack, S3 state bucket
# Apply workspaces in order: secrets → mongodb-atlas → redis-cloud → k8s
cd secrets && terraform init && terraform apply
```

## Architecture

- **Backend**: Go + Gin, MongoDB Atlas, Redis caching, runs in k3s
- **Frontend**: Hugo static site with PaperMod theme (git submodule), S3-hosted
- **Communication**: Client-side JS → REST API (`/api/v1/notes`), CORS-enabled
- **State**: Fully decoupled - no shared code/databases between services

See [DESIGN.md](../DESIGN.md) for local simulation vs. production architecture.

## Code Conventions

### Go Service ([katib/](../katib/))

**Config**: Centralized in [config.go](../katib/config.go) - load env vars at startup, fail fast on missing required vars, store globally (`var appConfig *Config`)

**Repo Pattern**: [db.go](../katib/db.go) (connections) → [repository.go](../katib/repository.go) (CRUD) → [handlers.go](../katib/handlers.go) (HTTP). Global vars for clients (`mongoClient`, `redisClient`)

**Caching**: Read-through pattern, cache key `"notes:all"`, invalidate on POST. TTL configurable via `REDIS_CACHE_EXPIRATION_MINUTES`

**Error Handling**: `log.Fatal()` for startup failures, return errors with context for runtime issues

**Logging**: Use checkmark for success: `log.Printf("✓ Created note: %s", ...)`

### Hugo Frontend ([daftar/](../daftar/))

**Theme**: PaperMod as submodule - run `git submodule update --init --recursive` after clone

**Env vars**: Use `HUGO_PARAMS_` prefix, access in templates: `{{ getenv "HUGO_PARAMS_API_URL" }}`

**Layouts**: Override theme in [layouts/_default/](../daftar/layouts/_default/) - see [notes.html](../daftar/layouts/_default/notes.html) for client-side fetch pattern

## Infrastructure

### Terraform Structure

Each workspace is isolated with S3 backend ([backend.tf](../devops/terraform/secrets/backend.tf)):
- `secrets/` - Cloud provider credentials → AWS Secrets Manager
- `mongodb-atlas/` - M0 cluster creation
- `redis-cloud/` - Database and subscription
- `k8s/` - Helm charts, ArgoCD, External Secrets Operator

**Naming**: `{project}-{resource}-{identifier}` → `waraq-cluster-001`

### Helm Charts

Single reusable chart: [devops/helm/charts/generic-app/](../devops/helm/charts/generic-app/)

Per-app values: [devops/helm/apps/katib/values.yaml](../devops/helm/apps/katib/values.yaml)

**Secrets**: External Secrets Operator fetches from k8s `vault` namespace (simulates AWS Secrets Manager locally)

### ArgoCD

Apps defined in [argocd_apps.tf](../devops/terraform/k8s/argocd_apps.tf) - auto-sync with prune + selfHeal enabled

## Security Patterns

- **Containers**: Drop all capabilities, read-only rootfs, non-root user (UID 1000)
- **Secrets**: Mount as files (`/app/.env`), never as env vars for sensitive data
- **MongoDB**: `writeconcern.Majority()` with retry writes
- **Local dev**: Public endpoints (MongoDB/Redis); prod uses PrivateLink

## Project-Specific Notes

**Arabic Naming**: Waraq (ورق - paper), Katib (كاتب - writer), Daftar (دفتر - notebook)

**LocalStack Quirks**: 
- Manual S3 bucket creation on each bootstrap (no persistence in free tier)
- Public S3 frontend (no CloudFront support)
- k8s `vault` namespace simulates AWS Secrets Manager

**Multi-stage Deployment**: Apply Terraform workspaces sequentially, then push app secrets via [katib/push_secret_to_cloud.sh](../katib/push_secret_to_cloud.sh)

---

**Key Files**: [README.md](../README.md) · [DESIGN.md](../DESIGN.md) · [katib/config.go](../katib/config.go) · [daftar/hugo.yaml](../daftar/hugo.yaml)
