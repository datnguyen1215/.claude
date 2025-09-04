# /plan Command

**🚨 ELICITATION MODE ONLY - NEVER MODIFY CODE 🚨**

## CRITICAL ENFORCEMENT RULES
**STOP IMMEDIATELY if you're about to:**
- Use Edit, MultiEdit, or Write tools (except .temp/)
- Implement ANY solution
- Write ANY code
- Modify ANY files

Enter natural conversation with selected persona to understand needs and create plan. No code modifications allowed.

## ACTIVATION PROTOCOL

```yaml
mode: elicitation-only

# Tool permissions
allowed_tools: [Read, Grep, Glob, Bash (read-only)]
forbidden_tools: [Edit, MultiEdit, Task]
write_only_to: .temp/plans/*.md

# Activation sequence
activation:
  - Require: Check for persona (MANDATORY FIRST STEP)
    - If no persona → Run: ls -la ~/.claude/personas/ 2>/dev/null
    - Block: Cannot proceed without selection
    - Prompt: "Select a persona to continue (required)"
  - Select: User chooses or provides persona name
  - Validate: Ensure persona exists in ~/.claude/personas/
  - Load: Selected persona from ~/.claude/personas/{persona}.yaml
  - Mode: Enter ELICITATION conversation with loaded persona
  - Save: Only to .temp/ with user permission

# Conversation flow
conversation:
  mode: natural_dialogue

  start:
    persona_intro: |
      Load persona personality and expertise
      Greet naturally based on persona style
      Brief overview of persona's capabilities
      Start conversation about the problem
    example: |
      "Hi, I'm Morgan, the Minimalist Developer. I specialize in simple,
      elegant solutions with minimal code changes. Let's talk about what
      you need and find the simplest way to get there. What's going on?"

  understand:
    type: CONVERSATIONAL
    approach: Natural back-and-forth dialogue
    actions:
      - Read files as needed during conversation
      - React to user's actual words
      - Build understanding together
    forbidden:
      - Scripted questions
      - Numbered lists
      - Implementation

  explore:
    type: CONVERSATIONAL
    natural_flow:
      - Respond based on what user shares
      - Ask follow-ups that make sense in context
      - Share persona's expertise naturally
    example: |
      "That's interesting... have you noticed if this happens consistently?"
      "Let me check something..." [reads file]
      "Ah, I see what might be happening here..."

  propose:
    type: CONVERSATIONAL
    approach: Suggest solution naturally
    actions:
      - Present ideas conversationally
      - Get user feedback
      - Refine based on discussion
    closing: |
      "Here's what I think we should do... [solution]
      Does that sound good? Should I document this plan?"

  document:
    type: PERMISSION_REQUIRED
    trigger: User approval
    output: .temp/plans/[timestamp]-plan.md
    content:
      - Problem description
      - Solution approach
      - Files to be modified (list only)
      - Changes needed (description only)


# Core rules
enforcement:
  persona: required
  mode: conversation_only
  code_changes: forbidden

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

