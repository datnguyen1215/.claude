---
name: act
description: Execute tasks sequentially from a markdown file with AI-friendly syntax
---

## MANDATORY FIRST STEP - Persona Selection

BEFORE executing any tasks, you MUST:

1. **IMMEDIATELY read** `instructions/persona-selection.md` to understand available personas
2. **Select the appropriate persona** based on the task context (likely senior-engineer for implementation)
3. **Load the selected persona file** from the path specified in persona-selection.md
4. **Apply persona principles** throughout the entire execution

This is NOT optional - persona selection MUST happen first before any task execution.

## Instructions

Execute tasks from a markdown file using explicit tool syntax, or execute plan directly if no task file was created. Uses the task file path from conversation context (created by /tasks command), otherwise executes the plan directly. Each task specifies a tool and its parameters in a deterministic format. Execute sequentially, mark completed (for files), report summary.

## Persona Selection Process

### Step 1: Read Persona Instructions
ALWAYS start by reading `instructions/persona-selection.md` to:
- Understand available personas and their specializations
- Learn the selection process and loading requirements
- Identify which persona best matches the task (usually senior-engineer for /act)

### Step 2: Load Selected Persona
Once selected, immediately:
- Read the persona file from its specified path
- Load any referenced files within the persona
- Announce which persona is active
- Apply its principles to all task execution

## Workflow

1. **PERSONA**: Select and load appropriate persona FIRST
2. **CHECK**: Look for task file mentioned in conversation context
3. **FALLBACK**: If no task file mentioned, execute plan directly from context
4. **PARSE**: Extract tool and parameters from each task
5. **EXECUTE**: Run each task in order with active persona style
6. **MARK**: Update [ ] to [x] when complete (for task files)
7. **REPORT**: Show completion summary

## Task Format

Each task must follow this structure:

```markdown
### T{number}: Optional description

[ ] [ToolName] parameters
```

## Tool Syntax

### Simple Tools (single parameter)

**Read a file:**

```markdown
### T001

[ ] [Read] /path/to/file.js
```

**Run a command:**

```markdown
### T002

[ ] [Bash] npm test
```

**Search for files:**

```markdown
### T003

[ ] [Glob] \*_/_.test.js
```

**Search in files:**

```markdown
### T004

[ ] [Grep] "TODO" src/
```

### Edit Tool (structured blocks)

```markdown
### T005

[ ] [Edit] /path/to/file.js
OLD: exact text to find
NEW: exact replacement text
```

### MultiEdit Tool (multiple edits)

```markdown
### T006

[ ] [MultiEdit] /path/to/file.js
EDIT_1_OLD: first text to find
EDIT_1_NEW: first replacement
EDIT_2_OLD: second text to find
EDIT_2_NEW: second replacement
```

### Write Tool (content block)

```markdown
### T007

[ ] [Write] /path/to/newfile.js
CONTENT:
const config = {
debug: true
};
export default config;
END_CONTENT
```

## Parsing Rules

1. Task starts with `### T` followed by digits
2. Next line must have `[ ]` checkbox and `[ToolName]`
3. Tool name must match exactly: Read, Write, Edit, MultiEdit, Bash, Glob, Grep
4. Parameters follow tool-specific format:
   - Simple tools: rest of line after tool name
   - Edit: OLD: and NEW: on separate lines
   - MultiEdit: EDIT_N_OLD: and EDIT_N_NEW: pairs
   - Write: CONTENT: block ending with END_CONTENT

## Execution Rules

- Execute tasks in order (T001, T002, T003...)
- Continue on failure (don't stop if a task fails)
- Mark [x] only when task completes successfully
- No retries, no validation, no dependencies
- Skip tasks already marked [x]

## Persona Application

After reading persona-selection.md and loading the selected persona:
- Follow the persona's Core Principles for all implementation decisions
- Use the persona's Decision Framework when making choices
- Avoid the persona's listed Anti-Patterns
- Apply the persona's Communication Style
- Document which persona principles guide significant decisions

## Arguments

- No arguments: Use task file from context (if /tasks was run), otherwise execute plan directly
- File path: Execute tasks from specified file
- Single task: `T003` - Execute only that task from found file
- No ranges, no lists, no complex patterns

## Example Task File

```markdown
# Tasks

### T001: Setup project

[ ] [Bash] npm install

### T002: Read configuration

[ ] [Read] package.json

### T003: Update version

[ ] [Edit] package.json
OLD: "version": "1.0.0"
NEW: "version": "1.0.1"

### T004: Create changelog

[ ] [Write] CHANGELOG.md
CONTENT:

# Changelog

## Version 1.0.1

- Updated version number
  END_CONTENT

### T005: Run tests

[ ] [Bash] npm test

### T006: Build project

[ ] [Bash] npm run build
```

## Error Handling

- Log errors but continue execution
- Don't mark failed tasks as complete
- Include failures in final report
- No complex recovery or retry logic

## Report Format

```
Execution Summary
Completed: X of Y tasks
```

## Restrictions

- Only modify checkboxes in task file
- No file creation except through Write tool
- No interpretation of task descriptions
- Tool names must be exact matches
- Parameters must follow specified format
