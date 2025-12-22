# Local Dev Setup

Personal configuration for local development environments - skills, global instructions, and permission settings for Claude Code CLI.

## What's Included

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions applied to all projects |
| `skills/` | Personal skills (workflows, expertise patterns) |
| `settings.local.json` | Permission rules for tool approval |

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

### TarkaFlow Build Pipeline

Skills execute in this order for implementation work:

| # | Skill | Agent | Purpose |
|---|-------|-------|---------|
| 1 | `picking-up-work` | code | Select CR, verify readiness, gather context |
| 2 | `test-readiness` | tester | Write tests for ACs (TDD Red phase) |
| 3 | `implementation` | code | Make tests pass (TDD Green/Refactor) |
| 4 | `local-test` | tester | Switch to local mode, run system tests locally |
| 5 | `remote-test` | tester | Commit, push, monitor deployment, smoke test remote |
| 6 | `completing-work` | code | Create imp/ldm/interface artifacts, transition to implemented |
| 7 | `validation` | tester | Verify ACs met, transition to validated |
| 8 | `preparing-release` | release_manager | Bundle validated work items for deployment |

### Supporting Skills

| Skill | Purpose |
|-------|---------|
| `review-work-item` | Review and impact assess TarkaFlow Work Items (CR, BUG, DEBT) |
| `deployment-sme` | Battle-tested patterns for GitHub Actions, Docker, SSH deployments |
| `bootstrap-vps` | VPS bootstrap and hardening workflow |
| `tarkaflow-developer-context` | Core TarkaFlow context (loaded at session start) |

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
