---
description: "Architect and design solutions using specialized agents"
argument-hint: "[feature or system to architect]"
allowed-tools:
  ["Task", "WebSearch", "WebFetch"]
---

You are in ARCHITECTURE PLANNING MODE.

## Primary Objective
Create comprehensive architectural plans and designs by first understanding the codebase and task, then using the most appropriate specialized agent.

## Workflow

### Phase 1: Codebase & Task Analysis
First, analyze what you're working with:
1. Understand the current task requirements: $ARGUMENTS
2. Examine the codebase structure and existing patterns
3. Identify the type of architectural work needed
4. Determine scope and complexity of the planning required

### Phase 2: Agent Discovery & Selection
Dynamically discover and select the most appropriate agent:

1. **Use the Task tool to discover available agents** - The Task tool will show you what specialized agents are currently available
2. **Analyze agent capabilities** - Review each agent's description to understand their strengths
3. **Match agent to task** - Select the most specialized agent that fits your architectural planning needs

**Selection Guidelines:**
- Always prefer specialized agents over general-purpose agents
- Match the agent's expertise to your specific planning task
- For technical architecture and feature planning, look for engineering-focused agents
- For code quality and refactoring plans, look for review-focused agents
- Only use general-purpose agents as a last resort when no specialized agent fits

### Phase 3: Architecture Planning with Selected Agent
Use the Task tool to invoke your selected specialized agent to:
- Analyze the existing codebase structure
- Design system architecture based on current patterns
- Define component boundaries aligned with existing code
- Specify data flows and interactions
- Identify architectural patterns that fit the codebase
- Create interface specifications

**CRITICAL**: When invoking agents, ALWAYS include in your prompt:
- "First, thoroughly analyze the existing codebase to understand current patterns and structure"
- "DO NOT write, create, or modify any files"
- "This is planning and architecture ONLY"
- "Provide architectural design and specifications only"
- "Base your plan on the existing codebase conventions and patterns"

### Phase 4: Technical Design
Continue using the selected agent to:
- Explore technology choices that align with current stack
- Evaluate trade-offs based on existing architecture
- Design detailed components that integrate with current code
- Define integration strategies
- Assess risks and mitigation

**REMINDER**: Every agent invocation MUST explicitly state:
- "Analyze the codebase first to understand existing patterns"
- "No file creation or modification allowed"
- "Focus on design decisions and architecture only"

### Phase 5: Plan Compilation
Consolidate all agent outputs into a structured architectural plan that includes:
- System overview and objectives
- Component architecture with clear boundaries
- Data architecture and flow
- Interface specifications and contracts
- Implementation roadmap
- Technical decisions and rationale

## Agent Coordination Rules
1. **Dynamic Discovery**: Always use the Task tool to discover what agents are available - never assume which agents exist
2. **Parallel Execution**: Run multiple agents concurrently when appropriate
3. **Iterative Refinement**: Re-invoke agents as new insights emerge
4. **Architecture Focus**: Only use agents for planning and design, not implementation
5. **NO FILE OPERATIONS**: Every agent prompt MUST explicitly forbid file creation/modification

## Critical Restrictions
- NO file creation or modification (you OR agents)
- NO code implementation
- NO direct codebase reading (let agents handle this)
- ONLY architectural and design work
- Focus on creating comprehensive plans
- EVERY agent invocation MUST include explicit "no file writing" instructions

## Output Requirements
Your final output must be a complete architectural plan ready for the `act` command, including:
1. Clear problem statement and solution approach
2. Detailed component architecture
3. Data models and flows
4. API contracts and interfaces
5. Step-by-step implementation roadmap
6. Technology stack recommendations

## Handoff Protocol
The plan should be structured so the `act` command can:
- Understand the complete architecture
- Follow the implementation roadmap
- Make consistent implementation decisions
- Maintain architectural integrity

## Agent Invocation Template
When invoking ANY agent, your prompt MUST include:
```
"IMPORTANT:
1. First, thoroughly analyze the existing codebase to understand:
   - Current project structure and organization
   - Existing patterns, conventions, and architectural decisions
   - Technology stack and dependencies
   - Code style and naming conventions

2. This is a planning/architecture task only. DO NOT write, create, or modify any files.
   DO NOT implement any code. Only provide architectural design, specifications, and planning documentation.

3. Base your architectural plan on the existing codebase patterns and conventions.

4. Focus on: [specific architecture/design task]"
```

Remember: This is PURE ARCHITECTURE AND DESIGN. Let agents do the detailed work while you orchestrate and compile their outputs into a cohesive plan. ALWAYS explicitly tell agents not to write files.
