# Subagent Creation Guide

## File Structure
Location: `.claude/agents/` (project) or `~/.claude/agents/` (user)

```markdown
---
name: [agent-name]
description: [when to use this agent]
tools: [optional - specific tools or omit to inherit all]
model: [optional - specify Claude model]
---

[System prompt defining role and capabilities]
```

## Best Practices
- Single responsibility per agent
- Specific, detailed prompts
- Limit tools to necessary ones
- Use hyphenated lowercase names
- Version control project agents
