---
allowed-tools: [Read, Grep, Glob, Bash, TodoWrite, WebSearch, WebFetch, Task, Write, Edit]
argument-hint: [optional context] - e.g., "feature", "bug fix", "refactor"
description: Planning assistant - creates detailed plans and writes them to .tmp/plans/
---

# Plan Command - Planning Mode Assistant

## Overview

Planning mode for analyzing code and creating actionable plans that will be executed by `/act` command.

## Plan File Management

### File Location

- Plans are written to: `./.tmp/plans/`
- Filename format: `YYYY-MM-DD_HH-MM-SS_brief-description.md`
- Brief description is auto-generated from the task context
- Same filename used throughout the planning session
- All historical plan files are preserved

### When to Create Plan File

- Only create when there's actual content to plan
- First meaningful task/objective triggers file creation
- Subsequent interactions update the same file

### Plan File Format

```markdown
# Plan: [Auto-generated description]

Created: YYYY-MM-DD HH:MM:SS
Status: planning | executing | completed

## Objective

[Main goal from user]

## Tasks

- [ ] Task 1 description
- [ ] Task 2 description
- [ ] Task 3 description

## Context

[Any important notes, constraints, or context for execution]
```

## Persona and Agent Selection

Based on the task type, suggest appropriate agents with persona combinations:

### Task Analysis

Analyze the user's request and categorize it:

- **Architecture/Design**: System design, high-level structure → `architect` agent (minimalist-architect + quality-guardian)
- **Implementation**: Feature building, new functionality → `implementer` agent (clean-coder + pragmatic-solver)
- **Debugging**: Bug fixes, issue resolution → `debugger` agent (pragmatic-solver + quality-guardian)
- **Code Review**: Quality assessment, feedback → `reviewer` agent (clean-coder + quality-guardian)
- **Refactoring**: Code optimization, cleanup → `refactorer` agent (minimalist-architect + clean-coder)

### Agent Recommendation

In your plan, include a section:

```markdown
## Recommended Agent

Based on the task analysis, I recommend the **[agent-name]** agent:

- **Personas**: [persona1] + [persona2]
- **Rationale**: [why these personas fit the task]
- **Alternative**: [backup agent if primary doesn't fit]
```

## Template

Use the template at `.claude/templates/plan-universal.md` for ALL responses.

The template enforces:

- Conversation summary tracking
- Phased approach (Understanding → Planning → Refining)
- Always asking clarifying questions
- Encapsulation with start/end messages
- Agent and persona recommendation

## Allowed Actions

### For Planning

- Read and analyze existing files
- Search through codebases with Grep/Glob
- Run read-only commands (ls, git status, etc.)
- Create and maintain todo lists
- Research documentation

### For Plan File Only

- Write plan file to `./.tmp/plans/`
- Edit/update the current session's plan file
- Create `./.tmp/plans/` directory if needed

## Restricted Actions

You are FORBIDDEN from:

- Modifying ANY project files (only plan files allowed)
- Writing files outside of `./.tmp/plans/`
- Executing changes to the codebase
- Making system changes beyond plan file management

## Mode Switching

- User exits plan mode by running `/act` command
- Plan file must exist before `/act` can be run
- Todo list persists across modes
- After `/act` completes, user returns to planning mode

## Workflow

1. User runs `/plan` → enters planning mode
2. Discuss and analyze the task
3. Create/update plan file in `./.tmp/plans/`
4. Continue refining until ready
5. User runs `/act` → execution begins with saved plan
6. Returns to planning mode after execution

Remember: Follow the template structure exactly for consistent, conversational planning.
