---
description: "Plan and discuss implementation approaches without making changes"
argument-hint: "[task description]"
allowed-tools:
  ["Read", "Glob", "Grep", "LS", "Bash", "WebFetch", "WebSearch", "Task"]
---

You are in PLAN MODE.

## MANDATORY FIRST STEP - Check Project Rules

Before analyzing any task, you MUST:

1. Run `LS ~/.claude/rules` to see available rules
2. Read any rules relevant to: $ARGUMENTS
3. Keep track of which rules you've read this session

Now discuss and plan the approach for: $ARGUMENTS

## MINIMALIST APPROACH - MANDATORY

Every plan MUST prioritize the absolute minimal solution. NO fancy patterns, NO abstractions, NO design patterns unless explicitly requested. Always choose the most direct, simple approach with the least code changes.

CRITICAL RESTRICTIONS:

- ABSOLUTELY NO WRITING, EDITING, OR CREATING ANY FILES
- NO code snippets unless explicitly requested
- NEVER assume the user has approved your plan
- NEVER state "I've approved" or similar language
- NEVER claim or imply the user has approved any plan
- DO NOT make any code changes whatsoever
- DO NOT use Write, Edit, MultiEdit, or NotebookEdit tools
- DO NOT use ExitPlanMode to transition to implementation
- DO NOT execute any implementation steps
- ONLY plan and analyze - no execution
- Reading files and searching the codebase is encouraged for analysis only
- Diagnostic commands are allowed for analysis only
- MINIMIZE code changes - prefer smallest possible modifications
- NO abstractions or patterns unless explicitly required
- NO extra features beyond what was asked
- PREFER existing code over new implementations
- YAGNI principle - You Aren't Gonna Need It

ENFORCEMENT:

- If you attempt to use forbidden tools, STOP immediately
- If you feel compelled to implement, remind yourself: "This is PLANNING ONLY"
- End with: "Planning complete. No implementation performed."

## MINIMALIST VALIDATION CHECKLIST

Every plan must validate against these criteria:

- □ Uses fewest possible files?
- □ Minimal lines of code changed?
- □ No unnecessary abstractions?
- □ Reuses existing patterns?
- □ Does ONLY what was asked?

BLOCKED TOOLS: Write, Edit, MultiEdit, NotebookEdit, TodoWrite, ExitPlanMode

## Rules Integration

For complex tasks, check available project-specific rules:

- List available rules: `LS ~/.claude/rules`
- Read relevant rules based on current task/analysis needs
- Only read rules that haven't been read before in the current session
- Specifically check for any YAGNI, minimalism, or simplicity rules

This is PLANNING ONLY mode. You must:

- Research and analyze the codebase as needed
- Present high-level strategy only
- STOP after planning - do not implement anything

## FOCUS

- List concrete tasks only
- Include file paths and function names
- Specify validation steps
- Choose smallest possible change over elegant solutions
- Avoid creating new files if existing ones can be modified
- No optimization unless specifically requested
- Direct solutions only - no indirection
- Omit explanations unless critical for implementation

DO NOT use TodoWrite in plan mode - planning doesn't require task tracking.

Remember: This command is for PLANNING ONLY. Never write code or make changes.
