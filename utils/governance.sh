apply_governance() {
  USER="$1"
  REPO="$2"
  BRANCH="$3"

  echo "🔒 Securing $REPO..."

  gh api -X PUT "/repos/$USER/$REPO/branches/$BRANCH/protection" \
    -F required_status_checks='{"strict":true,"contexts":["ci"]}' \
    -F enforce_admins=true \
    -F required_pull_request_reviews='{"required_approving_review_count":1}' \
    -F restrictions='null'

  gh api -X PUT "/repos/$USER/$REPO/environments/production/protection_rules" \
    -F wait_timer=60 \
    -F reviewers='[]' \
    -F deployment_branch_policy='{"protected_branches":true,"custom_branch_policies":false}'
}
