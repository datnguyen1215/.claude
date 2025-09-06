---
description: Solution planning through agent investigation with shared research context
argument-hint: [topic/problem to solve]
allowed-tools: Read, Write, Task, Glob, TodoWrite
---

# /plan Command

## Overview
Interactive solution planning through agent-based investigation and research.
Agents share findings through a context file to avoid duplicate research.
Primarily uses one agent throughout conversation, chaining others only when needed.

## Core Principle
**Natural conversation-driven planning with minimal structure.**
- Agents engage in human-like dialogue
- Ask clarifying questions naturally
- Provide concise, high-level answers unless details requested
- Build understanding through conversation
- Save key insights to context file for reuse

## Workflow

### 1. Agent Auto-Discovery
- Use Glob to find all agents in `~/.claude/agents/*.md`
- Read first 5 lines of each agent file
- Extract name and capabilities from frontmatter
- Match agent expertise to user's topic
- Automatically select most relevant agent
- **Create shared context file for agents to collaborate**

### 2. Natural Conversation Flow
- **Agent reads existing context file first**
- Agent greets user casually
- Asks clarifying questions to understand the problem
- **Writes findings to shared context during conversation**
- Provides minimal, high-level responses
- Goes deeper only when user asks for details
- Maintains conversational tone throughout
- **Updates context file with discoveries for other agents**

### 3. Planning Context File (Shared Note)
Location: `./.temp/planning/YYYY-MM-DD-HH-MM-SS-[topic-slug].md`

**Purpose:** Central knowledge base where ALL agents read and write findings

```markdown
# Planning Context - Shared Research Note

**Topic:** [user's question in their own words]
**Active Agent:** [current agent name]
**File:** [this file's path]

## Key Insights (ALL AGENTS WRITE HERE)
<!-- Each agent adds their findings as bullet points -->
- [Developer]: Found the bottleneck in database queries
- [Architect]: Suggests caching layer for frequently accessed data
- [QA]: Performance tests show 3s response time on complex queries

## Agent Findings

### Developer Agent
- Identified N+1 query problem in UserService
- Current implementation makes 50+ DB calls per request
- Proposed solution: batch loading with DataLoader pattern

### System Architect
- Microservices architecture causing cascading delays
- Service mesh adds 200ms overhead per hop
- Recommend implementing circuit breakers

### QA Engineer
- Load tests show degradation at 100 concurrent users
- Memory usage spikes during peak hours
- Test coverage for performance: 15%

## Conversation History

### User
[Original question]

### [Agent Name]
[Natural response - conversational, not structured]

### User
[Follow-up]

### [Agent Name]
[Continuing the conversation naturally]

<!-- Natural flow, no timestamps or formality -->

## Action Items for Next Agent
- [ ] Investigate Redis caching implementation
- [ ] Review database index optimization
- [ ] Check if connection pooling is configured
```

### 4. Agent Instructions

```
CRITICAL: Read AND write to the shared context file

1. BEFORE STARTING:
   - Read the context at ./.temp/planning/[topic].md
   - IMPORTANT: Always read ENTIRE files - NO partial reads with offset/limit
   - Review what other agents have discovered
   - Build on their findings, don't repeat research

2. FILE READING REQUIREMENTS:
   - MUST read complete files - never use offset or limit parameters
   - Read the full context file every time to see all updates
   - When examining code files, read them completely
   - This ensures you have full context and don't miss critical information

3. DURING CONVERSATION:
   - Write your key findings to the context file
   - Update the "Key Insights" section with discoveries
   - Add your responses to the "Conversation" section
   - Note important details for other agents

4. ENGAGEMENT STYLE:
   - Talk like a human expert, not a robot
   - Keep responses SHORT and high-level
   - Ask questions to understand better
   - Only provide details when asked
   - Reference other agents' findings when relevant

5. WRITING TO CONTEXT:
   - Use Write/Edit tools to update the context file
   - Add findings under your agent name
   - Keep notes concise but useful
   - Include code snippets if relevant

Example conversation style:
"Hey, looking at your API performance issue. The architect agent noted it's a microservices setup - what kind of response times are you seeing?"

NOT:
"I will now investigate your API performance issue by examining the following components..."
```

