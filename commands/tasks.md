---
name: tasks
description: Generate prioritized, actionable tasks from plans with dependency tracking
---

# Tasks Command Configuration

```yaml
configuration:
  mode: task_generation
  type: analytical
  output_dir: .tmp/{same-folder-as-plan-context}/tasks.md

instructions:
  primary: |
    Generate comprehensive task lists from current conversation and codebase analysis.
    Create detailed, actionable items for coding agents with clear dependencies.
    Track and highlight previously failed tasks from earlier runs.

    IMPORTANT: Always read ALL files in required_files section IN PARALLEL using multiple Read tool calls in a single message.

  required_files:
    - ~/.claude/templates/tasks-output.md

  workflow:
    - ANALYZE: Extract requirements from conversation context
    - RESEARCH: Search codebase for relevant files/functions
    - DETECT: Find failed tasks in previous .tmp/*/tasks.md files
    - PRIORITIZE: Auto-assign P0-P3 based on keywords/patterns
    - DEPENDENCIES: Identify task relationships and ordering
    - GENERATE: Create structured markdown with detailed subtasks
    - OUTPUT: Save to timestamped directory

  priority_rules:
    P0_critical:
      keywords:
        [
          security,
          vulnerability,
          data loss,
          breaking,
          critical,
          urgent,
          crash,
          exploit,
        ]
      patterns: [production issue, customer impact, compliance]
    P1_high:
      keywords: [bug, error, failed, core, api, integration, user-facing]
      patterns: [test failure, regression, performance degradation]
    P2_medium:
      keywords: [enhancement, refactor, improvement, documentation, optimize]
      patterns: [code quality, maintainability, developer experience]
    P3_low:
      keywords: [cleanup, nice-to-have, future, consider, explore]
      patterns: [technical debt, minor optimization]

  dependency_detection:
    keywords: [requires, depends on, after, before, needs, blocks, blocked by]
    analyze: [file references, import chains, function calls, data flow]

permissions:
  allowed_tools:
    - Read
    - Grep
    - Glob
    - Bash
    - Write (only to .tmp directory)
    - WebFetch
    - WebSearch

output_format:
  template: ~/.claude/templates/tasks-output.md
  description: Use the template file for the complete output structure

behavior:
  task_generation:
    - Be specific with file paths and line numbers
    - Include relevant CLI commands for verification
    - Break complex tasks into clear subtasks
    - Always specify success criteria
    - Mark retry tasks clearly with [RETRY] badge
    - Use consistent task ID format (T001, T002, etc.)

  research_depth:
    - Search for all mentioned functions/classes
    - Check test coverage for modified code
    - Identify related configuration files
    - Find documentation that needs updates
```
