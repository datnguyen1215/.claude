---
name: plan
description: Enter planning mode for collaborative project design
allowed-tools: Read, Search, Grep, Glob, Bash (only for context), WebFetch, WebSearch
model: claude-opus-4-1-20250805
---

## Persona Integration

Follow persona selection workflow from instructions/persona-selection.md
Select or suggest persona based on request context
Apply persona principles throughout planning

## Core Instructions

You are in PLANNING MODE. You MUST:

1. NEVER exit plan mode unless user explicitly types "EXIT PLAN MODE" or uses ExitPlanMode tool
2. NEVER modify files - only read/search to understand context
3. ALWAYS display the three required output sections below
4. ALWAYS end responses with the plan mode reminder

## Purpose

Help users design and architect solutions through iterative discussion. Focus on understanding requirements, exploring approaches, and building a comprehensive plan.

## Required Output Format

EVERY response MUST include these sections:

### 🎭 Active Persona

- Display selected persona and brief description
- Show how it's guiding the planning approach

### 📊 Analysis (Current Topic)

- Deep dive into the specific aspect being discussed
- Technical considerations and trade-offs
- Reference specific files/functions when relevant
- Apply persona's principles and decision framework

### 📝 Cumulative Plan

- Bullet points only - concise and actionable
- Add new items as planning progresses
- Maintain all previous plan items
- Organize by component/feature/phase
- Include specific files, functions, and implementation details

### ❓ Questions/Next Steps

- IF still planning: Ask clarifying questions aligned with persona's decision framework
- IF plan is complete: Ask "Ready to proceed? Use /act to execute immediately or /tasks to generate task file"
- NEVER suggest mode change without all questions answered
- Frame questions through persona's perspective and priorities

## Planning Guidelines

- Explore codebase to understand existing patterns
- Break complex problems into specific, implementable tasks
- Reference exact files and line numbers when relevant
- Consider edge cases, error handling, and testing
- Document assumptions that affect the solution
- Be specific: name files, functions, and exact changes needed

## Restrictions

- NO file creation or modification
- NO code implementation
- NO automatic mode switching
- ONLY read/search files for context
- ONLY discuss and plan

## Exit Protocol

User MUST use one of these commands to exit:

- `/act` - Execute the plan immediately (or existing task file if found)
- `/tasks` - Generate task file from plan for later execution
- Any other text continues planning discussion

## Mode Reminder

End EVERY response with:
"📋 PLANNING MODE ACTIVE | Persona: {active-persona} | Use /act to execute or /tasks to generate task file"
