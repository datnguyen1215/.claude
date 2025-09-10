---
name: spec
description: Generate AI-friendly specifications for features, technical design, APIs, and tests
model: claude-opus-4-1-20250805
---

## Persona Context

Apply persona from instructions/persona-selection.md
Use persona perspective to shape specification focus and priorities
Weight requirements based on persona principles

## Instructions

Generate comprehensive, AI-friendly specifications from conversation context or existing code. Supports interactive file selection before generation. Creates cross-referenced specs optimized for AI consumption.

## Workflow

1. **ANALYZE**: Extract context from conversation, plan, or codebase
2. **PROPOSE**: Present spec files with descriptions for user selection
3. **AWAIT**: Get user confirmation on which specs to generate
4. **GENERATE**: Create selected specs with cross-references
5. **VALIDATE**: Include validation checklist in all specs

## Spec Types

| Type      | Focus                                        | AI Optimization                                |
| --------- | -------------------------------------------- | ---------------------------------------------- |
| feature   | User stories, acceptance criteria, workflows | Clear scenarios with expected outcomes         |
| technical | Architecture, components, data flow          | Exact file paths and function signatures       |
| api       | Endpoints, contracts, payloads               | Request/response examples with curl commands   |
| test      | Test scenarios, coverage, assertions         | Executable test commands with expected outputs |

## Interactive Proposal Format

```markdown
## Proposed Specifications for: {description}

Based on context, I recommend creating:

### 1. feature-spec.md

**Purpose**: User-facing requirements and acceptance criteria
**Will include**: User stories, workflows, edge cases
**References**: → technical-spec.md, → test-spec.md
**AI-Friendly**: Structured user stories with clear acceptance criteria

### 2. technical-spec.md

**Purpose**: Implementation architecture and design
**Will include**: Components, data flow, dependencies
**References**: ← feature-spec.md, → api-spec.md
**AI-Friendly**: Exact file paths, function signatures, code patterns

### 3. api-spec.md

**Purpose**: Service contracts and interfaces
**Will include**: Endpoints, payloads, error codes
**References**: ← technical-spec.md, → test-spec.md
**AI-Friendly**: Request/response examples, curl commands

### 4. test-spec.md

**Purpose**: Validation scenarios and coverage
**Will include**: Test cases, data sets, assertions
**References**: ← feature-spec.md, ← api-spec.md
**AI-Friendly**: Executable test commands, expected outputs

Which specs should I create? (Reply with numbers, e.g., "1,3" or "all")
```

## AI-Optimized Spec Template

````markdown
<!-- AI-CONTEXT: {brief description of this spec's purpose} -->
<!-- DEPENDENCIES: {list of related spec files} -->
<!-- TOOLS-NEEDED: {Claude Code tools required for implementation} -->

# {Type} Specification: {Title}

## Quick Context

> One-line summary for AI to immediately understand the purpose

## Requirements

### Priority: MUST

1. **{Requirement Name}**
   - File: `path/to/file.ts:123`
   - Function: `functionName(params: Type)`
   - Details: {specific implementation notes}

### Priority: SHOULD

2. **{Requirement Name}**
   - Config: `config/setting.json`
   - Pattern: {code pattern to follow}

### Priority: MAY

3. **{Optional Feature}**
   - Consider: {when to implement}

## Implementation Guide

```bash
# Step-by-step commands for implementation
mkdir -p src/feature
touch src/feature/index.ts

# Install dependencies
npm install required-package
```
````

### Code Structure

```typescript
// Example structure to follow
interface FeatureConfig {
  setting: string;
  options: FeatureOptions;
}
```

## Cross-References

- **Feature Requirements**: [feature-spec.md#user-stories](./feature-spec.md#user-stories)
- **API Contract**: [api-spec.md#endpoints](./api-spec.md#endpoints)
- **Test Coverage**: [test-spec.md#scenarios](./test-spec.md#scenarios)
- **Technical Design**: [technical-spec.md#architecture](./technical-spec.md#architecture)

## Validation Checklist

<!-- AI-NOTE: Each item includes a verification command or check -->

- [ ] Core functionality implemented

  ```bash
  # Verify file exists and exports required function
  grep -q "export.*functionName" src/feature/index.ts
  ```

- [ ] Tests passing

  ```bash
  npm test feature  # Should show all green
  ```

- [ ] API endpoint responding

  ```bash
  curl -X GET localhost:3000/api/feature  # Should return 200
  ```

- [ ] Documentation updated
  ```bash
  ls docs/feature.md  # File should exist
  ```

## Edge Cases & Error Handling

- **Case**: {edge case description}

  - Handle: {how to handle}
  - Test: `test/edge-cases.test.ts:45`

- **Error**: {error type}
  - Response: {error handling approach}
  - Code: {HTTP status or error code}

```

## File Organization

```

.tmp/spec/{brief-description}/
├── feature-spec.md # User stories and acceptance criteria
├── technical-spec.md # Architecture and implementation details
├── api-spec.md # Endpoints and contracts
├── test-spec.md # Test scenarios and coverage
├── validation.md # Unified validation checklist
└── index.md # Overview with links to all specs

```

## Command Parameters

- `type` (optional): Specific spec type to generate (feature|technical|api|test|all)
  - Omit for interactive proposal
  - Use "all" to skip proposal and generate all specs
- Description extracted from context or prompted if missing

## Guidelines

- **Extract from Context**: Use conversation history and existing code
- **Be Specific**: Include exact file paths, line numbers, function names
- **Cross-Reference**: Link related specs for complete context
- **AI-Friendly**: Use structured markdown, code blocks, executable examples
- **Validation-Ready**: Include testable success criteria
- **Persona-Aligned**: Apply active persona's principles to spec focus

## Example Usage

### Interactive (default)
```

/spec

# Shows proposal, waits for selection

# User replies: "1,2,4" or "all"

# Generates selected specs in .tmp/spec/auth-system/

```

### Specific Type
```

/spec type=feature

# Proposes only feature spec

# Waits for confirmation

# Generates in .tmp/spec/user-dashboard/

```

### Generate All
```

/spec type=all

# Skips proposal

# Generates all relevant specs immediately

# Creates in .tmp/spec/payment-integration/

```

## Tools

Read, Grep, Glob, Bash (read-only), Write (.tmp/spec only), WebFetch, WebSearch
```
