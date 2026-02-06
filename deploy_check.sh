#!/bin/bash
# Deploy Gate: Verify container image signature before deployment
# Usage: ./deploy_check.sh <image-reference>
#
# This script simulates how a deployment system (e.g., ArgoCD, Kubernetes
# Admission Controller) would verify image signatures before allowing deployment.

set -euo pipefail

IMAGE="${1:?Usage: $0 <image-reference> (e.g., ghcr.io/owner/repo/myapp:latest)}"

echo "============================================"
echo "  Deploy Gate: Image Signature Verification"
echo "============================================"
echo ""
echo "Image: ${IMAGE}"
echo ""

# Verify the image signature using Cosign keyless (OIDC) verification
# Replace <OWNER>/<REPO> with your actual GitHub owner and repository name
echo "Verifying signature..."
if cosign verify \
  --certificate-identity-regexp "https://github.com/.*/.github/workflows/ci.yml@refs/heads/main" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  "${IMAGE}" 2>/dev/null; then
  echo ""
  echo "Signature Verified. Deploying..."
  exit 0
else
  echo ""
  echo "Signature Verification FAILED! Deployment Blocked."
  echo "The image was not signed by the expected CI pipeline."
  exit 1
fi
