---
description: Multi-agent collaborative meeting
argument-hint: [meeting topic]
allowed-tools: Read, Write, Task, Glob, TodoWrite
---

# /meeting Command

## Overview
Orchestrates collaborative meetings through dynamic agent discovery and Task spawning.
Agents provide strategic perspectives based on meeting context.

## Core Principle
**Every question MUST be answered by spawning appropriate agents.**
- Never answer directly - always delegate to agents via Task tool
- Agents are discovered dynamically based on context

## Workflow

### 1. Meeting Setup
- Parse meeting topic
- Dynamically discover relevant agents by analyzing:
  * Topic keywords and context
  * Available agent types from Task tool documentation
  * Match expertise areas to discussion needs
- Create meeting context file at `./.temp/meetings/YYYY-MM-DD-HH-MM-SS-[topic].md`
- Spawn 2-5 most relevant agents simultaneously

### 2. Agent Discovery (Automatic)
Instead of predefined mappings, analyze the topic to select agents:
- Extract key concepts from the meeting topic
- Match concepts to agent expertise descriptions
- Select agents whose capabilities best address the topic
- Ensure diversity of perspectives when multiple agents needed

### 3. Meeting Context File
Location: `./.temp/meetings/YYYY-MM-DD-HH-MM-SS-[topic-slug].md`

```markdown
# Meeting: [topic]
**Date:** [timestamp]
**Agents:** [dynamically discovered list]

## Transcript
[timestamp] User: [input]
[timestamp] [Agent]: [response]
[timestamp] Claude: [synthesis]

## Current Question
**Question:** [what needs answering]
**Mode:** [Standard/Chained]
```

### 4. Agent Tasks
Each agent receives:
```
Read the meeting context at ./.temp/meetings/[timestamp]-[topic].md
CRITICAL FILE READING REQUIREMENT:
- ALWAYS read ENTIRE files - NO partial reads with offset/limit
- When reading meeting context, read the complete file
- If examining any code or documents, read them fully
- Never use offset or limit parameters in Read tool

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

### 5. Operating Modes

#### Standard Mode (Default)
- Parallel agent responses for diverse perspectives
- All agents spawned simultaneously. Use multiple Task calls in a message.
- Used for: discussions, opinions, brainstorming

#### Chained Mode (Auto-detected)
Triggers on keywords: "research", "why", "root cause", "debug", "investigate", "step by step"
- Sequential agent investigation
- Each phase builds on previous findings
- Agents selected dynamically per phase based on emerging needs

### 6. Response Integration
- Collect all agent responses
- Present consolidated perspectives to user
- Update meeting context with insights
- Generate final summary

## Usage Examples

```
/meeting "API performance optimization"
→ Dynamically discovers: agents with performance/architecture expertise
→ Mode: STANDARD (parallel responses)
```

```
/meeting "Research why our API is slow"
→ Dynamically discovers: agents for investigation
→ Mode: CHAINED (detected "research", "why")
→ Sequential phases with agent selection per phase
```

## Implementation Notes
- Agents discovered dynamically from Task tool's available types
- Context file enables agent awareness of discussion history
- No hardcoded agent mappings - fully dynamic selection
- User maintains control over discussion flow
