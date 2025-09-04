# /plan Command

When this command is used, initiate an interactive planning session with specialized personas.

## ACTIVATION PROTOCOL

```yaml
activation-instructions:
  - Parse command arguments: persona name and optional topic
  - If "list": Execute ls ~/.claude/personas/*.yaml to show available personas
  - If no persona specified: List all .yaml files in ~/.claude/personas/ for selection
  - Load specified persona YAML from ~/.claude/personas/{persona}.yaml
  - Adopt persona characteristics (role, style, expertise, methodology)
  - Enter MANDATORY INTERACTIVE MODE - no skipping allowed
  - Execute persona's planning_methodology steps sequentially
  - HALT after each section for user input (1-9 options)
  - Save progress to .temp/ in current working directory

command-syntax:
  - plan list                       # Show available personas
  - plan architect "topic"          # Start with architect persona
  - plan product-manager "topic"    # Start with PM persona
  - plan ux-designer "topic"        # Start with UX persona
  - plan security-expert "topic"    # Start with security persona
  - plan                           # Interactive persona selection

interaction-mode:
  mandatory: true
  options-format: numbered_1_to_9
  user-input: required_at_each_stage
  skip-allowed: false

  standard-options:
    1: Continue to next step
    2: Revise current section
    3: Add more detail
    4: Ask clarifying questions
    5: Change approach
    6: Save and pause
    7: View progress
    8: Switch persona
    9: Exit planning

persona-structure:
  location: ~/.claude/personas/
  format: yaml
  required-fields:
    - id: unique identifier
    - name: persona name
    - title: professional title
    - role: expertise description
    - communication_style: how they communicate
    - planning_methodology: their planning approach
    - planning_steps: sequential planning stages

execution-flow:
  1_load_persona:
    - Read ~/.claude/personas/{persona}.yaml
    - Adopt role, communication_style, and approach
    - Apply persona's thinking_process and values
    - ENFORCE output restrictions: .temp/ only
    - Greet user in character

  2_start_planning:
    - Use persona's approach and expertise for planning
    - Execute standard planning steps based on persona type:
      - Requirements gathering
      - Solution exploration
      - Design decisions
      - Implementation planning
      - Task generation
    - For each step:
      - Apply persona's thinking_process
      - Generate content using their expertise
      - Show content with persona-specific rationale
      - STOP for user input (1-9 options)
      - Process user choice
      - Save progress to .temp/plans/

  3_save_output:
    - CRITICAL: Only write to .temp/ in current working directory
    - Plan doc: .temp/plans/{timestamp}-{topic}.md
    - Task file: .temp/tasks/{timestamp}-{topic}-tasks.yaml
    - Create directories if they don't exist: mkdir -p .temp/plans .temp/tasks
    - Include: all sections, decisions, rationale
    - Generate structured tasks for ACT mode

error-handling:
  persona_not_found: |
    Execute: ls ~/.claude/personas/*.yaml
    Display available personas from file listing
  missing_directory: |
    Create required directories:
    mkdir -p .temp/plans .temp/tasks .temp/workspace
  invalid_syntax: Show usage examples
```

## AVAILABLE PERSONAS

When activated, I will auto-discover all personas by listing files in ~/.claude/personas/
Each .yaml file represents an available persona that can be loaded for planning sessions.

## EXAMPLE USAGE

```bash
/plan list                          # List all personas
/plan architect "payment system"    # Start architecture planning
/plan product-manager              # Choose PM, then ask for topic
/plan                              # Interactive selection
```

## KEY PRINCIPLES

1. **ALWAYS INTERACTIVE**: Never skip user input at any planning stage
2. **NUMBERED OPTIONS**: Present 1-9 choices at each checkpoint
3. **PERSONA CONSISTENCY**: Stay in character throughout session
4. **PROGRESSIVE SAVING**: Auto-save after each section
5. **FLEXIBLE ITERATION**: Allow revisions and exploration

When activated, I will load the specified persona and guide you through their unique planning methodology with mandatory interaction points at each stage.