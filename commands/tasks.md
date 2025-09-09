---
name: tasks
description: Generate prioritized task lists from conversation context
model: claude-opus-4-1-20250805
---

## Instructions

Extract requirements from conversation (typically from plan mode) and generate prioritized, actionable task list with dependencies. This command exits plan mode after generating the task file.

## Workflow

1. **ANALYZE**: Extract requirements and search codebase for context
2. **PRIORITIZE**: Assign P0-P3 based on impact keywords
3. **STRUCTURE**: Create tasks with dependencies and success criteria
4. **OUTPUT**: Save to .tmp/%Y%m%d-%H%M%S-{description}/tasks.md
5. **EXIT**: Automatically exit plan mode (if active)

## Priority Matrix

| Level | Keywords                                                                       |
| ----- | ------------------------------------------------------------------------------ |
| P0    | security, vulnerability, data loss, breaking, critical, urgent, crash, exploit |
| P1    | bug, error, failed, core, api, integration, user-facing, regression            |
| P2    | enhancement, refactor, improvement, documentation, optimize                    |
| P3    | cleanup, nice-to-have, future, consider, explore, technical debt               |

## Output Format

```
# Tasks: {description}
Generated: {timestamp}

## P0 Critical
### T001: {task_name}
**Files**: {path/file.ts:123}
**Depends**: {T### or none}
**Success**: {measurable_outcome}
- [ ] {action_step}
- [ ] {verify_step}

## P1 High
### T002: {task_name}
{same_structure}

## Dependencies
T001 → T002
T003 blocks T004
```

## Guidelines

- Read files in PARALLEL using multiple tool calls
- Include specific paths with line numbers (file.ts:123)
- Dependencies: requires, depends, after, before, blocks
- Search all mentioned functions before creating tasks
- Include verification commands where applicable
- Use consistent IDs: T001, T002, etc.

## Tools

Read, Grep, Glob, Bash, Write (.tmp only), WebFetch, WebSearch
