# Frontend Svelte 5 Rules

**ABSOLUTE RULE**: Use Svelte 5 runes ONLY. Legacy Svelte 4 patterns are FORBIDDEN.

## Mandatory Runes Syntax

### State Management

- **State**: Use `$state()` for reactive variables
- **Derived**: Use `$derived()` for computed values
- **Effects**: Use `$effect()` for side effects
- **Props**: Use `$props()` for component props

### Forbidden Legacy Syntax

- ❌ `let count = 0` → ✅ `let count = $state(0)`
- ❌ `$: doubled = count * 2` → ✅ `let doubled = $derived(count * 2)`
- ❌ `$: console.log(count)` → ✅ `$effect(() => console.log(count))`
- ❌ `export let title` → ✅ `let { title } = $props()`

## Events & Communication

### Modern Events

- ❌ `on:click={handler}` → ✅ `onclick={handler}`
- ❌ `on:change={handler}` → ✅ `onchange={handler}`
- ❌ `on:submit|preventDefault` → ✅ Manual `event.preventDefault()`

### Component Communication

- ❌ `createEventDispatcher()` → ✅ Callback props via `$props()`
- ✅ Use `onMount()` for component initialization
- ✅ Return cleanup function from `onMount()` instead of using `onDestroy()`
- ✅ Use `$effect()` ONLY for tracking reactive state changes

## Shared State

### Store Usage Guidelines

- ❌ `import { writable, readable, derived } from 'svelte/store'` → Use runes
- ❌ `import { page, navigating, updated } from '$app/stores'` → Deprecated in SvelteKit 2.12
- ✅ Use runes for custom state management

### SvelteKit State (Replaces $app/stores)

- ✅ `import { page, navigating, updated } from '$app/state'` → Modern SvelteKit state
- ❌ `$page.url.pathname` → ✅ `page.url.pathname` (no $ prefix)
- ❌ `$navigating` → ✅ `navigating` (direct access)
- ✅ Fine-grained reactivity: updates to `page.state` won't trigger `page.data` reactivity
- ✅ Migration: Run `npx sv migrate sveltekit-2` for automatic conversion

### Lifecycle vs Effects

- ✅ `onMount()` - For one-time setup when component mounts
- ✅ Return cleanup function from `onMount()` for teardown
- ✅ `$effect()` - ONLY for reacting to state changes
- ❌ Don't use `$effect()` as a replacement for lifecycle hooks

**Follow these rules for modern, warning-free Svelte 5 code.**
