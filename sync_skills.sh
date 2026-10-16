#!/usr/bin/env bash
# sync_skills.sh — Synchronize and install free-frontier-skills
# Installs into ~/.gemini/config/skills and ~/.pi/agent/skills, and links ~/.local/bin launchers.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEMINI_HARNESS="$HOME/.gemini/config/skills"
PI_HARNESS="$HOME/.pi/agent/skills"
BIN_DIR="$HOME/.local/bin"

EXCLUDES=(
    --exclude "__pycache__"
    --exclude "*.pyc"
    --exclude ".venv"
    --exclude "node_modules"
    --exclude ".git"
    --exclude "README.md"
    --exclude ".env"
    --exclude ".env*"
    --exclude ".DS_Store"
    --exclude "Thumbs.db"
)

DO_PUSH=false
DO_PULL=false

for arg in "$@"; do
    case "$arg" in
        --push|-p)
            DO_PUSH=true
            ;;
        --pull|-u)
            DO_PULL=true
            ;;
        --status|-s)
            echo "📊 [frontier-sync] Repository Status:"
            git -C "$SCRIPT_DIR" status --short
            exit 0
            ;;
    esac
done

if [ "$DO_PULL" = true ]; then
    echo "📥 [frontier-sync] Pulling latest updates from GitHub..."
    git -C "$SCRIPT_DIR" pull origin main
fi

echo "⚡ [frontier-sync] Installing Free Frontier Skills from $SCRIPT_DIR..."

mkdir -p "$GEMINI_HARNESS" "$PI_HARNESS" "$BIN_DIR"

for skill_dir in "$SCRIPT_DIR"/*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name="$(basename "$skill_dir")"
        echo "  📦 Syncing skill: $skill_name"
        mkdir -p "$GEMINI_HARNESS/$skill_name" "$PI_HARNESS/$skill_name"
        rsync -avu "${EXCLUDES[@]}" "$skill_dir" "$GEMINI_HARNESS/$skill_name/" >/dev/null 2>&1
        rsync -avu "${EXCLUDES[@]}" "$skill_dir" "$PI_HARNESS/$skill_name/" >/dev/null 2>&1
    fi
done

echo "🔗 [frontier-sync] Configuring CLI launchers in $BIN_DIR..."

[ -f "$SCRIPT_DIR/openrouter-free/scripts/or_agent.py" ] && ln -sf "$SCRIPT_DIR/openrouter-free/scripts/or_agent.py" "$BIN_DIR/openrouter-free" && chmod +x "$SCRIPT_DIR/openrouter-free/scripts/or_agent.py"
[ -f "$SCRIPT_DIR/nvidia-nim/scripts/nim_client.py" ] && ln -sf "$SCRIPT_DIR/nvidia-nim/scripts/nim_client.py" "$BIN_DIR/nvidia-nim" && chmod +x "$SCRIPT_DIR/nvidia-nim/scripts/nim_client.py"
[ -f "$SCRIPT_DIR/nvidia-nim/scripts/nim_client.py" ] && ln -sf "$SCRIPT_DIR/nvidia-nim/scripts/nim_client.py" "$BIN_DIR/nim"

if [ "$DO_PUSH" = true ]; then
    echo "🚀 [frontier-sync] Committing and pushing updates to GitHub..."
    if [ -d "$SCRIPT_DIR/.git" ]; then
        cd "$SCRIPT_DIR"
        if [ -n "$(git status --porcelain)" ]; then
            git add -A
            git commit -m "sync: free-frontier skills update [$(date -u +'%Y-%m-%dT%H:%M:%SZ')]"
            git push origin main
        else
            echo "✅ Working tree is already clean. Nothing to commit."
        fi
    fi
fi

echo "✅ All Free Frontier skills synchronized into harnesses and ~/.local/bin."
