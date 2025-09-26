#!/bin/bash

USER="your-github-username"
TEMPLATES=("template-python" "template-nodejs" "template-go")

gh auth login --web || { echo "Auth failed"; exit 1; }

echo "📦 Choose a template:"
select template in "${TEMPLATES[@]}"; do
  [[ -n "$template" ]] && break
done

read -p "📝 Enter new repo name: " REPO_NAME
read -p "📄 Enter description: " DESCRIPTION
read -p "🌿 Enter default branch (e.g., main): " DEFAULT_BRANCH

gh repo create "$REPO_NAME" --template "$USER/$template" --public --description "$DESCRIPTION" --confirm

gh api -X PATCH "/repos/$USER/$REPO_NAME" -F default_branch="$DEFAULT_BRANCH"

source utils/governance.sh
apply_governance "$USER" "$REPO_NAME" "$DEFAULT_BRANCH"

echo "✅ Repo $REPO_NAME created and secured."
