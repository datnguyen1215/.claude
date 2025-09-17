## MANDATORY: File Reading Requirements

- **ALWAYS** read multiple files in parallel using a single message with multiple Read tool calls
- **MUST** batch file reads together when reading more than one file - NEVER read files sequentially
- This is MANDATORY and non-negotiable for performance optimization

## Directory Management

- **MUST** return to the original working directory after using cd
- **ALWAYS** return to the original directory even if an error occurs during cd or subsequent commands
- This is MANDATORY to maintain consistent context

## Core Principles

Minimalist principles and standards loader are automatically applied.
See Instructions Index for available standards and workflows.

## Instructions Index

Available instructions for commands, agents, and standards. Components should explicitly state which instructions they are loading when relevant to their task.

### Core Instructions

#### minimalist-principles

Core decision framework using Delete/Simplify/Clarify/Consolidate test for all decisions.
Path: ~/.claude/instructions/core/minimalist-principles.md

#### standards-loader

Automatic language detection and standards loading for code files.
Path: ~/.claude/instructions/core/standards-loader.md

### Workflow Instructions

#### parallel-agents

Guidelines for running multiple agents concurrently for complex, multi-step tasks.
Path: ~/.claude/instructions/parallel-agents.md

#### hierarchical-state-machines

Complete reference for implementing state machines using @datnguyen1215/hsmjs library. Load when working with state management, complex UI flows, event-driven logic, or multi-step processes.
Path: ~/.claude/instructions/hierarchical-state-machines.md

#### documentation

Machine-readable documentation principles with semantic structure and clarity requirements.
Path: ~/.claude/instructions/standards/documentation.md

### Coding Standards

#### javascript

JavaScript/TypeScript conventions, modern ES6+ patterns, async/await usage, functional programming practices, and comprehensive JSDoc documentation standards.
Path: ~/.claude/instructions/standards/javascript.md

#### python

Python coding conventions, PEP 8 compliance, Pythonic idioms, and best practices.
Path: ~/.claude/instructions/standards/python.md

#### svelte

Svelte 5 standards prioritizing runes syntax, fine-grained reactivity, deprecated features guidance, and SvelteKit navigation patterns.
Path: ~/.claude/instructions/standards/svelte.md

### Analysis Instructions

#### business-patterns

Revenue-focused business analysis with 70% rule, unit economics, and minimalist metrics.
Path: ~/.claude/instructions/analysis/business-patterns.md

### Design Instructions

#### ui-ux-guidelines

Progressive disclosure, visual clarity, cognitive load reduction, and accessibility principles.
Path: ~/.claude/instructions/design/ui-ux-guidelines.md
