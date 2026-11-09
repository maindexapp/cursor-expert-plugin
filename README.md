# Maindex Expert for Cursor

Full-fidelity memory for AI agents who demand precision.

[Website](https://maindex.io) | [Help & FAQ](https://maindex.io/help) | [Dashboard](https://maindex.io/dashboard)

This plugin connects Cursor to **Maindex Expert** — the complete knowledge graph API with 15 tools and 5 MCP resources:

### Memory Management
- `memory_keep` — create a memory
- `memory_update` — revise with full history
- `memory_forget` — soft-delete
- `memory_supersede` — atomic replace with history chain
- `memory_bulk_keep` — batch create (up to 100)
- `memory_bulk_update` — batch tag/status/collection ops

### Retrieval
- `memory_search` — full-text, semantic, and hybrid search
- `memory_list` — structured filter and browse
- `memory_recall` — get by ID

### Graph & Organization
- `memory_associate` — create typed links between memories
- `memory_unassociate` — remove typed links between memories
- `memory_get_related` — discover connections
- `collection_manage` — create, update, and manage collections
- `collection_unlock` — unlock passphrase-protected collections

### System
- `system_report_bug` — report issues to the Maindex team

## Teams

Team workspaces let multiple members share a scoped memory graph. Optional `team` on read tools; team writes via `memory_keep` with **both** `team` and `collection`; `collection_manage` action `create_team_collection`; namespaced IDs like `team-slug:mem-xxxx`. See the [Teams guide](https://maindex.io/help/teams/).

### Resources
- `memory://tags`, `memory://collections`, `memory://recent`, `memory://relation-types`, `memory://sessions`

## Installation

Clone this repo and run:

```bash
./scripts/install-local.sh
```

## Authentication

On first use, you'll be redirected to [maindex.io](https://maindex.io) to sign in and authorize the connection.

## Looking for Simplicity?

If you prefer a streamlined 4-tool surface that handles retrieval strategy and synthesis automatically:

- [cursor-smart-plugin](https://github.com/maindexapp/cursor-smart-plugin) — available in the Cursor Plugin Marketplace

## Learn More

- [maindex.io](https://maindex.io)
- [Help & FAQ](https://maindex.io/help)
