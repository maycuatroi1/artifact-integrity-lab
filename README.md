# Lab 3: Artifact Integrity — Signing & SBOM (Answer Key)

## Overview
This repository is the **answer key** for Lab 3 of Chapter 9 (Secure CI/CD).

Students learn to protect the supply chain at the Build & Package stage by creating Docker images, generating SBOMs (Software Bill of Materials), and digitally signing artifacts with Cosign (Sigstore).

## Branch

### `main` — Complete Solution
- Express app with Dockerfile
- CI pipeline that builds, pushes to GHCR, generates SBOM, and signs the image
- Deploy verification script (`deploy_check.sh`)
- **Expected result: Image is built, signed, and SBOM is generated**

No `vulnerable` branch — this lab is about building integrity controls, not breaking them.

## Pipeline Jobs (`ci.yml`)
1. **build** — Checkout, setup Node.js 18, `npm ci`, `npm test`
2. **build-and-sign** (needs: build)
   - Install Cosign (sigstore/cosign-installer)
   - Login to GHCR (GitHub Container Registry)
   - Build & push Docker image
   - Generate SBOM with Trivy (CycloneDX format)
   - Upload SBOM as GitHub Actions artifact
   - Sign image with Cosign (keyless/OIDC)
   - Attest SBOM to image

## Verification
After the pipeline runs, verify the signature locally:
```bash
./deploy_check.sh ghcr.io/<OWNER>/<REPO>/myapp:latest
```

## How to Use
1. Fork this repository
2. Push to main to trigger the pipeline
3. Check GitHub Packages for the signed container image
4. Run `deploy_check.sh` to verify the signature
