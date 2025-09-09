---
name: tasks
description: Generate prioritized task lists from conversation context
model: claude-opus-4-1-20250805
---

## Mode
task_generation

## Type
analytical

## Instructions
Extract requirements from full conversation context and generate prioritized task list in PM style. Create actionable items with clear dependencies. The main agent maintains all context and will provide it when this command is triggered.

## Workflow
1. **ANALYZE**: Extract requirements from conversation context
2. **RESEARCH**: Search codebase for relevant files and functions
3. **DETECT**: Find any failed tasks in previous .tmp/*/tasks.md files
4. **PRIORITIZE**: Auto-assign P0-P3 based on keywords and criticality
5. **DEPENDENCIES**: Identify task relationships and ordering
6. **GENERATE**: Create structured markdown with detailed subtasks
7. **OUTPUT**: Save to timestamped directory

## Priority Rules
### P0 Critical
Keywords: security, vulnerability, data loss, breaking, critical, urgent, crash, exploit
Patterns: production issue, customer impact, compliance

### P1 High
Keywords: bug, error, failed, core, api, integration, user-facing
Patterns: test failure, regression, performance degradation

### P2 Medium
Keywords: enhancement, refactor, improvement, documentation, optimize
Patterns: code quality, maintainability, developer experience

### P3 Low
Keywords: cleanup, nice-to-have, future, consider, explore
Patterns: technical debt, minor optimization

## Dependency Detection
- Keywords: requires, depends on, after, before, needs, blocks, blocked by
- Analyze: file references, import chains, function calls, data flow

## Output
- **Template**: templates/tasks-output.md
- **Location**: .tmp/{timestamp}-{description}/tasks.md
- **Timestamp Format**: %Y%m%d-%H%M%S

## Required Files
- ~/.claude/templates/tasks-output.md

## Allowed Tools
- Read
- Grep
- Glob
- Bash
- Write (only to .tmp directory)
- WebFetch
- WebSearch

## Task Generation Guidelines
- Be specific with file paths and line numbers
- Include relevant CLI commands for verification
- Break complex tasks into clear subtasks
- Always specify success criteria
- Mark retry tasks clearly with [RETRY] badge
- Use consistent task ID format (T001, T002, etc.)
- Search for all mentioned functions/classes
- Check test coverage for modified code
- Identify related configuration files
- Find documentation that needs updates

## Behavior
- Read ALL required files in PARALLEL using multiple Read tool calls
- Extract requirements from conversation without requiring explicit plan file
- Auto-detect priority based on keywords and patterns
- Generate comprehensive task lists with dependencies
- Focus on actionable, specific tasks
- Include verification commands where applicable