#!/usr/bin/env bash
set -euo pipefail
command -v python3 >/dev/null || { echo "python3 required"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PLUGIN_NAME="maindex-expert"
PLUGIN_ID="${PLUGIN_NAME}@local"
TARGET="$HOME/.cursor/plugins/$PLUGIN_NAME"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_PLUGINS="$CLAUDE_DIR/plugins/installed_plugins.json"
CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"

echo "Installing $PLUGIN_NAME plugin locally..."
echo "  Source: $REPO_ROOT"
echo "  Target: $TARGET"

# 1. Copy plugin files
rm -rf "$TARGET"
mkdir -p "$TARGET"
for dir in .cursor-plugin .mcp.json agents assets rules skills; do
  src="$REPO_ROOT/$dir"
  if [ -e "$src" ]; then
    cp -R "$src" "$TARGET/"
  fi
done
echo "  Copied plugin files."

# 2. Register in installed_plugins.json (upsert, don't clobber other plugins)
mkdir -p "$CLAUDE_DIR/plugins"
python3 - "$CLAUDE_PLUGINS" "$PLUGIN_ID" "$TARGET" <<'PY'
import json, os, sys
path, pid, ipath = sys.argv[1], sys.argv[2], sys.argv[3]
data = {}
if os.path.exists(path):
    try:
        data = json.load(open(path))
    except Exception:
        data = {}
plugins = data.get("plugins", {})
entries = [e for e in plugins.get(pid, [])
           if not (isinstance(e, dict) and e.get("scope") == "user")]
entries.insert(0, {"scope": "user", "installPath": ipath})
plugins[pid] = entries
data["plugins"] = plugins
os.makedirs(os.path.dirname(path), exist_ok=True)
json.dump(data, open(path, "w"), indent=2)
PY
echo "  Registered in installed_plugins.json."

# 3. Enable in settings.json (upsert, don't clobber other settings)
python3 - "$CLAUDE_SETTINGS" "$PLUGIN_ID" <<'PY'
import json, os, sys
path, pid = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(path):
    try:
        data = json.load(open(path))
    except Exception:
        data = {}
data.setdefault("enabledPlugins", {})[pid] = True
os.makedirs(os.path.dirname(path), exist_ok=True)
json.dump(data, open(path, "w"), indent=2)
PY
echo "  Enabled in settings.json."

echo ""
echo "Done. Restart Cursor to activate the plugin."
echo "  - MCP server: Settings > Features > Model Context Protocol"
echo "  - Rules: Settings > Rules"
echo "  - Skills: /memory-organizer in chat"
echo "  - Agent: The Archivist (Expert)"
