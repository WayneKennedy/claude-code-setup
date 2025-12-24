# Local Dev Setup

Personal configuration for local development environments - global instructions, permission settings, and utility scripts for Claude Code CLI.

## What's Included

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions applied to all projects |
| `skills/bootstrap-vps/` | VPS bootstrap and hardening workflow |
| `settings.local.json` | Permission rules for tool approval |
| `bin/` | Utility scripts (tmux session launchers, shortcuts) |

## What's NOT Included

- `~/.claude.json` - MCP server configs with API keys (configure per-machine via `claude mcp add`)
- `~/.claude/settings.json` - Machine-specific settings like `alwaysThinkingEnabled`
- `.credentials.json` - Auth tokens (machine-specific)
- History, todos, debug logs - Ephemeral data

## Installation

Clone and run the install script:

```bash
git clone git@github.com:WayneKennedy/local-dev-setup.git
cd local-dev-setup
./install.sh
```

This creates symlinks from `~/.claude/` to this repo, so:
- Changes are tracked in git
- Updates are visible across machines after `git pull`
- You'll notice if Claude modifies config without asking

## Skills

This repo contains the `bootstrap-vps` skill for VPS provisioning and hardening.

**Note:** TarkaFlow development pipeline skills (picking-up-work, implementation, validation, etc.) are managed in the [tarka-n8n-agents](../tarka-n8n-agents) repository.

## MCP Server Setup

MCP servers provide Claude Code with access to Originate's internal tools. These contain API keys and must be configured per-machine.

### Required Servers

| Server | URL | Purpose |
|--------|-----|---------|
| `aos` | https://aos.originate.group/mcp | Agency OS - audits, tasks, growth plans, alerts |
| `tflo` | https://tarkaflow.ai/mcp | TarkaFlow - requirements, work items, releases |
| `infra` | https://infra.originate.group/mcp | Infrastructure - environments, clusters, deployments |

### Configuration

Add the following to your Claude config file (create if it doesn't exist):

| Platform | Config File Location |
|----------|---------------------|
| macOS | `/Users/<username>/.claude.json` |
| Linux | `/home/<username>/.claude.json` |

Both use `~/.claude.json` in shell commands.

```json
{
  "mcpServers": {
    "aos": {
      "type": "http",
      "url": "https://aos.originate.group/mcp",
      "headers": {
        "X-API-Key": "YOUR_PAT_HERE"
      }
    },
    "tflo": {
      "type": "http",
      "url": "https://tarkaflow.ai/mcp",
      "headers": {
        "X-API-Key": "YOUR_PAT_HERE"
      }
    },
    "infra": {
      "type": "http",
      "url": "https://infra.originate.group/mcp",
      "headers": {
        "X-API-Key": "YOUR_PAT_HERE"
      }
    }
  }
}
```

### Getting Your PAT

1. Request a Personal Access Token from the platform admin
2. The same PAT works for all three Originate services
3. Replace `YOUR_PAT_HERE` with your actual token

### Alternative: CLI Setup

You can also configure servers via the Claude CLI:

```bash
claude mcp add aos --type http --url https://aos.originate.group/mcp --header "X-API-Key: YOUR_PAT"
claude mcp add tflo --type http --url https://tarkaflow.ai/mcp --header "X-API-Key: YOUR_PAT"
claude mcp add infra --type http --url https://infra.originate.group/mcp --header "X-API-Key: YOUR_PAT"
```

### Verifying Setup

After configuration, restart Claude Code and run `/mcp` to verify all servers are connected. You should see tools prefixed with `mcp__aos__`, `mcp__tflo__`, and `mcp__infra__`.

## License

Apache 2.0 - See [LICENSE](LICENSE)
