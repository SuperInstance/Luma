#!/bin/bash
# boot_luma_agent.sh — Boot Luma as a git-agent for a specific task
# Usage: ./boot_luma_agent.sh "Add generic type support to type checker"

set -e
REPO="SuperInstance/Luma"
BRANCH="agent-$(date +%Y%m%d-%H%M%S)"

echo "🔮 Booting Luma agent..."
echo "   Task: $1"
echo ""

# Clone if needed
if [ ! -d "Luma" ]; then
    git clone "https://github.com/$REPO.git" Luma
fi
cd Luma

# Pull latest
git pull --rebase

# Create task branch
git checkout -b "$BRANCH"

# Read context
echo "📋 Reading context..."
cat CHARTER.md 2>/dev/null | head -20
echo "---"
cat STATE.md 2>/dev/null | head -20
echo "---"
echo "Task: $1"
echo ""

# Build
echo "🔨 Building Luma compiler..."
make 2>&1 | tail -3

# Run tests
echo "🧪 Running tests..."
make test 2>&1 | tail -5 || true

# Read any bottles
echo ""
echo "📬 Checking for fleet bottles..."
ls for-fleet/BOTTLE-*.md 2>/dev/null && cat for-fleet/BOTTLE-*.md || echo "No bottles"

echo ""
echo "✅ Luma agent booted. Task: $1"
echo "   Work in this directory. Commit with: git commit -m '[luma] description'"
echo "   When done: git push origin $BRANCH"
echo "   Create PR or notify Oracle1 of completion."
