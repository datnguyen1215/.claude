---
name: act
description: Execute a plan from context or a task file
---

## Primary Directive

When this command is invoked, immediately begin executing tasks. Do not ask for confirmation. Do not explain what you will do. Just start working.

## Execution Instructions

### Step 1: Load Core Instructions and Analyze Context

Load core instructions from CLAUDE.md Instructions Index. These are already available in the session context.

#### Context Detection

- Check if a plan exists from previous /plan command with codebase analysis
- If no prior context, perform quick codebase scan:
  - Check package.json for JavaScript/TypeScript projects
  - Check requirements.txt or pyproject.toml for Python projects
  - Scan file extensions in current directory
  - Identify primary technologies and frameworks

#### Dynamic Instruction Loading

Based on detected context and task patterns, apply relevant instructions from CLAUDE.md Instructions Index:

- **Core Instructions**: minimalist-principles, standards-loader (always loaded)
- **Language Standards**: Apply based on detected file types (javascript, python, svelte)
- **Workflow Instructions**: Apply based on task patterns:
  - State management tasks → hierarchical-state-machines
  - UI/interface tasks → ui-ux-guidelines
  - Business logic → business-patterns
- **Documentation Standards**: When creating docs → documentation

All instructions are pre-loaded from CLAUDE.md and applied silently without announcement.

### Step 2: Identify Task Source

Determine where tasks come from:

- **Plan in conversation**: Look for a plan created by /plan command or discussion
- **Task file**: Check if a file path was provided or /tasks was used
- **Direct request**: Extract tasks from the user's current request

### Step 3: Execute Tasks

- Use TodoWrite to create and track all tasks
- Mark each task as in_progress before starting
- Execute using appropriate tools (Read, Write, Edit, Bash, etc.)
- Mark completed immediately after finishing each task
- Continue even if individual tasks fail

### Step 4: Report Completion

After all tasks are attempted, provide a brief summary of what was accomplished.

## Behavioral Rules

- **No planning phase** - Start executing immediately
- **No validation questions** - Make reasonable assumptions
- **No explanatory preambles** - Jump straight into work
- **Track everything** - Use TodoWrite for all task management
- **Complete the mission** - Continue through errors and obstacles

## Error Handling

When encountering errors:

- Log the error briefly
- Mark task as completed (even if failed)
- Move to next task
- Include failures in final summary

## Success Criteria

The command succeeds when:

- All identified tasks have been attempted
- TodoWrite shows clear progress tracking
- A completion summary is provided
- User can see what was done

## Remember

This is an ACTION command, not a planning command. The time for discussion has passed. Execute swiftly and efficiently.
