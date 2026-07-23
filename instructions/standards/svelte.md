---
title: Svelte 5 Coding Standards
type: technical_specification
version: 2.0.0
tags: [svelte, svelte5, runes, reactive, components]
last_updated: 2025-09-13
target_audience: [ai_agents, developers]
---

# Svelte 5 Coding Standards

## Overview

Mandatory standards for Svelte 5 using runes syntax. All deprecated Svelte 4 patterns are forbidden.

## Core Requirements

### Mandatory Runes Usage

**State & Reactivity:**

- Always use `$state()` for reactive variables
- Always use `$derived()` for computed values
- Always use `onMount()` for one-time setup on mount (fetches, subscriptions, DOM init)
- Always use `$effect()` for reactive side effects that re-run when dependencies change
- Never use `$effect()` as a fake `onMount` -- if it runs once and has no reactive dependencies, use `onMount`
- Never use `onMount()` for reactive updates -- if it needs to re-run on state changes, use `$effect`
- Use `$effect.pre()` for pre-DOM operations
- Never use plain `let` for reactive data
- Never use `$:` reactive statements

**Component Props:**

- Always use `$props()` with destructuring
- Define defaults inline: `const { prop = defaultValue } = $props()`
- Use rest syntax for additional props: `const { ...rest } = $props()`
- Mark two-way bindable with `$bindable()`
- Never use `export let` syntax

**Development Only:**

- Use `$inspect()` only in development environment

### Event Handling

**Required Syntax:**

- Always use lowercase HTML attributes: `onclick`, `onsubmit`, `oninput`
- Never use `on:` directive: ~~`on:click`~~
- Never use camelCase: ~~`onClick`~~
- Never use event modifiers: ~~`|preventDefault`~~

**Event Modifiers:**

- Implement as wrapper functions (preventDefault, stopPropagation, once)
- Chain modifiers through function composition

**Component Communication:**

- Use callback props instead of `createEventDispatcher`
- Pass functions as props with optional chaining

## Deprecated Patterns (Never Use)

### Svelte 4 Syntax

- `export let` for props
- `$:` reactive statements
- `on:` event directives
- Event modifiers (`|preventDefault`, `|stopPropagation`)
- `createEventDispatcher`
- `$$props`, `$$restProps`
- Store auto-subscriptions with `$` prefix
- Plain `let` for reactive values
- `<slot />` elements - use snippets instead

## Implementation Guidelines

### Component Structure Order

1. `<script context="module">` - Static exports, types
2. `<script>` - Imports, props, state, derived, effects, handlers
3. Template markup - HTML with conditionals and loops
4. `<style>` - Scoped styles

### State & Reactivity

**Principles:**

- Keep state granular for fine-grained updates
- Use state classes (`.svelte.js`) for complex shared state
- Place `$derived()` close to dependencies
- Minimize effect dependencies
- Always return cleanup from effects

**State Classes:**

- Define with `$state()` properties
- Include `$derived()` getters
- Export instances for sharing

### Navigation (SvelteKit)

**Required Imports:**

- `import { goto, beforeNavigate, preloadData, invalidate } from '$app/navigation'`
- `import { page } from '$app/stores'`

**Usage:**

- Programmatic: `goto(url)`
- Guards: `beforeNavigate(callback)`
- Data refresh: `invalidate(url)`
- Access params: `$page.params`
- Access URL: `$page.url`

### Template Patterns

**Snippets:**

- Define: `{#snippet name(params)}`
- Render: `{@render snippet()}`
- Pass as props to child components

**Conditionals:**

- Complex: `{#if}` blocks
- Simple: Ternary operators
- Max nesting: 2 levels

**Loops:**

- Always keyed: `{#each items as item (item.id)}`

### Styling

**Rules:**

- Styles scoped by default
- Use `:global()` sparingly with documentation
- Apply classes to HTML wrappers, not components
- Use `class:` directive for conditionals
- Use `style:` directive for CSS variables
- Avoid inline styles except dynamic values

### Performance

**Required:**

- Always use keyed `{#each}` blocks
- Use `$derived.by()` for expensive computations
- Minimize effect dependencies
- Batch state updates when possible

### Build Configuration

**svelte.config.js:**

- Enable `runes: true`
- Configure appropriate compiler options
- Set TypeScript configuration

### Security

**HTML Safety:**

- Never use `{@html}` with untrusted content
- Sanitize with DOMPurify before rendering
- Validate all dynamic content

**Props Validation:**

- Use TypeScript interfaces
- Validate in effects or derived
- Handle invalid combinations

## Validation Checklist

### Critical Requirements

- [ ] All reactive state uses `$state()`
- [ ] All computed values use `$derived()`
- [ ] All side effects use `$effect()` with cleanup
- [ ] All props use `$props()` with destructuring
- [ ] All events use lowercase HTML attributes
- [ ] All `{#each}` blocks have keys
- [ ] No deprecated Svelte 4 syntax present
- [ ] No `{@html}` with untrusted content
- [ ] Classes applied to HTML elements, not components

### Code Quality

- [ ] Components under 200 lines
- [ ] State is granular, not monolithic
- [ ] TypeScript types defined
- [ ] Event handlers under 3 lines

### TypeScript

**Requirements:**

- Define Props interfaces
- Use generic components when needed
- Type all exports
- Never use `any` (use `unknown` instead)

## Exceptions

Deprecated patterns allowed only for:

- Incremental Svelte 4 migration
- Third-party compatibility
- Documented framework limitations

Always comment exception rationale.
