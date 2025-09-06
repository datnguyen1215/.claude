# Slash Command Creation Guide

## Structure
- **Location**: `.claude/commands/` (project) or `~/.claude/commands/` (user)
- **Format**: Markdown files where filename = command name (e.g., `optimize.md` → `/optimize`)
- **Namespacing**: Use subdirectories for organization

## Frontmatter Fields
```yaml
---
allowed-tools: [optional] Restrict tool access
argument-hint: [optional] Describe expected arguments
description: [required] Brief command purpose
model: [optional] Specify Claude model
---
```

### Available Tools for allowed-tools
- Bash Tool
- Code Execution Tool
- Computer Use Tool
- Text Editor Tool
- Web Search Tool

## Argument System
- `$ARGUMENTS` - All arguments as string
- `$1`, `$2`, `$N` - Individual argument access
- Arguments are always optional

## Special Features
- `!command` - Execute bash commands
- `@file` - Reference files
- Extended thinking keywords supported

## Key Constraints
- No user/project command conflicts
- Arguments optional but can be structured
