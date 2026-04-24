---
name: js
description: Senior JavaScript/TypeScript coding standards. Use when writing, editing, or reviewing .js, .mjs, .cjs, .jsx, .ts, or .tsx files. Covers function shape, control flow, async patterns, immutability, naming, imports, comments, errors, and TS-specific rules. Apply to both new code and edits to existing code.
---

# JavaScript / TypeScript senior standards

Rules apply to `.js .mjs .cjs .jsx .ts .tsx` equally. TS-only rules marked.

Principle: subtract before add. Delete before write. Done = nothing left to remove.

## 1. Function shape

- Arrow functions everywhere: `const fn = () => {}`.
- Max 20 line body. Past that, split.
- Max 3 parameters. Past that, destructure an object.
- One job per function. Name = the job, verb form.
- Pure by default. Side effects need a reason to exist.
- Named exports only. No default export.

## 2. Control flow

- Early return. Never `else` after `return`.
- Guard clauses at top of function.
- Max nesting depth 2. Three levels means extract.
- No nested ternary.
- `switch` only for 4+ branches on the same value. Otherwise object lookup or if/else.

Good:
```js
const getUser = (id) => {
  if (!id) return null
  if (!isValid(id)) return null
  return db.find(id)
}
```

Bad:
```js
const getUser = (id) => {
  if (id) {
    if (isValid(id)) {
      return db.find(id)
    } else {
      return null
    }
  } else {
    return null
  }
}
```

## 3. Async

- `async/await` by default.
- `.catch()` for fire-and-log side effects. Cleaner than try/catch wrapping a single await.
- `try/catch` only when one of: `finally` needed, rollback needed, branch on error type, or multi-await shared recovery.
- Never empty catch. If swallowing, comment the why.
- `Promise.all` for independent operations. No `await` inside `for` loop when parallel is possible.
- Pick one style per call site. No `.then()` chained onto `await`.

Fire-and-log:
```js
sendMetric(event).catch((err) => log.warn('metric failed', err))
```

Rollback case (try/catch justified):
```js
const transfer = async (from, to, amount) => {
  const tx = await db.begin()
  try {
    await tx.debit(from, amount)
    await tx.credit(to, amount)
    await tx.commit()
  } catch (err) {
    await tx.rollback()
    throw err
  }
}
```

## 4. Data

- Immutable. Use `map/filter/reduce`, not mutation.
- Never `push/pop/splice/shift/unshift` on parameters or shared state. Local scratch arrays are fine.
- Spread for shallow copy. `structuredClone` for deep.
- `const` by default. `let` only when reassigned. Never `var`.
- Strict equality `===` only. Never `==`.

## 5. Naming

- camelCase variables and functions. UPPER_SNAKE_CASE for true constants. PascalCase for types, classes, components.
- Boolean prefix: `is`, `has`, `should`, `can`.
- Arrays plural: `users`, `items`.
- Functions are verbs: `getUser`, not `user`.
- Banned empty words: `Helper`, `Util`, `Manager`, `Handler`, `Data`, `Info`, `Wrapper`.
- Namespace provides context. If imported as `user.*`, call it `user.create`, not `user.createUser`.
- Minimum 3 characters, except `id`, `fn`, `x/y`, loop `i`.

## 6. Imports

- Namespace imports for own modules: `import * as user from './user.js'`.
- Named imports for stdlib and third-party: `import { readFile } from 'fs/promises'`.
- Group order: stdlib, third-party, own. Blank line between groups.
- No circular imports. No deep relative paths like `../../../`. Use path aliases.

## 7. Comments

- Comment the why, not the what. Good names handle the what.
- Only when the why is not obvious from the code itself: hidden constraint, subtle invariant, workaround for a specific bug, surprising trade-off.
- Full sentence. Half-comments rot faster than no comments.
- No `// TODO` without an issue link or date.
- No commented-out code. Git remembers.
- JSDoc on exported functions only. Internal functions rely on a good name.

Good:
```js
// Stripe webhooks retry for 3 days; dedupe by event id to avoid double-charging.
const processed = new Set()
```

Bad:
```js
// create a new set
const processed = new Set()
```

## 8. File

- Max 150 lines. Warn at 100.
- One primary export per file.
- kebab-case filenames: `user-service.js`.
- Tests beside source: `user-service.test.js`.

## 9. Errors

- Throw `Error` subclasses, never strings.
- Error message = what broke + context. Not "something wrong".
- Validate at boundaries (user input, external APIs). Trust internal calls.
- Do not catch only to rethrow unchanged. Let it bubble.

## 10. TypeScript

- `type` by default. `interface` only when extension or declaration merging is needed.
- No `any`. Use `unknown` when truly unknown, then narrow before use.
- No `!` non-null assertions. Narrow properly.
- Infer return types, except on public API where explicit is clearer.
- No `enum`. Use `as const` objects.

## 11. Subtraction

- Delete dead code in the same commit it is found.
- Delete unused parameters and imports.
- No "just in case" parameters.
- No wrappers that only rename.
- No abstraction until the third repeat.

## 12. Banned anti-patterns

- `this` gymnastics: no `.bind`, no `const self = this`.
- Classes unless stateful with identity. Prefer closures and modules.
- Getters/setters for plain data. Just use a property.
- Mutating parameters. Return new values.
- `console.log` in committed code. Remove it or use a logger.
- Magic numbers. Name the constant.

## Workflow when editing

1. Read the file first. Match existing style where it does not conflict with these rules.
2. Before adding code, check if existing code can be deleted or simplified instead.
3. When a rule conflict forces a larger refactor than the task asks for, note it, do not silently expand scope.
