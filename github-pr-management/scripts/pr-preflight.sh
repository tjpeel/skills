#!/usr/bin/env bash

# Inspect a repository and, if available, its PR metadata without changing
# local or remote state. Intended to be run before a push, PR creation, or PR
# edit.
set -euo pipefail

pr_number="${1:-}"

git rev-parse --is-inside-work-tree >/dev/null

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  echo "Cannot prepare a PR from detached HEAD." >&2
  exit 2
fi

remote_url="$(git remote get-url origin 2>/dev/null || true)"
if [[ -z "$remote_url" ]]; then
  echo "No origin remote is configured." >&2
  exit 2
fi

echo "Repository: $remote_url"
echo "Branch: $branch"

if upstream="$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)"; then
  echo "Upstream: $upstream"
  echo "Unpublished commits:"
  git log --oneline "$upstream"..HEAD
else
  echo "Upstream: none"
  echo "Unpublished commits: branch has no upstream"
fi

echo "Working tree:"
git status --short

if ! command -v gh >/dev/null || ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI: unavailable or unauthenticated; PR metadata not queried."
  exit 0
fi

echo "Pull request:"
if [[ -n "$pr_number" ]]; then
  gh pr view "$pr_number" --json number,url,title,state,isDraft,baseRefName,headRefName \
    --jq '"#\(.number) \(.state) draft=\(.isDraft)\n\(.url)\nbase=\(.baseRefName) head=\(.headRefName)\n\(.title)"'
else
  gh pr view --json number,url,title,state,isDraft,baseRefName,headRefName \
    --jq '"#\(.number) \(.state) draft=\(.isDraft)\n\(.url)\nbase=\(.baseRefName) head=\(.headRefName)\n\(.title)"' \
    || echo "No pull request is associated with this branch."
fi
