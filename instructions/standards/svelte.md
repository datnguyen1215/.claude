---
title: Svelte 5 Coding Standards
type: technical_specification
version: 1.0.0
tags: [svelte, svelte5, runes, reactive, components]
---

# Svelte 5 Coding Standards

## Purpose

Technical standards for Svelte 5 projects prioritizing modern runes syntax, fine-grained reactivity, and compile-time optimizations.

## Framework Requirements

### Svelte 5 Runes (Required)

- **$state:** Use for all reactive state declarations
- **$derived:** Use for computed values from state
- **$effect:** Use for side effects and lifecycle management
- **$props:** Use for component property definitions with destructuring
- **$bindable:** Use for two-way bindable props when needed
- **$inspect:** Use only during development for debugging

### Runes Syntax Rules

#### State Management

- Always use `$state()` for reactive variables
- Never use plain `let` declarations for reactive data
- Use `$derived()` for computed values instead of reactive statements
- Initialize state with appropriate default values
- Keep state granular for fine-grained reactivity

#### Component Props

- Always use `$props()` with destructuring syntax
- Define default values inline during destructuring
- Use rest syntax to capture additional props
- Mark two-way bindable props with `$bindable()`
- Never use `export let` syntax (deprecated in Svelte 5)

#### Effects and Lifecycle

- Use `$effect()` for all side effects
- Always return cleanup functions from effects when needed
- Use `$effect.pre()` for operations before DOM updates
- Replace all `$:` reactive statements with appropriate runes
- Handle subscriptions and listeners within effects

## Deprecated Svelte 5 Features

### Required Migrations

#### Event Dispatching

- Never use `createEventDispatcher`
- Always use callback props for parent communication
- Pass functions as props with optional chaining for safety

#### Reactive Statements

- Never use `$:` for reactive declarations
- Replace reactive statements with `$effect()` for side effects
- Replace reactive assignments with `$derived()` for computed values

#### Store Subscriptions

- Never use auto-subscription syntax with `$` prefix
- Use explicit subscriptions within `$effect()`
- Consider converting stores to runes-based state
- Always clean up subscriptions in effect return functions

#### Rest Props

- Never use `$$props` or `$$restProps`
- Use destructuring with rest syntax in `$props()`
- Access all props through the destructured object

## Component Structure

### File Organization Order

1. Script context="module" section (if needed)
   - Static exports and prerender settings
   - Type definitions and constants

2. Script section with runes
   - Import statements
   - Props destructuring with `$props()`
   - State declarations with `$state()`
   - Derived values with `$derived()`
   - Effects with `$effect()`
   - Event handler functions

3. Template markup
   - Semantic HTML structure
   - Proper conditional rendering
   - Keyed each blocks

4. Style section
   - Scoped styles by default
   - Minimal use of `:global()`

### Component Patterns

#### Snippets (Svelte 5 Feature)

- Use snippets for reusable template fragments
- Define with `{#snippet name(params)}`
- Render with `{@render snippet()}`
- Pass snippets as props to child components

#### Conditional Rendering

- Use `{#if}` blocks for complex conditions
- Use ternary operators for simple inline conditionals
- Always include `{:else}` blocks when appropriate
- Avoid nested conditionals beyond 2 levels

## Page Navigation

### SvelteKit Navigation Rules

- Import navigation functions from `$app/navigation`
- Use `goto()` for programmatic navigation
- Implement `beforeNavigate` for navigation guards
- Use `preloadData()` for performance optimization
- Access page data through `$page` store with `$derived()`

### Route Management

- Access route params through `$page.params`
- Use `$page.url` for URL information
- Implement proper loading states during navigation
- Handle navigation errors gracefully
- Use `invalidate()` for data refresh

### Navigation Guards

- Implement guards in layout or page components
- Use `beforeNavigate` hook for prevention logic
- Clean up guard subscriptions in effect returns
- Check for unsaved changes before navigation
- Provide user feedback for blocked navigation

