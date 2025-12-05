# MCP Server Setup for Claude Code

This devcontainer is configured to support MCP (Model Context Protocol) servers, which extend Claude Code's capabilities with external tools and services.

## Playwright MCP Server

### What is Playwright MCP?

The Playwright MCP server enables Claude Code to:

- Automate web browsers (Chromium, Firefox, WebKit)
- Perform web scraping and testing
- Interact with web pages in real-time
- Analyze accessibility snapshots
- Execute automated testing workflows

### Prerequisites

The devcontainer includes all necessary system dependencies:

- ✅ Playwright browser libraries (libnss3, libatk, etc.)
- ✅ Firewall configured to allow HTTP/HTTPS traffic
- ✅ Claude Code CLI installed globally

### Installation

1. **Start the devcontainer** (if not already running):

   ```bash
   devcontainer up --workspace-folder .
   ```

2. **Run the setup script** inside the container:

   ```bash
   .devcontainer/setup-playwright-mcp.sh
   ```

   This will install the Microsoft Playwright MCP server using:

   ```bash
   claude mcp add playwright -s user -- npx @playwright/mcp@latest
   ```

   **Alternatively**, the MCP server is pre-configured in `.mcp.json` at the project root:

   ```json
   {
     "mcpServers": {
       "playwright": {
         "command": "npx",
         "args": ["@playwright/mcp@latest"]
       }
     }
   }
   ```

3. **Verify installation**:

   ```bash
   claude mcp list
   ```

   Expected output should include:

   ```
   playwright
   ```

### Usage Examples

Start a Claude Code session:

```bash
claude
```

Then use Playwright commands:

**Example 1: UI Verification (Headless Mode - Recommended)**

```
Use Playwright in headless mode to navigate to localhost:3000 and take a screenshot at 600x800
```

**Example 2: Open a visible browser**

```
Use Playwright to open a browser to https://example.com
```

**Example 3: Navigate and interact**

```
Navigate to https://github.com and search for "claude-code"
```

**Example 4: Web scraping**

```
Use Playwright to visit https://news.ycombinator.com and extract the top 5 story titles
```

**Example 5: Automated testing**

```
Use Playwright to:
1. Navigate to https://example.com/login
2. Fill in username "test@example.com"
3. Fill in password "password123"
4. Click the login button
5. Verify we're redirected to /dashboard
```

### Playwright Configuration

The repository includes a `playwright.config.ts` with optimized settings for Claude Code:

**Viewport Size**: 600x800 pixels

- Small enough to save space in repositories
- Large enough to verify UI components clearly
- Ideal for screenshots in PRs and documentation

**Headless Mode**: Enabled by default

- Faster execution for automated testing
- No visual browser window needed
- Perfect for CI/CD and verification workflows
- Use `--headed` flag to see the browser during development

**Screenshot Storage**: `./screenshots/` directory

- Screenshots are committed to the repository
- Provides visual documentation in PRs
- Small viewport size keeps repo size manageable

**Best Practices**:

- **Always use headless mode** for UI verification before task completion
- Keep screenshots at 600x800 to save space
- Store verification screenshots in `screenshots/` directory
- Include screenshots in pull requests for review

### Network Considerations

**Firewall Configuration**:

- The devcontainer firewall allows HTTP (port 80) and HTTPS (port 443) for browser automation
- Other protocols (FTP, SMTP, custom ports) remain blocked for security
- This is required for Playwright to access websites

**Security Notes**:

- HTTP/HTTPS access is broad to support browser testing
- This is intentional for the Playwright use case
- Non-web protocols remain restricted by the firewall

### Troubleshooting

**Issue: `claude: command not found`**

- Ensure you're inside the devcontainer
- Verify Claude Code CLI is installed: `which claude`
- Rebuild the container if needed: `npm run devcontainer:rebuild && npm run devcontainer:up`

**Issue: Firewall blocks browser access**

- Check firewall rules: `sudo iptables -L -n`
- Verify HTTP/HTTPS rules are present
- Re-run firewall setup: `sudo /usr/local/bin/init-firewall.sh`

**Issue: Browser dependencies missing**

- Rebuild the Docker image to install Playwright system dependencies
- Check Dockerfile includes the Playwright dependencies section

**Issue: MCP server not found**

- Re-run the setup script: `.devcontainer/setup-playwright-mcp.sh`
- Check MCP configuration: `cat ~/.claude/mcp_settings.json`

### Alternative MCP Servers

You can install additional MCP servers using:

```bash
claude mcp add <server-name> -s user -- <command>
```

Popular MCP servers:

- **Filesystem**: `claude mcp add filesystem -s user -- npx -y @modelcontextprotocol/server-filesystem`
- **Git**: `claude mcp add git -s user -- npx -y @modelcontextprotocol/server-git`
- **PostgreSQL**: `claude mcp add postgres -s user -- npx -y @modelcontextprotocol/server-postgres`

**Note**: Some MCP servers may require additional firewall rules or system dependencies.

### References

- [Microsoft Playwright MCP on GitHub](https://github.com/microsoft/playwright-mcp)
- [Playwright MCP on npm](https://www.npmjs.com/package/@playwright/mcp)
- [Claude Code MCP Guide](https://til.simonwillison.net/claude-code/playwright-mcp-claude-code)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/mcp)
