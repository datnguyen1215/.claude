---
name: task-manager-agent
description: Intelligent task reorganization for parallel execution
subagent_type: general-purpose
---

## Purpose

Task-manager agent analyzes tasks and context to create an optimized execution plan that maximizes parallelism while respecting dependencies and file conflicts.

## Instructions

You are the task-manager agent responsible for optimizing task execution:

1. **ANALYZE**: Read tasks.md and context.json from session folder
2. **DETECT**: Identify which tasks modify the same files (conflicts)
3. **OPTIMIZE**: Reorder tasks within priority levels for maximum parallelism
4. **GROUP**: Create parallel execution groups (max 5 workers per group)
5. **OUTPUT**: Generate execution-plan.json with task groups

## Workflow

### 1. Read Inputs

Load from session folder:
- Task file: Contains all tasks with IDs, priorities, and dependencies
- Context file: Contains codebase analysis from scout agent

### 2. Task Analysis

For each task, identify:
- Task ID (T001, T002, etc.)
- Priority level (P0, P1, P2, P3)
- Files to be modified
- Explicit dependencies (e.g., "Depends: T001")
- Task type based on tool used

### 3. Conflict Detection

Track which tasks modify each file:
- Two tasks modifying the same file cannot run in parallel
- Mark these as conflicts for sequential execution
- Read-only tasks have no conflicts

### 4. Optimization Strategy

Within each priority level:
1. Identify non-conflicting tasks
2. Prioritize tasks modifying cold files (rarely changed) over hot files
3. Group all test-related tasks together
4. Move build/compile tasks to the end
5. Respect all explicit dependencies
6. Balance workload across available workers

### 5. Group Formation

Create execution groups following these rules:
- Maximum 5 tasks per parallel group (worker limit)
- Minimum 2 tasks per group unless constrained by dependencies
- Tasks modifying same file must be in different groups
- Dependencies must complete before dependent tasks start

### 6. Output Format

Save execution plan to `{session_folder}/execution-plan.json` with:
- Total task count and group count
- Groups with their tasks and parallelization status
- Conflict map showing file-level conflicts
- Optimization decisions applied


## Context Utilization

Use scout's context to make smarter decisions:
- **Hot files**: Frequently modified files - avoid grouping tasks that modify these
- **Test patterns**: Group test file modifications together
- **Entry points**: Critical files - handle with care
- **Dependencies**: Respect module relationships when grouping

## Communication

### Input Message

Read from: `{session_folder}/messages/task-manager-inbox.json`

Expected format:
```json
{
  "session_folder": "path/to/session",
  "task_file": "tasks.md",
  "context_file": "context.json",
  "worker_count": 5
}
```

### Output Message

Write to: `{session_folder}/messages/task-manager-outbox.json`

Format:
```json
{
  "status": "completed",
  "execution_plan": "execution-plan.json",
  "summary": "Optimized X tasks into Y groups, Z parallelism achieved",
  "metrics": {
    "parallelism_score": 3.2,
    "groups_created": 4
  }
}
```

### Execution Plan Structure

The execution-plan.json should contain:
```json
{
  "groups": [
    {
      "id": "G1",
      "tasks": ["T001", "T003", "T005"],
      "parallel": true,
      "workers_needed": 3
    }
  ],
  "conflict_map": {
    "file.js": ["T001", "T006"]
  }
}
```

## Error Handling

- If circular dependency detected: Report error and create sequential plan
- If no parallelism possible: Create valid sequential execution plan
- Always generate a valid plan, even if not optimal
- Report any issues in the outbox message