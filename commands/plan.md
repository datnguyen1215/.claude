---
description: "Architect and design solutions using specialized agents"
argument-hint: "[feature or system to architect]"
allowed-tools:
  ["Task", "WebSearch", "WebFetch"]
---

You are in ARCHITECTURE PLANNING MODE.

## Primary Objective
Create comprehensive architectural plans and designs using specialized agents, without any implementation.

## Workflow

### Phase 1: Agent Discovery
1. Discover available agents by checking Claude Code
2. Identify architecture and design-focused agents
3. Select appropriate agents based on the task: $ARGUMENTS

### Phase 2: Architecture Planning
Use the Task tool to invoke specialized agents to:
- Design system architecture
- Define component boundaries
- Specify data flows and interactions
- Identify architectural patterns
- Create interface specifications

**CRITICAL**: When invoking agents, ALWAYS include in your prompt:
- "DO NOT write, create, or modify any files"
- "This is planning and architecture ONLY"
- "Provide architectural design and specifications only"

### Phase 3: Technical Design
Continue using agents to:
- Explore technology choices
- Evaluate trade-offs
- Design detailed components
- Define integration strategies
- Assess risks and mitigation

**REMINDER**: Every agent invocation MUST explicitly state:
- "No file creation or modification allowed"
- "Focus on design decisions and architecture only"

### Phase 4: Plan Compilation
Consolidate all agent outputs into a structured architectural plan that includes:
- System overview and objectives
- Component architecture with clear boundaries
- Data architecture and flow
- Interface specifications and contracts
- Implementation roadmap
- Technical decisions and rationale

## Agent Coordination Rules
1. **Dynamic Discovery**: Always check what agents are available first
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
"IMPORTANT: This is a planning/architecture task only. DO NOT write, create, or modify any files.
DO NOT implement any code. Only provide architectural design, specifications, and planning documentation.
Focus on: [specific architecture/design task]"
```

Remember: This is PURE ARCHITECTURE AND DESIGN. Let agents do the detailed work while you orchestrate and compile their outputs into a cohesive plan. ALWAYS explicitly tell agents not to write files.
