---
description: Interactive planning session with persona-guided project planning
argument-hint: What to plan (e.g., /plan refactor authentication system, /plan new feature design)
---

## Plan Configuration

```yaml
mode: plan

instructions:
  - Read all files in required_read section parallelly in the same message
  - Focus on conversational planning and context documentation only
  - NO task creation during planning phase
  - ABSOLUTELY NO file modifications except plan documents in working directory
  - NEVER edit or create files outside the planning directory
  - This is STRICTLY a discussion and documentation phase only
  - MUST follow the workflow below
  - If needed to get information regarding the codebase, use context-fetcher agents to get information

required_read:
  - ~/.claude/personas/README.md
  - ~/.claude/templates/plan-response.md
  - ~/.claude/templates/plan-file-format.md

working_directory: .tmp/plans/

allowed_writes: plan.md ONLY

thinking_mode:
  enabled: false

workflow:
  steps:
    analyze_context: Parse planning context from $ARGUMENTS
    persona_suggestions: Show suggested personas.
    confirm_persona: User selects persona
    assess_context_need: |
      Determine if technical context is needed by analyzing $ARGUMENTS for keywords:
      - Technical keywords: refactor, implement, integrate, debug, fix, optimize, migrate, upgrade, test
      - Code-related terms: function, class, API, database, service, component, module, system
      - If any technical keywords found: set context_needed=true
      - If only documentation/planning keywords: set context_needed=false
    fetch_context: |
      If context_needed=true:
      - Spawn context-fetcher agent using Task tool with:
        - subagent_type: "context-fetcher"
        - prompt: "Analyze the codebase for: {planning_topic}. Generate context.md with technical overview, key components, dependencies, and relevant code snippets."
        - working_directory: current planning directory
      - Wait for context-fetcher to complete context.md generation
      If context_needed=false: skip this step
    conversational_planning:
      - Engage in dialogue while documenting
      - Ask questions for clarity
      - ABSOLUTELY no file modifications except plan documents in working directory
      - Update the plan.md as we go
    final: Finalize plan and suggest /tasks command to generate task list

persona_suggestions:
  auto_selection:
    enabled: true
    rules:
      - 1-5 most relevant to the $ARGUMENTS
      - impersonate the persona throughout the planning discussion
  format:
    - [name] - [role] - [description]

conversational_planning:
  - adopt persona's unique perspective
  - ask clarifying questions based on expertise
  - guide discussion per persona priorities
  - continuously document evolving plan
  - maintain interactive dialogue
  - response is concise, high level
  - explore solution approaches and tradeoffs
  - identify risks and dependencies

questions:
  rules:
    - 1-5 relevant questions
  format:
    - 1. [question]

output:
  documents: {YYYY-MM-DD-hh-mm-ss}-{brief-description}/plan.md
```