## Reactivity Patterns

### State Management Principles

- Prefer granular state over monolithic objects
- Use state classes with runes for complex state
- Share state through `.svelte.js` modules
- Keep derived values close to their dependencies
- Avoid deep nesting of reactive structures

### State Classes (Svelte 5)

- Define classes with `$state()` properties
- Include `$derived()` getters for computed values
- Implement methods for state mutations
- Export instances for shared state
- Use TypeScript for type safety

### Performance Optimization

- Use `$derived.by()` for expensive computations
- Implement lazy loading for heavy components
- Always use keyed `{#each}` blocks
- Minimize effect dependencies
- Batch state updates when possible

## Styling Conventions

### Scoped Styles Rules

- Styles are scoped by default - leverage this
- Use `:global()` sparingly and document why
- Prefer component-scoped styles over global CSS
- Use CSS custom properties for theming
- Keep styles co-located with components

### Dynamic Styling

- Use `class:` directive for conditional classes
- Use `style:` directive for CSS custom properties
- Avoid inline styles except for truly dynamic values
- Prefer CSS classes over style attributes
- Use consistent naming conventions for classes

## Build Configuration

### Compiler Options

- Enable `runes: true` in svelte.config.js
- Set appropriate dev/production settings
- Configure CSS extraction strategy
- Enable immutable optimizations when applicable
- Use proper TypeScript configuration

### Testing Requirements

- Test components with @testing-library/svelte
- Test reactive state behavior
- Verify prop handling and validation
- Test navigation and routing logic
- Include accessibility testing

## Security Patterns

### HTML Safety

- Never use `{@html}` with untrusted content
- Sanitize user input before rendering
- Use DOMPurify or similar for HTML sanitization
- Validate and escape dynamic content
- Implement Content Security Policy

### Props Validation

- Validate props in effects or derived values
- Use TypeScript for compile-time type checking
- Throw errors for invalid prop combinations
- Document prop constraints clearly
- Handle edge cases gracefully

## Code Review Checklist

### Critical (Must Fix)

- Using deprecated Svelte 4 syntax patterns
- Missing runes for reactive state management
- Unkeyed each blocks in lists
- Raw HTML rendering without sanitization
- Store auto-subscriptions with $ prefix
- Using createEventDispatcher for events
- Memory leaks from uncleared effects

### Important (Should Fix)

- Components exceeding 200 lines
- Monolithic state objects instead of granular state
- Missing TypeScript type definitions
- Inline event handlers over 3 lines
- Global styles without clear justification
- Missing component props validation
- Synchronous operations blocking UI

### Suggested (Consider)

- Extract reusable template snippets
- Optimize expensive computations with $derived.by
- Add error boundaries for resilience
- Implement smooth page transitions
- Add comprehensive loading states
- Include ARIA attributes for accessibility
- Document complex state logic

## TypeScript Integration

### Type Requirements

- Define Props interfaces for all components
- Use generic components where appropriate
- Type all exported functions and constants
- Implement proper discriminated unions
- Avoid `any` type - use `unknown` if needed

## Common Anti-Patterns

### Svelte 5 Specific

- Using `$:` reactive statements instead of runes
- Manual store subscriptions without cleanup
- Direct mutation of $state arrays/objects
- Event dispatching instead of callback props
- Using $$props or $$restProps for prop access
- Regular let declarations for reactive values
- Missing cleanup in effects

### Performance Issues

- Unkeyed each blocks causing re-renders
- Large monolithic components
- Synchronous imports instead of dynamic
- Unnecessary effect dependencies
- Deep reactive object nesting
- Missing memoization for expensive operations

## Exceptions

Older patterns acceptable only when:

- Migrating large Svelte 4 codebases incrementally
- Third-party component compatibility requirements
- Specific measured performance requirements
- Documented framework limitations

Always document exception rationale with comments.
