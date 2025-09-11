---
name: act
description: Execute tasks sequentially from a markdown file with AI-friendly syntax
---

## Persona Execution

Apply persona style from instructions/persona-selection.md
Extract from context and use for execution approach
Follow persona's preferred patterns and avoid anti-patterns

## Persona Auto-Selection

Before task execution begins, analyze task content to automatically select the most appropriate persona:

**Pattern Matching Rules:**
- `(debug|troubleshoot|investigate)` → sherlock
- `\.(test|spec)\.(js|ts)` → sherlock
- `(ui|ux|style|css|design)` → minimalist-ui-ux-designer
- `(refactor|architecture|system)` → system-design
- `(business|analyze|market)` → business-analyst
- `(document|docs|readme)` → ai-documentation-writer

**Dynamic Persona Generation:**
```yaml
dynamic_persona_generation:
  when: "no_existing_persona_matches"

  steps:
    - analyze_task:
        instruction: "Extract primary domain from task content"
        output: "domain_name"

    - generate_persona:
        name_format: "{domain} Minimalist"
        description_format: |
          Generate 4-5 sentences:
          1. Expert in {domain} applying minimalist principles
          2. Mention relevant standards only if task requires them
          3. Describe minimalist methodology specific to this task
          4. State what is prioritized over what
          5. Core belief about simplicity in this context

    - generate_principles:
        count: 3-5
        priority: "descending"
        specificity: "task-specific"
        instruction: |
          Generate principles for THIS SPECIFIC TASK:
          1. Most critical practice for task success (simplified)
          2. Technology/tool choice for this task
          3. What to avoid/not implement
          4. Testing/validation approach
          5. Maintenance consideration
```

**Selection Function:**
1. Analyze task descriptions and file paths for pattern matches
2. If match found, select highest priority match (debug/troubleshoot takes precedence)
3. If no match found, generate task-specific persona using YAML structure above
4. Apply selected or generated persona style directly to execution approach
5. Use persona's principles, patterns, and anti-patterns throughout execution

## Instructions

Execute tasks from a markdown file using explicit tool syntax, or execute plan directly if no task file was created. Uses the task file path from conversation context (created by /tasks command), otherwise executes the plan directly. Each task specifies a tool and its parameters in a deterministic format. Execute sequentially, mark completed (for files), report summary.

## Workflow

1. **SELECT**: Auto-select persona based on task content analysis
2. **CHECK**: Look for task file mentioned in conversation context
3. **FALLBACK**: If no task file mentioned, execute plan directly from context
4. **PARSE**: Extract tool and parameters from each task
5. **EXECUTE**: Run each task in order with selected persona style
6. **MARK**: Update [ ] to [x] when complete (for task files)
7. **REPORT**: Show completion summary with active persona

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

## Persona Execution Styles

Based on active persona from the CLAUDE.md context, apply appropriate styles:

- Read persona name and description from context
- Extract key principles and approaches from description
- Apply persona's focus areas to execution approach
- For custom personas: Apply described principles from persona context

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
Executed with persona: {active-persona}
```

## Restrictions

- Only modify checkboxes in task file
- No file creation except through Write tool
- No interpretation of task descriptions
- Tool names must be exact matches
- Parameters must follow specified format
