# DevSecOps GitHub Actions Workflows

> Integrating security throughout the software development lifecycle with automated CI/CD pipelines and DevSecOps best practices.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Workflows](#workflows)
- [Configuration](#configuration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository demonstrates a comprehensive DevSecOps implementation using GitHub Actions. It provides production-ready workflows for integrating security scanning, vulnerability detection, compliance checks, and containerized deployment into your CI/CD pipeline.

The solution follows industry best practices for:
- **Shift-Left Security**: Security checks early in the development process
- **Infrastructure as Code**: Declarative workflow definitions
- **Container Security**: Docker image scanning and signing
- **Dependency Management**: Automated vulnerability tracking
- **Compliance Automation**: Policy enforcement and audit trails

## Architecture

```
┌─────────────────────────────────────────────────────┐
│           GitHub Repository Events                   │
│  (Push, Pull Request, Schedule, Manual Trigger)      │
└────────────────────┬────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    ┌────▼────┐          ┌───────▼──────┐
    │  Lint   │          │ Unit Tests   │
    └────┬────┘          └───────┬──────┘
         │                       │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │  SAST / Code Scan     │
         │  (Trivy, Semgrep)     │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │ Build & Push Image    │
         │ (Docker Registry)     │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │  Image Scanning       │
         │  (Trivy, Grype)       │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │  Dependency Check     │
         │  (OWASP, Dependabot)  │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │ Deploy to Registry    │
         │ (with attestation)    │
         └───────────────────────┘
```

## Features

### 🔒 Security Scanning
- **Static Application Security Testing (SAST)** using Trivy and Semgrep
- **Software Composition Analysis (SCA)** for dependency vulnerabilities
- **Container Image Scanning** before registry push
- **Secret Detection** to prevent credential leaks

### 🐳 Container Management
- Multi-stage Docker builds for optimized images
- Docker Compose support for local development
- Image vulnerability scanning and reporting
- Registry authentication and signed images

### 🚀 CI/CD Pipeline
- Automated testing on every commit
- Linting and code quality checks
- Build and push workflows
- Automated deployment triggers

### 📊 Compliance & Monitoring
- Configuration audit logs
- Build artifacts tracking
- Deployment records
- Compliance reporting

### ⚙️ Infrastructure as Code
- YAML-based workflow definitions
- Reusable workflow components
- Environment-specific configurations
- Policy as Code enforcement

## Project Structure

```
github-actions-DevSecOps/
├── .github/
│   ├── workflows/           # GitHub Actions workflow definitions
│   │   ├── ci.yml          # CI pipeline with security checks
│   │   ├── container.yml   # Container build and scan
│   │   └── deploy.yml      # Deployment workflow
│   └── dependabot.yml      # Dependency update configuration
├── app.py                   # Sample Python application
├── Dockerfile              # Multi-stage Docker build
├── docker-compose.yml      # Local development environment
├── requirements.txt        # Python dependencies
├── template/               # Workflow templates
└── README.md              # This file
```

## Prerequisites

### Local Development
- **Git** (v2.28+)
- **Python** (v3.8+)
- **Docker** (v20.10+)
- **Docker Compose** (v2.0+)

### GitHub Configuration
- GitHub repository with Actions enabled
- Docker Hub or container registry access (optional)
- Required secrets configured in repository settings

### Required GitHub Secrets
```
DOCKER_USERNAME       # Container registry username
DOCKER_PASSWORD       # Container registry token/password
GITHUB_TOKEN          # Auto-generated (for PR comments)
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Harsh7209/github-actions-DevSecOps.git
cd github-actions-DevSecOps
```

### 2. Local Setup

```bash
# Create Python virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Local Testing with Docker Compose

```bash
# Build and run services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 4. Configure GitHub Secrets

Navigate to your repository:
1. Settings → Secrets and variables → Actions
2. Add the required secrets (see Prerequisites)
3. Save and commit

### 5. Trigger Workflows

- **Push to main branch**: Automatically triggers CI pipeline
- **Create Pull Request**: Runs security checks before merge
- **Manual Trigger**: Via GitHub Actions tab with workflow dispatch

## Workflows

### 1. CI/CD Pipeline (`.github/workflows/ci.yml`)

**Triggers:** Push, Pull Request, Schedule (daily)

**Steps:**
1. Checkout code
2. Set up Python environment
3. Lint code (pylint, flake8)
4. Run unit tests with coverage
5. SAST scanning (Trivy, Semgrep)
6. Upload security reports
7. Comment on PRs with results

**Example Output:**
```
✅ Linting: PASSED
✅ Unit Tests: PASSED (95% coverage)
✅ SAST Scan: 2 issues found (1 critical, 1 medium)
⚠️  Review security findings before merge
```

### 2. Container Workflow (`.github/workflows/container.yml`)

**Triggers:** Tag creation, Manual trigger

**Steps:**
1. Build Docker image
2. Scan image for vulnerabilities
3. Tag and push to registry
4. Sign image (optional)
5. Generate SBOM (Software Bill of Materials)

**Registry Support:**
- Docker Hub
- GitHub Container Registry (ghcr.io)
- AWS ECR
- Azure Container Registry

### 3. Dependency Management (`.github/workflows/dependabot.yml`)

**Triggers:** Automated daily checks

**Features:**
- Auto-update vulnerable dependencies
- Group updates by type
- Auto-merge patch updates
- Create detailed change logs

## Configuration

### Environment Variables

Create `.env` file or configure in GitHub:

```bash
# Registry Configuration
REGISTRY=docker.io
REGISTRY_USERNAME=your-username
IMAGE_NAME=github-actions-devsecops

# Scanning Configuration
TRIVY_SEVERITY=CRITICAL,HIGH
SEMGREP_CONFIG=p/security-audit

# Deployment Configuration
DEPLOY_ENVIRONMENT=staging
```

### Workflow Customization

Edit `.github/workflows/*.yml` to:
- Add/remove security tools
- Change scan severity levels
- Modify deployment targets
- Adjust notification channels

Example: Modify SAST severity in `ci.yml`
```yaml
- name: Run Trivy Scan
  run: |
    trivy fs --severity HIGH,CRITICAL .
```

## Best Practices

### 🛡️ Security Hardening

1. **Principle of Least Privilege**
   - Use minimal permissions for service accounts
   - Scope GitHub tokens appropriately
   - Implement RBAC for deployments

2. **Secret Management**
   - Store credentials in GitHub Secrets, not code
   - Rotate tokens regularly
   - Use short-lived credentials where possible
   - Enable secret scanning on repository

3. **Container Security**
   - Use minimal base images (Alpine, distroless)
   - Run as non-root user
   - Scan images before deployment
   - Sign and verify images

4. **Dependency Management**
   - Keep dependencies up-to-date
   - Use lock files (requirements.txt)
   - Monitor security advisories
   - Vendor critical dependencies carefully

### 📈 Pipeline Optimization

1. **Performance**
   - Use caching for dependencies
   - Parallelize independent jobs
   - Use container images pre-built with tools
   - Cache Docker layer builds

2. **Reliability**
   - Add retry logic for flaky tests
   - Set appropriate timeouts
   - Monitor workflow execution times
   - Document manual approvals

3. **Observability**
   - Generate detailed logs
   - Export metrics and traces
   - Create dashboards for pipeline health
   - Alert on critical failures

### 📋 Compliance

1. **Audit Trails**
   - Log all deployments
   - Track security findings
   - Maintain approval records
   - Archive workflow runs

2. **Consistency**
   - Standardize workflow templates
   - Document configuration decisions
   - Enforce policy through branch protection
   - Review changes through PRs

3. **Documentation**
   - Keep README updated
   - Document all scripts
   - Provide runbooks for issues
   - Include architecture diagrams

## Troubleshooting

### Common Issues

**Issue: "Docker layer caching not working"**
```bash
# Solution: Enable BuildKit
export DOCKER_BUILDKIT=1
docker build .
```

**Issue: "Trivy scan fails with rate limits"**
```bash
# Solution: Cache Trivy DB
- name: Run Trivy with Cache
  run: |
    trivy image --cache-dir /tmp/trivy-cache myimage:latest
```

**Issue: "PR comment not appearing"**
- Verify GITHUB_TOKEN has write permissions
- Check workflow permissions in repository settings
- Ensure comment step comes after security scan

**Issue: "Image push authentication fails"**
- Verify registry credentials in GitHub Secrets
- Check Docker registry connectivity
- Confirm credentials haven't expired

### Debug Mode

Enable debug logging:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
  TRIVY_DEBUG: true
```

## Contributing

### Development Workflow

1. Create feature branch: `git checkout -b feature/add-new-scan`
2. Make changes and test locally
3. Commit with descriptive messages
4. Push to feature branch
5. Create Pull Request with details
6. Address review comments
7. Merge after approval

### Testing Changes

```bash
# Validate workflow syntax
- Install: pip install pre-commit
- Run: pre-commit run --all-files

# Test locally with act
- Install: https://github.com/nektos/act
- Run: act push -l
```

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Trivy Security Scanner](https://github.com/aquasecurity/trivy)
- [Semgrep SAST Tool](https://semgrep.dev/)
- [OWASP Dependency Check](https://owasp.org/www-project-dependency-check/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Last Updated:** 2026-03-25 22:17:31  
**Maintainer:** DevSecOps Team  
**Status:** Active Development