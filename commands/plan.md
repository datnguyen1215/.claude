# /plan Command

**🚨 ELICITATION MODE ONLY - NEVER MODIFY CODE 🚨**

## CRITICAL ENFORCEMENT RULES
**STOP IMMEDIATELY if you're about to:**
- Use Edit, MultiEdit, or Write tools (except .temp/)
- Implement ANY solution
- Write ANY code
- Modify ANY files

**RESPONSE PATTERN:**
After proposing a solution, you MUST:
1. STOP and wait for user feedback
2. NOT proceed to implementation
3. Ask: "Would you like me to document this plan in .temp/plans/?"

When this command is used, enter a structured elicitation conversation to understand user needs, explore edge cases, and document a comprehensive plan and task list for later implementation. A persona must be selected to begin the planning process.

## ACTIVATION PROTOCOL

```yaml
mode: elicitation-only

# Tool permissions
allowed_tools:
  Read:
    restrictions:
      - Must read whole files, no partial reads
      - No offset/limit parameters
  Grep:
    restrictions: []
  Glob:
    restrictions: []
  Bash:
    restrictions:
      - Read-only operations
      - No file modifications
      - No package installations
  Write:
    allowed_paths:
      - .temp/plans/*.md
      - .temp/tasks/*.yaml
    forbidden_paths:
      - All other paths

forbidden_tools:
  - Edit     # NEVER use
  - Update   # NEVER use
  - MultiEdit # NEVER use
  - Task     # Not in elicitation mode
  - ExitPlanMode # Not applicable

# File permissions
allowed_outputs:
  - .temp/plans/*.md
  - .temp/tasks/*.md

# Activation sequence
activation:
  - Require: Check for persona (MANDATORY FIRST STEP)
    - If no persona → List all available personas from ~/.claude/personas/*.yaml
    - Block: Cannot proceed without selection
    - Prompt: "Select a persona to continue (required)"
  - Select: User chooses or provides persona name
  - Validate: Ensure persona exists in ~/.claude/personas/
  - Load: Selected persona from ~/.claude/personas/{persona}.yaml
  - Mode: Enter ELICITATION conversation with loaded persona
  - Save: Only to .temp/ with user permission

# Conversation flow
flow:
  understand:
    type: READ_ONLY
    actions:
      - Read existing code
      - Ask clarifying questions
      - Understand constraints

  explore:
    type: CONVERSATION_ONLY
    actions:
      - Summarize understanding
      - Identify edge cases
      - Discuss priorities
    forbidden:
      - Implementation
      - Code modification

  propose:
    type: CONVERSATION_ONLY
    actions:
      - Present solution approach
      - STOP AND WAIT for feedback
      - DO NOT IMPLEMENT
    response_template: |
      "Here's my proposed approach: [solution]

      Would you like me to:
      1. Document this plan in .temp/plans/?
      2. Explore alternative approaches?
      3. Exit plan mode for implementation?"

  document:
    type: PERMISSION_REQUIRED
    trigger: User approval
    output: .temp/plans/[timestamp]-plan.md
    content:
      - Problem description
      - Solution approach
      - Files to be modified (list only)
      - Changes needed (description only)

  create_tasks:
    type: PERMISSION_REQUIRED
    trigger: User approval
    output: .temp/tasks/[timestamp]-tasks.yaml
    content:
      - Task specifications
      - Implementation order
      - File modification list

# Rules enforcement
rules:
  persona_requirement: mandatory  # MUST select persona before proceeding
  mode_type: elicitation_only
  interaction: conversation_required
  user_wait: mandatory_after_each_output
  implementation: forbidden
  code_modification: forbidden
  file_creation: only_in_temp_directory
  permission: required_before_file_write

```

## PERSONA REQUIREMENT

**⚠️ MANDATORY: A persona MUST be selected before planning can begin**

- No default or fallback behavior without persona
- System will prompt for persona selection if not provided
- Available personas are loaded from ~/.claude/personas/*.yaml
- Each persona provides specialized expertise for planning

## USAGE

```bash
/plan                    # Lists personas, prompts for selection (REQUIRED)
/plan architect         # Use architect persona directly
/plan list              # Show available personas only
/plan architect "topic" # Use architect persona for specific topic
```

