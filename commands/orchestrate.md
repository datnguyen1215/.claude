---
description: Execute task groups in parallel
---

## Orchestrate Configuration

```yaml
mode: parallel_execute
context_aware: true

instructions:
  - Find plan with task groups (## headers)
  - Spawn one agent per group in parallel
  - Each agent receives full tasks.md for context
  - Agents focus only on their assigned group
  - Update tasks.md directly
  - MUST follow the workflow below

required_read:
  - tasks.md
  - context.md # if exists

thinking_mode:
  enabled: false

workflow:
  steps:
    - parse_groups: Identify task groups by ## headers
    - display_groups: Show groups to user before execution
    - spawn_agents: Launch parallel Task tools (one per group)
    - monitor: Wait for all agents to complete
    - summarize: Report group completions


group_parsing:
  pattern: "## Group: [name]"
  extract: Group name and tasks until next group or EOF
  validate: Ensure groups are independent

execution_rules:
  parallel_orchestration:
    - ONE agent per group
    - ALL agents spawn in single message
    - AGENTS work independently
    - EACH agent updates only their group's tasks
    - NO coordination between agents

  agent_instructions: |
    You have access to the full tasks.md for context.
    IMPORTANT: Focus ONLY on your assigned group: {group_name}

    1. Read the entire tasks.md to understand context
    2. If context.md exists in the plan directory, read it for technical insights
    3. Work ONLY on tasks in your assigned group
    4. Execute tasks sequentially within your group
    5. Update checkbox to [x] after each successful task by editing the tasks.md file
    6. Stop if a task fails
    7. Report completion status

    Your group's tasks:
    {group_tasks}

    Note: Wave 1 is complete, so the Context-Fetcher Agent Setup and Command Configuration Updates are done. The configurations have been updated with the necessary flags and steps.


output:
  summary_sections:
    - groups_completed: Which groups finished successfully
    - groups_failed: Which groups encountered errors
    - total_tasks: Tasks completed across all groups
    - next_steps: Suggest retry for failed groups

completion:
  - show parallel execution summary
  - indicate which groups need attention
```