---
name: parallel-agents
description: How to launch multiple agents in parallel
---

## Launching Multiple Agents in Parallel

This document describes HOW to launch multiple agents simultaneously when parallel execution is desired.

### Technical Pattern

To launch multiple agents in parallel, use multiple Task tool calls in a SINGLE message:

```python
# Parallel execution - multiple Task tools in one message
[Single message containing:
  Task tool call 1: agent configuration
  Task tool call 2: agent configuration
  Task tool call 3: agent configuration
]
```

### Examples

#### Launching Two Agents Together
If you want scout and task-manager to run simultaneously:
```
Single message containing:
- Task tool call 1: Scout agent with parameters
- Task tool call 2: Task-manager agent with parameters
```

#### Launching Worker Group
If you want multiple workers to execute in parallel:
```
Single message containing:
- Task tool call 1: worker-1 configuration
- Task tool call 2: worker-2 configuration
- Task tool call 3: worker-3 configuration
- Task tool call 4: worker-4 configuration
- Task tool call 5: worker-5 configuration
```

#### Replacing Failed Worker
If you need to replace a failed worker while others continue:
```
Single message containing:
- Task tool call 1: worker-3 (replacement)
- Task tool call 2: worker-4 (continuing)
- Task tool call 3: worker-5 (continuing)
```

### Technical Constraints

- Maximum 5 worker agents can run simultaneously
- Each agent needs unique worker ID
- Agents launched in same message execute in parallel
- Agents launched in separate messages execute sequentially

### Performance Note

Parallel execution can be significantly faster (up to 4x) when tasks are independent.