#!/bin/bash
# Test A: Parallel edit không conflict — chứng minh file ownership hoạt động
# Chạy từ root của project: bash docs/testing/run-parallel-test.sh

set -e
echo "=== Parallel Work Test ==="
echo ""

# Detect default branch
DEFAULT=$(git remote show origin 2>/dev/null | grep "HEAD branch" | awk '{print $3}')
[ -z "$DEFAULT" ] && DEFAULT=$(git branch --show-current)
echo "Default branch: $DEFAULT"

BRANCH="test/parallel-$(date +%s)"
git checkout -b "$BRANCH" 2>/dev/null

# Tạo thư mục nếu chưa có
mkdir -p src/app/api src/components

# --- Simulate Claude (backend zone) ---
echo "// Claude Code — $(date)" > src/app/api/parallel-test.ts
git add src/app/api/parallel-test.ts
git commit -m "feat(claude/api): parallel test backend" -q
echo "✓ Claude committed: src/app/api/parallel-test.ts"

# --- Simulate Antigravity (frontend zone) ---
echo "// Antigravity — $(date)" > src/components/ParallelTest.tsx
git add src/components/ParallelTest.tsx
git commit -m "feat(antigravity/ui): parallel test frontend" -q
echo "✓ Antigravity committed: src/components/ParallelTest.tsx"

# --- Verify ---
COMMITS=$(git log "$DEFAULT".."$BRANCH" --oneline 2>/dev/null | wc -l | tr -d ' ')
CONFLICTS=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "Results:"
echo "  Commits: $COMMITS (expect 2)"
echo "  Conflicts: $CONFLICTS (expect 0)"
echo ""

if [ "$COMMITS" -eq 2 ] && [ "$CONFLICTS" -eq 0 ]; then
  echo "✅ PASS — 2 agents edited different zones, zero conflicts"
  echo "   Git log:"
  git log "$DEFAULT".."$BRANCH" --oneline | sed 's/^/     /'
else
  echo "❌ FAIL — unexpected state (commits=$COMMITS conflicts=$CONFLICTS)"
fi

# --- Cleanup ---
git checkout "$DEFAULT" -q
git branch -D "$BRANCH" -q
rm -f src/app/api/parallel-test.ts src/components/ParallelTest.tsx
echo ""
echo "Cleanup done."
