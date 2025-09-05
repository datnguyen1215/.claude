---
description: Multi-agent collaborative meeting
argument-hint: [meeting topic]
allowed-tools: Read, Write, Task, Glob, TodoWrite
---

# /meeting Command

## Overview
Orchestrates high-level planning meetings through parallel Task spawning with shared meeting context.
Agents provide strategic perspectives and architectural insights, avoiding implementation details unless specifically requested.

## Core Principle
**Every question during the meeting MUST be answered by spawning appropriate agents.**
- Single-topic questions: Spawn the most relevant agent
- Multi-faceted questions: Spawn multiple agents in parallel
- Never answer directly - always use Task tool to delegate to agents

## Workflow

### 1. Meeting Setup
- Parse meeting topic
- Select 2-5 relevant agents based on topic
- Create meeting context file at `./.temp/meetings/current-meeting.md`
- Spawn agents simultaneously using Task tool

### 2. Agent Selection
Automatic selection based on topic keywords:
- **Architecture/Design**: system-architect, developer, security-expert
- **User Experience**: ux-designer, product-manager, qa-engineer
- **Security**: security-expert, system-architect, developer
- **Testing**: testing-guru, qa-engineer, developer
- **Product/Strategy**: product-manager, ux-designer, system-architect
- **Implementation**: developer, system-architect, testing-guru

### 3. Meeting Context File
Location: `./.temp/meetings/YYYY-MM-DD-HH-MM-SS-[topic-slug].md`
Example: `./.temp/meetings/2025-01-05-14-30-00-api-performance.md`

```markdown
# Meeting Context

**Topic:** [meeting topic]
**Date:** [current date and time]
**Facilitator:** User (via Claude Code)
**File:** [this file's path for agents to reference]
**Participating Agents:** [list of agents in this meeting]

## Meeting History
### Initial Context
[What the user originally discussed before calling the meeting]

### Discussion Timeline
1. **User Question/Statement:** [timestamp]
   - [What the user said]

2. **Agent Responses:** [timestamp]
   - **Developer:** [their response]
   - **System Architect:** [their response]
   - **UX Designer:** [their response]

3. **User Follow-up:** [timestamp]
   - [Next question or decision]

## Decisions Made So Far
- Decision 1: [what was decided and by whom]
- Decision 2: [what was decided and by whom]

## Open Questions
- [Current question that needs answering]
- [Any unresolved issues]

## Previous Agent Contributions
### Developer
- Points raised: [key insights from this agent]
- Recommendations: [what they suggested]

### System Architect
- Points raised: [key insights from this agent]
- Recommendations: [what they suggested]

### [Other Agents]
- Points raised: [key insights from this agent]
- Recommendations: [what they suggested]

## Research Chain (If Applicable)
### Investigation Phase
- **Current Phase:** [Phase 1/2/3]
- **Previous Findings:** [What earlier agents discovered]
- **Areas to Investigate:** [Specific aspects based on previous findings]
- **Dependencies:** [What this investigation depends on]

## Current Request for Agents
**IMPORTANT: Read the entire meeting history above before responding**
**Current Question:** [The specific question to answer now]
**Research Mode:** [Standard/Chained]
**If Chained - Your Specific Task:** [Build on previous agent findings for aspect X]
**Your task:** Provide perspective considering what has already been discussed
```

### 4. Agent Tasks
Each agent receives:
```
Read the meeting context at ./.temp/meetings/[timestamp]-[topic].md
IMPORTANT MEETING RULES:
- You are in a meeting - BE CONCISE (2-3 key points maximum)
- DO NOT read project files unless explicitly asked
- NO verbose explanations or long responses
- Provide ONE specific insight from YOUR expertise area only
- Give a DIFFERENT perspective than other agents
- Focus on high-level strategic points, not implementation
- Structure your response as:
  * [Your Role]:
  * Key Point: [ONE main insight]
  * Risk/Consideration: [ONE concern if relevant]
  * Recommendation: [ONE strategic suggestion]
- Keep TOTAL response under 5 lines
- Answer based on expertise, not file exploration
```

### 5. Question Handling Protocol
**For EVERY user question during the meeting:**

#### Mode Selection (Automatic)
The system automatically selects the appropriate mode:

**→ Use CHAINED MODE when detecting:**
- Research/investigation keywords
- Causal analysis needs ("why", "root cause")
- Sequential dependencies in the question
- Debugging or tracing requirements
- Multi-step problem solving

**→ Use STANDARD MODE (default) for:**
- General questions or discussions
- Opinion gathering
- Quick decisions
- Parallel perspectives needed
- No sequential dependencies

#### Standard Parallel Response (Default)
1. Update meeting context file with:
   - New question added to Discussion Timeline
   - Previous agent responses documented
   - Any decisions made
   - Full conversation history maintained
2. Spawn appropriate agent(s) using Task tool IN PARALLEL
3. Agents read FULL updated context including all history
4. Collect and present agent responses
5. Append new responses to context file for next round

#### Chained Research Mode (When Deep Investigation Needed)
**Automatic Triggers (Keywords in user input):**
- "research", "investigate", "deep dive", "analyze thoroughly"
- "find out why", "root cause", "debug", "trace"
- "step by step", "sequential", "first... then..."
- "based on", "depends on", "after finding"
- Questions requiring progressive discovery
- Multi-layered problem solving

**Manual Trigger:** User can specify "use chained mode" or "research this sequentially"
1. **Phase 1 - Initial Investigation**
   - Update context with research question
   - Spawn first agent (e.g., system-architect for architecture analysis)
   - Document findings in context file

2. **Phase 2 - Deep Dive Based on Phase 1**
   - Update context with Phase 1 findings and follow-up questions
   - Spawn next agent(s) to investigate specific areas identified
   - Each agent builds on previous findings

3. **Phase 3 - Synthesis**
   - Update context with all findings
   - Spawn relevant agents to synthesize and provide recommendations
   - Agents see full research chain and provide final insights

**Example Chain:**
- Security-expert identifies vulnerabilities → Developer investigates code → System-architect proposes solutions
- Product-manager defines requirements → UX-designer researches patterns → Developer assesses feasibility

**Context file must maintain complete meeting history for agent awareness**
**Never provide direct answers - always delegate to agents**

### 6. Response Integration
- Collect all agent responses
- Present consolidated perspectives to user
- Update meeting context with insights
- Generate final summary

## Usage Examples

### Standard Mode (Auto-selected)
```
/meeting "API performance optimization"
→ Mode: STANDARD (parallel responses)
→ Spawns simultaneously: system-architect, developer, testing-guru
```

```
/meeting "What's the best approach for checkout flow?"
→ Mode: STANDARD (gathering opinions)
→ Spawns simultaneously: ux-designer, product-manager, developer
```

### Chained Mode (Auto-selected by keywords)
```
/meeting "Research why our API is slow and find root cause"
→ Mode: CHAINED (detected: "research", "why", "root cause")
→ Phase 1: system-architect investigates
→ Phase 2: developer examines findings
→ Phase 3: testing-guru validates
```

```
/meeting "Deep dive into security issues step by step"
→ Mode: CHAINED (detected: "deep dive", "step by step")
→ Sequential investigation with findings building on each other
```

## Implementation Notes
- All agents spawned in single Task tool message for parallelism
- Meeting context file enables agent communication
- Main Claude orchestrates and synthesizes responses
- User maintains full control over discussion flow