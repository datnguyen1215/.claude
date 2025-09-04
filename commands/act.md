# /act Command

When this command is used, execute tasks created by PLAN mode using specialized personas.

## ACTIVATION PROTOCOL

```yaml
activation-instructions:
  - Parse command arguments: persona name and optional task file
  - If "list": Execute ls .temp/tasks/*.yaml to show available tasks
  - If no task specified: List all task files for selection
  - Load specified persona from ~/.claude/personas/{persona}.yaml
  - Adopt identity for ACT mode execution
  - Load task file from .temp/tasks/ in current working directory
  - Execute tasks systematically
  - NO restrictions on output locations (can write anywhere needed)

command-syntax:
  - act list                           # Show available tasks
  - act architect {task-file}          # Execute with architect persona
  - act product-manager {task-file}    # Execute with PM persona
  - act {persona}                      # Select persona, then choose task
  - act                               # Interactive selection

execution-mode:
  type: task-based
  input: .temp/tasks/*.yaml
  output: project-specific or .temp/workspace/
  restrictions: none  # Can write to any location needed for implementation

  workflow:
    1: Load task file
    2: Validate requirements
    3: Execute implementation
    4: Create deliverables
    5: Update task status

task-structure:
  location: .temp/tasks/
  format: yaml
  expected-fields:
    - task_id: unique identifier
    - persona: recommended persona
    - description: what to implement
    - requirements: detailed specifications
    - deliverables: expected outputs
    - dependencies: related tasks
    - priority: execution order

execution-flow:
  1_load_configuration:
    - Read ~/.claude/personas/{persona}.yaml
    - Adopt role, communication_style, and approach
    - Apply persona's expertise and thinking_process
    - Set working_directory to .temp/workspace/ or project root
    - Greet user as implementer

  2_load_task:
    - List available tasks in .temp/tasks/
    - Load selected task file
    - Parse requirements and deliverables
    - Identify dependencies
    - Confirm understanding with user

  3_execute_task:
    - Apply persona's expertise to task execution
    - Use persona's thinking_process for implementation
    - Create actual implementations based on task requirements
    - Generate code/configs/documents using persona's approach
    - Save to appropriate locations (no restrictions)

  4_deliverables:
    - NO RESTRICTIONS on output locations
    - Can write to:
      - Current project directory
      - .temp/workspace/
      - Any path specified in task
      - System locations as needed

  5_completion:
    - Update task status in task file
    - Report deliverables created
    - List files modified/created
    - Suggest next tasks if dependencies exist

error-handling:
  persona_not_found: |
    Execute: ls ~/.claude/personas/*.yaml
    Display available personas from file listing
  task_not_found: |
    Execute: ls .temp/tasks/*.yaml
    Display available tasks from file listing
  missing_directory: |
    Create required directories:
    mkdir -p .temp/tasks .temp/workspace
```

## AVAILABLE TASKS

When activated, I will auto-discover all tasks by listing files in .temp/tasks/
Each .yaml file represents a task that can be executed.

## EXAMPLE USAGE

```bash
/act list                              # List all available tasks
/act architect "api-design-tasks"      # Execute API design tasks
/act product-manager                   # Choose PM, then select task
/act                                   # Full interactive selection
```

## KEY PRINCIPLES

1. **TASK-DRIVEN**: Execute based on task specifications from PLAN mode
2. **NO WRITE RESTRICTIONS**: Can create files anywhere needed
3. **SYSTEMATIC EXECUTION**: Follow persona's execution flow
4. **DELIVERABLE FOCUSED**: Create actual implementations
5. **STATUS TRACKING**: Update task completion status

## COMMUNICATION PROTOCOL

Tasks created by PLAN mode should include:
```yaml
task_id: "2024-01-15-payment-api-task-001"
persona: "architect"
created_by: "plan_session_2024-01-15"
description: "Design and implement payment API"
requirements:
  - RESTful API design
  - Authentication layer
  - Rate limiting
deliverables:
  - api_specification.yaml
  - authentication_config.json
  - implementation_plan.md
priority: high
status: pending
```

When activated, I will load the task, adopt the specified persona, and execute the implementation to create real deliverables.