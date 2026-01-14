# Waraq Project

A cloud-native note-taking application demonstrating modern DevOps practices with Kubernetes, Terraform, and microservices architecture.

## Project Overview

**Waraq** (Arabic: ورق - "paper") is a full-stack note-taking system consisting of:

- **Katib** (كاتب - "writer"): Go-based backend API service
- **Daftar** (دفتر - "notebook"): Hugo-based static frontend

## Architecture

- **Backend**: Go microservice with MongoDB Atlas and Redis Cloud
- **Frontend**: Static site served from S3-compatible storage
- **Infrastructure**: Kubernetes (k3s) with ArgoCD for GitOps
- **Secrets Management**: AWS Secrets Manager simulation via LocalStack

## Prerequisites

Before getting started, install the following tools:

- **LocalStack** - AWS service emulator for local development ([Install](https://docs.localstack.cloud/getting-started/installation/))
- **Docker** - Container runtime ([Install](https://docs.docker.com/get-docker/))
- **k3s** - Lightweight Kubernetes distribution ([Install](https://docs.k3s.io/quick-start))
- **Terraform** - Infrastructure as Code tool ([Install](https://developer.hashicorp.com/terraform/downloads))
- **Helm** - Kubernetes package manager ([Install](https://helm.sh/docs/intro/install/))
- **kubectl** - Kubernetes command-line tool ([Install](https://kubernetes.io/docs/tasks/tools/))

## Getting Started

### 1. Bootstrap Infrastructure

Start LocalStack and k3s, then create the Terraform state bucket:

```bash
cd devops/terraform
./bootstrap.sh
```

This script will:

- Ensure k3s service is running
- Start LocalStack in detached mode
- Create an S3 bucket for Terraform state management
- Enable versioning on the state bucket

### 2. Configure Cloud Provider Credentials

Create accounts and obtain credentials from:

- **MongoDB Atlas**: [Sign up here](https://www.mongodb.com/cloud/atlas/register)
  - Navigate to Organization Settings → Access Manager → API Keys
  - Create an API key with Project Owner permissions
  - Note down the Client ID and Client Secret
  - Add your IP address to the Project Network Access whitelist (NAT IP if you're using one)

- **Redis Cloud**: [Sign up here](https://redis.com/try-free/)
  - Navigate to Account Settings → API Keys
  - Create a new API key
  - Note down the API Key and Secret Key

### 3. Set Up Secrets Workspace

Create a `terraform.tfvars` file in [`devops/terraform/secrets/`](devops/terraform/secrets/):

```bash
cd devops/terraform/secrets
cp terraform.tfvars.example terraform.tfvars
```

Add your credentials:

```hcl
# devops/terraform/secrets/terraform.tfvars
# MongoDB Atlas credentials
# https://www.mongodb.com/docs/atlas/configure-api-access/?programmatic-access=service-account&interface=atlas-ui#std-label-create-org-api-key
mongodbatlas_client_id     = "your-mongodb-atlas-client-id"
mongodbatlas_client_secret = "your-mongodb-atlas-client-secret"

# Redis Cloud credentials
# https://redis.io/docs/latest/integrate/terraform-provider-for-redis-cloud/get-started/
rediscloud_api_key    = "your-rediscloud-api-key"
rediscloud_secret_key = "your-rediscloud-secret-key"
```

> **Note**: This file is `.gitignore`d for security. For production, use [`push_tfvars.sh`](devops/terraform/secrets/push_tfvars.sh) to upload to AWS Secrets Manager for collaboration with other team members.

Initialize and apply:

```bash
terraform init
terraform apply
```

### 4. Deploy Infrastructure (Order Matters)

#### 4.1 MongoDB Atlas

```bash
cd ../mongodb-atlas
terraform init
terraform apply
```

This creates:

- MongoDB Atlas project
- Free tier M0 cluster in EU_WEST_1
- TODO: Provider connection string stored in AWS Secrets Manager (LocalStack)

#### 4.2 Redis Cloud

```bash
cd ../redis-cloud
terraform init
terraform apply
```

This creates:

- Redis Cloud subscription
- 30MB free tier database
- TODO: Connection details stored in AWS Secrets Manager (LocalStack)

#### 4.3 S3 Buckets

```bash
cd ../buckets
terraform init
terraform apply
```

This creates:

- S3 bucket for Daftar static site hosting
- Website configuration with public read access

**Note**: An S3 public bucket is created as LocalStack free tier doesn't support CloudFront distributions.

#### 4.4 Kubernetes Resources

```bash
cd ../k8s
terraform init
terraform apply
```

This deploys:

- External Secrets Operator (for syncing AWS Secrets Manager to K8s)
- Vault namespace (simulating AWS Secrets Manager)
- Cluster Secret Store for Kubernetes secrets
- ArgoCD for GitOps
- ArgoCD repositories and applications

**Post-deployment step**: Add SSH deploy keys to your repositories:

1. Retrieve the public SSH key from AWS Secrets Manager:

   ```bash
   aws --profile localstack secretsmanager get-secret-value \
     --secret-id argocd-openssh-public-key-<REPO_NAME> \
     --query SecretString --output text
   ```

2. Add this public key as a deploy key in your Git repository:
   - Navigate to your repository settings
   - Go to Deploy Keys section
   - Add the public key with **read-only** access
   - Repeat for each repository configured in ArgoCD

### 5. Application Setup

#### 5.1 Katib (Backend)

Detailed setup instructions are in [katib/README.md](katib/README.md), but in brief:

1. Push environment variables to AWS Secret Manager (vault namespace)

   ```bash
   cd ./katib
   # Create .env file with MongoDB and Redis connection details
   ./push_secret_to_cloud.sh
   ```

2. Template the app via Helm (to know what ArgoCD will deploy)

    ```bash
    cd ./devops/helm
    make template APP=katib NAMESPACE=waraq
    ```

3. ArgoCD should automatically sync and deploy Katib to the k3s cluster.

#### 5.2 Daftar (Frontend)

Detailed instructions are in [daftar/README.md](daftar/README.md), but in brief:

1. Configure environment:

   ```bash
   cd ./daftar
   # initialize theme submodule
   git submodule update --init --recursive
   cp .env.example .env
   # Edit .env with your API URL
   ```

2. Build and deploy:

   ```bash
   hugo --gc --minify
   # Upload public/ directory contents to S3 bucket
   aws --profile localstack s3 sync public/ s3://daftar.dev/
   ```

## Project Structure

```text
.
├── .github/workflows/       # CI/CD pipelines
├── daftar/                  # Hugo frontend (see daftar/README.md)
├── katib/                   # Go backend (see katib/README.md)
└── devops/
    ├── helm/               # Helm charts for K8s deployments
    │   ├── apps/          # Application-specific values
    │   └── charts/        # Generic Helm chart template
    └── terraform/         # Infrastructure as Code
        ├── secrets/       # Credentials management
        ├── mongodb-atlas/ # MongoDB cluster
        ├── redis-cloud/   # Redis database
        ├── buckets/       # S3 static hosting
        └── k8s/           # Kubernetes resources
```

## Accessing Services

Once deployed:

- **Frontend**: `http://daftar.dev.s3-website.localhost.localstack.cloud:4566`
    > **Note**: this works without any local dns changes as localstack maps the public domain `localhost.localstack.cloud` to `127.0.0.1` but this requires access to the internet to resolve the domain. alternatively, you can add `localhost.localstack.cloud` to your `/etc/hosts` file pointing to `127.0.0.1`.
- **Backend API**: `http://api.daftar.dev` (via Kubernetes Ingress)
    > **Note**: Ensure your `/etc/hosts` has an entry for `api.daftar.dev` pointing to `127.0.0.1` to access the API locally using traefik ingress in k3s which listens on localhost.
- **ArgoCD**: `kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443`
  - Access at `https://localhost:8080`
  - Get admin password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

## Development Workflow

1. **Local Development**:
   - Backend: See [katib/README.md](katib/README.md) for local development
   - Frontend: See [daftar/README.md](daftar/README.md) for Hugo development server

2. **Deployments**:
    - **Katib (Backend)**:
      - Push changes to `main` branch with tags matching `katib-v*.*`, the image tag becomes `v*.*`
      - GitHub Actions builds and pushes Docker image to Docker Hub _(Set up Docker Hub secrets in GitHub)_
      - ArgoCD automatically syncs changes to Kubernetes
    - **Daftar (Frontend)**:
      - TODO: Automated deployment pipeline.

3. **Infrastructure Changes**:
   - Modify Terraform files in relevant workspace
   - Run `terraform plan` to preview changes
   - Run `terraform apply` to apply changes

## Useful Commands

### Kubernetes

```bash
# View all pods
kubectl get pods -A

# View Katib logs
kubectl logs -n waraq -l app=katib -f

# Restart Katib deployment
kubectl rollout restart deployment/katib -n waraq
```

## Troubleshooting

### LocalStack Issues

```bash
# Check LocalStack status
localstack status

# View LocalStack logs
localstack logs

# Restart LocalStack
localstack restart
```

### k3s Issues

```bash
# Check k3s status
sudo systemctl status k3s

# Restart k3s
sudo systemctl restart k3s

# View k3s logs
sudo journalctl -u k3s -f
```

### ArgoCD Sync Issues

```bash
# View sync status
kubectl get application -n argocd
```

## Contributing

See individual component READMEs for contribution guidelines:

- [Katib Backend](katib/README.md)
- [Daftar Frontend](daftar/README.md)

## License

This project is for demonstration and educational purposes.
