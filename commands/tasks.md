---
name: tasks
description: Generate detailed task lists from conversation context
model: claude-opus-4-1-20250805
---

## Instructions

Generate minimal, actionable engineering tasks with detailed implementation instructions. Follow minimalist principles - only essential tasks, but with comprehensive details for execution. Every task must be directly implementable with clear subtasks.

## Workflow

1. **READ CONTEXT**: Analyze conversation for implementation requirements
2. **EXTRACT ACTIONABLE TASKS**: Identify concrete implementation tasks only
3. **CREATE CHECKLIST**: Format as simple markdown checkboxes
4. **WRITE FILE**: Save to .tmp/%Y%m%d-%H%M%S-{description}/tasks.md

## Output Requirements

Write a markdown file using this format:

```markdown
## Tasks

### [ ] Main Task Description

Detailed explanation of what needs to be done and why.

**Implementation:**

- [ ] Subtask 1: Specific action with file path
- [ ] Subtask 2: Exact modification details
- [ ] Subtask 3: Precise implementation step

### [ ] Another Main Task

Clear description with context and requirements.

**Implementation:**

- [ ] Subtask 1: Create/modify specific file
- [ ] Subtask 2: Add specific functionality
- [ ] Subtask 3: Update configuration
```

Rules:

- Main tasks use `### [ ]` format with detailed description
- Subtasks use `- [ ]` format with specific actions
- Each task includes **Implementation:** section
- Specify exact file paths and modifications
- NO investigation, research, or exploration tasks
- Each subtask must be directly executable
- Follow minimalist principles - only essential tasks
- Provide comprehensive details for implementation

## Focus

- Apply minimalist principles - only essential tasks
- Provide detailed implementation instructions
- Use hierarchical structure: main tasks with subtasks
- Specify exact files, functions, and modifications
- Convert abstract requirements into concrete actions
- Each subtask must be independently executable
