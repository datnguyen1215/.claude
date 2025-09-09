# Persona Selection Instructions

## Overview

This document defines the standard workflow for persona selection and application across all commands that support personas.

## Available Personas

Dynamically loaded from `personas/index.md`. The system will:

1. Read the index file at runtime
2. Parse each persona entry (format: `## {name}` followed by description)
3. Extract name and description for matching
4. Present available options to users

## Parsing personas/index.md

The index file follows this format:

```
## {persona-name}
{description}
Path: personas/{persona-name}.md
```

Extract available personas by:

1. Read `personas/index.md`
2. Find all lines starting with `## ` (persona names)
3. Capture the description on the next line
4. Build list of available personas with names and descriptions

## Selection Workflow

### 1. Check Existing Context

Look for persona in conversation context using format:

```html
<!-- Active Persona: {name or description} -->
```

### 2. Analyze Request

If no existing persona, analyze user's request for keywords to suggest appropriate persona.

### 3. Description-Based Matching

The system matches user requests against persona descriptions from `personas/index.md`:

- Analyze keywords in the user's request
- Compare against terms in each persona's description
- Score matches based on relevance
- Auto-select if single strong match
- Present options if multiple matches

### 4. Selection Logic

```
IF persona already in context:
  USE existing persona
ELSE IF single keyword match:
  AUTO-SELECT matched persona with notification:
  "Auto-selected {persona} based on your request. Say 'change persona' to switch."
ELSE IF multiple matches:
  PRESENT options:
  "Multiple personas could help with this task:
  1. {persona1} - {description}
  2. {persona2} - {description}

  Which would you prefer? (or describe a custom persona)"
ELSE IF no matches:
  ASK for selection:
  "Choose a persona to guide this session:
  {dynamically list personas from index.md with descriptions}

  Or describe a custom persona in 1-2 sentences."
```

### 5. Custom Personas

Users can specify custom personas with brief descriptions:

```html
<!-- Active Persona: Custom - A DevOps engineer focused on automation and CI/CD pipelines -->
```

### 6. Persona Switching

Users can change personas mid-conversation:

- "change persona" or "switch persona" triggers new selection
- "use {persona-name} persona" directly switches
- Previous persona context is replaced

## Context Format

### Standard Format

```html
<!-- Active Persona: {name} -->
```

### Custom Format

```html
<!-- Active Persona: Custom - {description} -->
```

### Placement

- Always at the beginning of command output
- Before any other content
- Preserved across command transitions

## Application Guidelines

### For Planning Commands (plan.md)

- **Questions**: Align with persona's decision framework
- **Analysis**: Apply persona's principles to evaluation
- **Structure**: Organize plan according to persona's approach
- **Language**: Use persona's terminology and priorities

### For Task Commands (tasks.md)

- **Prioritization**: Weight tasks based on persona's values from their description
- **Success Criteria**: Define in terms persona values
- **Dependencies**: Consider persona's workflow preferences
- **Dynamic Application**: Extract priorities from persona description at runtime

### For Execution Commands (act.md)

- **Code Style**: Apply persona's coding conventions
- **Tool Usage**: Follow persona's preferred tools/approaches
- **Anti-patterns**: Avoid persona's specified anti-patterns
- **Validation**: Check against persona's review checklist

## Persona Reminder Format

End each response with active persona reminder:

### Planning Mode

```
📋 PLANNING MODE ACTIVE | Persona: {active-persona} | Use /act to execute or /tasks to generate task file
```

### Task Generation

```
Tasks generated with persona: {active-persona}
```

### Execution Mode

```
Executed with persona: {active-persona}
```

## Example Usage

### Auto-Selection

```
User: "Help me refactor this JavaScript API to use async/await"
System: Auto-selected 'senior-javascript-engineer' based on your request.
<!-- Active Persona: senior-javascript-engineer -->
```

### Multiple Matches

```
User: "Design a scalable UI for the dashboard"
System: Multiple personas could help:
1. system-design - For scalable architecture
2. minimalist-ui-ux-designer - For UI design

Which would you prefer?
```

### Custom Persona

```
User: "Use a custom persona: A security engineer focused on secure coding practices"
System: Using custom persona: A security engineer focused on secure coding practices
<!-- Active Persona: Custom - A security engineer focused on secure coding practices -->
```

## Error Handling

- If persona file not found: Continue without persona
- If invalid persona name: Request valid selection
- If context malformed: Create fresh context
- Always gracefully degrade to no-persona mode if needed
