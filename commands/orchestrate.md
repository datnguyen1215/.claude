---
name: orchestrate
description: Orchestrate intelligent parallel task execution with dynamic agents
model: claude-opus-4-1-20250805
---

## Purpose

Execute tasks from current plan/task file using parallel agents for improved performance. Launches scout for context discovery, task-manager for optimization, and up to 5 worker agents for parallel execution.

## Instructions

You are the parallel command coordinator. Your job is to:

1. **LOCATE**: Find task file from context or use current plan
2. **PREPARE**: Set up session workspace
3. **LAUNCH**: Execute orchestration flow
4. **MONITOR**: Display progress until completion

## Workflow

### 1. Find Tasks

Check in order:

1. Task file from recent `/tasks` command
2. Current plan from `/plan` mode
3. User-specified task file

### 2. Create Session Workspace

```bash
# If task file exists
TASK_DIR=$(dirname $TASK_FILE)
SESSION_DIR="$TASK_DIR/parallel-session"

# If using plan directly
SESSION_DIR=".tmp/$(date +%Y%m%d-%H%M%S)-parallel/parallel-session"
```

Structure:

```
parallel-session/
  messages/       # Agent communication
  locks/          # File-level locks
  context.json    # Shared discovery
  progress.txt    # Real-time status
```

### 3. Orchestration Flow

#### Step 1: Launch Scout Agent

```json
{
  "subagent_type": "general-purpose",
  "prompt": "You are the scout agent. Discover codebase context and save to {session_dir}/context.json. Follow agents/scout-agent.md.",
  "description": "Context discovery"
}
```

#### Step 2: Launch Task-Manager Agent

```json
{
  "subagent_type": "general-purpose",
  "prompt": "You are the task-manager. Read tasks from {task_file} and context from {session_dir}/context.json. Create optimized execution plan. Follow agents/task-manager-agent.md.",
  "description": "Task optimization"
}
```

#### Step 3: Read Execution Plan

- Load `{session_dir}/execution-plan.json`
- Determine worker count from groups
- Prepare task assignments

#### Step 4: Execute Groups

```python
for group in execution_plan.groups:
    workers_needed = min(group.workers_needed, 5)

    # Launch workers for this group
    for i in range(workers_needed):
        launch_worker(f"worker-{i+1}", group.tasks[i])

    # Monitor completion
    while group_not_complete:
        check_worker_outboxes()
        handle_failures()
        update_progress()
```

#### Step 5: Dynamic Worker Management

- Scale workers up/down per group
- Replace failed workers (same ID)
- Skip tasks after 3 failures

### 4. Event-Driven Progress

Display updates only when events occur:

- Task started: "⚡ T003 started by worker-2"
- Task completed: "✓ T003 completed by worker-2"
- Task failed: "✗ T003 failed: file locked"
- Worker replaced: "⚠️ Worker-3 replaced, resuming T005"
- Group completed: "═══ Group G1 completed: 5 tasks in 12s ═══"

Full status refresh every 10 events or 30 seconds:

```
═══════════════════════════════════════════════════════════
ORCHESTRATION STATUS
═══════════════════════════════════════════════════════════
✓ T001: Scout agent created
✓ T002: Worker agent created
⚡ T003: Running on worker-1
⏳ T004: Pending (depends on T003)
⏳ T005: Queued for next group
═══════════════════════════════════════════════════════════
Group G1: 2 completed | 1 running | 0 pending
Workers: 1 active | 4 available
Time elapsed: 00:42
═══════════════════════════════════════════════════════════
```

## Agent Architecture

### Scout Agent

- **Role**: Context discovery
- **Runs**: Once at start
- **Output**: `context.json` with codebase info, hot files, patterns

### Task-Manager Agent

- **Role**: Task optimization and grouping
- **Runs**: Once after scout
- **Input**: `tasks.md` + `context.json`
- **Output**: `execution-plan.json` with parallel groups

### Worker Agents (1-5)

- **Role**: Task execution
- **Runs**: In parallel, scaled per group
- **Communication**: Inbox/outbox messages
- **Locking**: File-level to prevent conflicts

### Orchestrate Command

- **Role**: Direct orchestration (no separate agent)
- **Manages**: All agents lifecycle
- **Monitors**: Real-time progress
- **Handles**: Failures, replacements, and scaling

## Message Protocol

All agents communicate via JSON files:

### Inbox Format

```json
{
  "worker_id": "worker-1",
  "session_folder": "path/to/session",
  "tasks": [...]
}
```

### Outbox Format

```json
{
  "worker_id": "worker-1",
  "tasks_completed": [...],
  "tasks_failed": [...]
}
```

## File Locking

Simple file-level locks prevent conflicts:

- Lock file: `locks/{file-hash}.lock`
- Contains: Worker ID
- Acquired before modification
- Released after completion

## Priority Execution

Tasks executed by priority:

1. **P0**: Critical - blocks all others
2. **P1**: High - after P0
3. **P2**: Medium - after P1
4. **P3**: Nice-to-have - last

## Dependency Handling

### Explicit

From task file: "Depends: T001"

- Wait for T001 completion
- Then assign task

### Implicit

Detected from file operations:

- T001 creates file.js
- T002 modifies file.js
- T002 waits for T001

## Error Handling

### Worker Failures

- Timeout: 30 seconds per task
- Automatic worker replacement:
  1. Detect worker timeout/crash
  2. Release worker's file locks: `rm {session}/locks/*worker-{id}*`
  3. Move tasks back to queue
  4. Launch replacement: Same worker ID (worker-3 → worker-3)
  5. Assign queued tasks to replacement
  6. Update user: "⚠️ Worker-{id} replaced"
- Skip task after 3 failures across different workers

### File Lock Conflicts

- Task deferred if file locked
- Retried when lock released
- Reported if persistent

### Critical Failures

Execution stops if:

- No workers available
- All P0 tasks fail
- Session folder inaccessible

## Performance

### Targets

- Context discovery: <30 seconds
- Task assignment: <1 second
- Worker response: <30 seconds
- Progress updates: Every 1 second

### Expected Speedup

- 2-3x for independent tasks
- 1.5-2x for dependent tasks
- Minimal for sequential tasks

## Arguments

- **None**: Use recent task file or current plan
- **Path**: Execute specific task file
- **--workers N**: Limit workers (default: 5)

## Examples

### Basic Usage

```bash
/parallel
# Uses task file from recent /tasks command
```

### Specific File

```bash
/parallel .tmp/20241209-tasks/tasks.md
```

### Limited Workers

```bash
/parallel --workers 3
# Use only 3 parallel workers
```

## Output

Final execution summary:

```
══════════════════════════════════════════════════════════
EXECUTION SUMMARY
══════════════════════════════════════════════════════════
Completed: 8 of 9 tasks
Failed: 1 task (T007: timeout)
Duration: 42 seconds
Workers used: 5
Parallelism achieved: 2.8x speedup
══════════════════════════════════════════════════════════
```

## Tools Required

- Task: Launch agents
- Read: Monitor progress
- Bash: Check session setup

## Restrictions

- Maximum 5 worker agents
- Session isolation per execution
- No state persistence between runs
- File-level locking only