### 5. Conversation Examples

#### Good (Natural):
```
User: "Why is my app crashing on startup?"
Agent: "Hmm, startup crashes are usually config or dependency issues. When did this start happening?"
User: "After updating packages yesterday"
Agent: "Let me check your package changes... Ah, found it. The new version of X breaks Y. Want the quick fix or the proper solution?"
```

#### Bad (Too Formal):
```
User: "Why is my app crashing on startup?"
Agent: "I will investigate your application crash issue. Let me examine:
1. Configuration files
2. Dependencies
3. Error logs
4. Recent changes
[Long detailed analysis]"
```

### 6. Real Usage Examples

#### Debugging with Shared Context:
```
User: /plan "Memory leak in production"
[Creates context file: ./.temp/planning/2024-01-15-10-30-00-memory-leak.md]

Debugger: [Reads context, finds it empty, starts fresh]
"Production memory leaks are fun. How long does it take to manifest?"
[Writes to context: "Memory leak manifests in production environment"]

User: "About 2-3 hours"
Debugger: "Classic slow leak. Is it gradual or sudden jumps?"
[Updates context: "Slow leak pattern - takes 2-3 hours to manifest"]

User: "Gradual"
Debugger: "Probably a cache or event listener. Let me peek at your code..."
[Writes finding: "Gradual memory increase - likely cache or listener issue"]
[Quick investigation]
Debugger: "Found it - you're not clearing timers in componentWillUnmount. Want the one-liner fix?"
[Final update: "Root cause: Timers not cleared in componentWillUnmount"]

[Later, QA agent joins]
QA: [Reads context, sees timer issue already found]
"I see the debugger found the timer leak. Let me write a test to catch this in CI..."
[Adds to context: "Test case needed for timer cleanup verification"]
```

#### Planning with Multiple Agents:
```
User: /plan "Need to add OAuth"
[Creates context: ./.temp/planning/2024-01-15-11-00-00-oauth.md]

Developer: [Reads empty context]
"OAuth2 or OAuth1? And who's the provider?"
[Writes: "User needs OAuth implementation"]

User: "OAuth2 with Google"
Developer: "Easy enough. You want the quick passport.js route or custom implementation?"
[Updates: "OAuth2 with Google provider - considering passport.js vs custom"]

User: "What about security?"
[Security agent automatically engaged]

Security: [Reads context, sees OAuth2 with Google]
"Since the dev mentioned passport.js - that's solid for Google OAuth2. Main concerns:
- Store tokens encrypted
- Use state parameter for CSRF
- Implement PKCE if it's a public client"
[Adds security requirements to context]

Developer: [Sees security notes in context]
"Good points from security. Passport handles state parameter. PKCE depends on your app type. Mobile or SPA?"
```

### 7. Key Behaviors
- **Be Human**: Natural language, not corporate speak
- **Be Brief**: Default to short answers
- **Be Curious**: Ask clarifying questions
- **Be Helpful**: Offer options, not lectures
- **Be Smart**: Use context to avoid redundant work

## Quick Start

```
/plan "API is slow"
→ Auto-discovers agents
→ Selects best match (probably debugger)
→ Starts natural conversation
→ "Slow API, huh? How slow are we talking?"
```

```
/plan "Need auth system"
→ Finds system-architect or developer
→ "Auth system - basic or enterprise grade?"
→ Conversation continues based on needs
```

## Implementation Notes
- Auto-discover agents from `~/.claude/agents/*.md`
- Select based on task match
- Keep conversation natural and minimal
- Save only key findings to context
- Expand detail only when requested
- Focus on understanding through dialogue

