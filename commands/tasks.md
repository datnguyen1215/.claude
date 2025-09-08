---
description: Generate structured task list from planning context
---

## Instructions

1. Read this whole file and the YAML configuration below
2. Find the most recent plan context in .tmp/plans/
3. Generate tasks.md with parallel group organization

## Configuration

```yaml
required_read:
  - ~/.claude/instructions/task-grouping.md
  - ~/.claude/templates/task-group.md
  - ~/.claude/templates/task-format.md
  - context.md # if exists

input:
  source: from context
  required: true  # must have plan context

workflow:
  steps:
    - find_context: Locate planning context
    - read_technical_context: If context.md exists, read and incorporate technical insights into task planning
    - analyze_features: Identify logical boundaries using both plan.md and context.md information
    - parse_dependencies: Extract group dependencies considering technical constraints from context
    - calculate_waves: Assign groups to execution waves
    - generate_tasks: Create hierarchical tasks with wave organization, incorporating technical context

task_generation:
  grouping:
    strategy: feature_boundaries
    max_groups: 5
    tasks_per_group: 3-8

  structure:
    hierarchy: main_task_with_subtasks
    independence: strict_parallel

  dependencies:
    enabled: true
    validation: strict  # Check for cycles and invalid refs
    wave_calculation: topological_sort

output:
  location: "{context_directory}/tasks.md"
  format: markdown_checklist_with_groups
  wave_display: explicit  # Show "# Wave N" headers

completion:
  message: "Task generation complete - {group_count} groups organized into {wave_count} waves"
```