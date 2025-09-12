## MANDATORY: File Reading Requirements

- **ALWAYS** read multiple files in parallel using a single message with multiple Read tool calls
- **MUST** batch file reads together when reading more than one file - NEVER read files sequentially
- This is MANDATORY and non-negotiable for performance optimization

## Directory Management

- **MUST** return to the original working directory after using cd

## Personas

For available personas and selection instructions, see ~/.claude/instructions/persona-selection.md

## Instructions Index

Available instructions for personas, commands, and agents. Components should explicitly state which instructions they are loading when relevant to their task.

### Workflow Instructions

#### persona-selection
Complete persona index with descriptions, paths, and instructions for automatic selection and loading.
Path: ~/.claude/instructions/persona-selection.md

#### parallel-agents
Guidelines for running multiple agents concurrently for complex, multi-step tasks.
Path: ~/.claude/instructions/parallel-agents.md

### Coding Standards

#### javascript
JavaScript/TypeScript conventions, modern ES6+ patterns, async/await usage, functional programming practices, and comprehensive JSDoc documentation standards.
Path: ~/.claude/instructions/standards/javascript.md

#### python
Python coding conventions, PEP 8 compliance, Pythonic idioms, and best practices.
Path: ~/.claude/instructions/standards/python.md
