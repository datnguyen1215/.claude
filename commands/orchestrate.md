---
name: orchestrate
description: Orchestrate intelligent parallel task execution with dynamic agents
model: claude-opus-4-1-20250805
---

## Purpose

Execute tasks in parallel using multiple specialized agents. Automatically determines which tasks can run simultaneously based on file conflicts and dependencies.

## Session Setup

Uses folder from current context (created by /plan or /tasks command):
- If task file exists: `{task_file_directory}/parallel-session/`
- If from plan without task file: `.tmp/$(date +%Y%m%d-%H%M%S)-orchestrate/parallel-session/`

Session structure:
```
parallel-session/
  messages/         # Agent inbox/outbox JSON files
  locks/           # File-level lock files
  context.json     # Scout's codebase analysis
  execution-plan.json  # Task manager's groupings
```

## Instruction Loading

- `instructions/parallel-agents.md` for concurrent execution patterns

## Workflow

Follow `instructions/parallel-agents.md` for launching multiple agents in parallel.

### 1. Scout Agent
- Analyzes codebase to understand context
- Identifies file relationships and potential conflicts
- Creates context.json for other agents

### 2. Task Manager Agent
- Reads tasks and scout's context
- Groups non-conflicting tasks for parallel execution
- Creates execution plan with up to 5 parallel workers
- Assigns appropriate approach to each worker

### 3. Worker Agents (1-5 parallel)
- Execute assigned tasks simultaneously when no conflicts exist
- Launch multiple workers in single message per `instructions/parallel-agents.md`
- Each worker maintains consistent approach throughout execution
- Use file locks to prevent simultaneous edits to same file

### 4. Code Review Agent
- Reviews all modified files after workers complete
- Identifies issues: critical, major, minor, suggestions
- Generates improvement tasks

### 5. Fix Worker Agents
- Apply all code review suggestions
- Run in parallel when fixing different files
- Ensure code quality improvements are implemented

## Parallelization Rules

Tasks run in parallel when:
- They modify different files
- They have no dependencies on each other
- They belong to the same priority level

Tasks run sequentially when:
- They modify the same file
- They have explicit dependencies (T002 depends on T001)
- File locks prevent parallel access

## Persona Selection

- Workers autonomously select appropriate personas based on task context
- Selection follows `instructions/persona-selection.md` guidelines
- Each worker independently determines the best approach for their assigned tasks
- Workers maintain consistent approach throughout execution

## Output Format

Progress shows parallelization status:
```
⚡ [PARALLEL] T003, T004, T005 running on workers 1-3
🔄 [SEQUENTIAL] T006 waiting (file conflict with T003)
✓ Group completed: 5 tasks in 12s | Parallelism: 4.2x
```

Final summary includes:
```
PARALLELIZATION METRICS
Parallel Tasks: 7 of 9 (78%)
Sequential Tasks: 2 of 9 (due to conflicts)
Parallelism Achieved: 2.8x speedup
Duration: 42 seconds (vs ~118s sequential)
```

## Agent Communication

All agents communicate through JSON messages in session folder.

### Message Formats

**Worker Inbox** (`messages/worker-{id}-inbox.json`):
```json
{
  "worker_id": "worker-1",
  "session_folder": "{path}/parallel-session",
  "tasks": ["T001", "T003", "T005"]
}
```

**Worker Outbox** (`messages/worker-{id}-outbox.json`):
```json
{
  "worker_id": "worker-1",
  "tasks_completed": ["T001", "T003"],
  "tasks_failed": ["T005"],
  "files_modified": ["src/index.js", "src/utils.js"]
}
```

**Context** (`context.json` - from scout):
```json
{
  "hot_files": ["src/index.js"],
  "task_relevant_files": {"src/utils.js": "high"},
  "conflicts": [{"file": "src/index.js", "tasks": ["T001", "T006"]}]
}
```

**Execution Plan** (`execution-plan.json` - from task manager):
```json
{
  "groups": [
    {
      "id": "G1",
      "tasks": ["T001", "T003", "T005"],
      "parallel": true
    }
  ]
}
```

**Lock Files** (`locks/{filename-hash}.lock`):
Contains only the worker ID that holds the lock: `worker-1`
