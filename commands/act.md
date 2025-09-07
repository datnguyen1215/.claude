---
allowed-tools: [Task, Read, Glob, Bash]
argument-hint: [optional] - specific task to focus on
description: Execute the plan created by /plan command using a specialized agent
---

# Act Command - Execution Mode

## Overview

Executes the plan created by `/plan` command by spawning a specialized agent that:

- Reads the latest plan file from `./.tmp/plans/`
- Modifies project files according to the plan
- Updates task completion status in the plan file
- Returns a summary of completed work

## Prerequisites

- Must have an existing plan file in `./.tmp/plans/`
- Plan should have uncompleted tasks
- Will error if no plan file exists

## Execution Flow

1. **Find Latest Plan**:

   - Search `./.tmp/plans/` for the most recent plan file
   - Error if no plan exists

2. **Select and Spawn Agent**:

   - Check plan file for recommended agent
   - If no agent specified, use general-purpose approach
   - If agent specified, load from `.claude/agents/[agent-name].md`
   - Agent reads the plan file and follows persona guidelines
   - Agent has full file modification capabilities

3. **Agent Responsibilities**:

   - Execute each uncompleted task from the plan
   - Update task checkboxes in plan file as completed (`- [x]`)
   - Modify project files as needed
   - Update plan status: `planning` → `executing` → `completed`
   - Handle errors gracefully and mark failed tasks if needed

4. **Return Summary**:
   - Show what tasks were completed
   - List files that were modified
   - Report any issues encountered

## Agent Selection and Integration

### Agent Loading Process

1. **Check Plan File**: Look for "Recommended Agent" section
2. **Load Agent Definition**: Read from `.claude/agents/[agent-name].md`
3. **Persona Integration**: Agent automatically reads referenced personas
4. **Transparency**: Agent states active personas at start of execution

### Agent Prompt Template

The agent should be given clear instructions:

- Read plan from specified file path
- Load and follow specified agent persona guidelines
- Execute only uncompleted tasks while maintaining persona principles
- Update plan file with progress
- Provide detailed summary of actions taken
- State active personas for transparency

## Error Handling

- No plan file: "No plan found. Please run /plan first to create a plan."
- All tasks completed: "All tasks in the plan are already completed."
- Agent failure: Report the error and suggest running /plan to revise

## Post-Execution

After the agent completes:

- Display summary of completed work
- Suggest returning to /plan mode for next steps
- Plan file remains for historical reference

## Important Notes

- Agent has full modification capabilities
- Plan file serves as single source of truth
- Todo list persists across mode switches
- Always returns to planning mode after completion
