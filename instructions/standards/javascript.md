# JavaScript Coding Standards

## Purpose

Technical standards and best practices for JavaScript projects focusing on clean, maintainable code.

## Language Requirements

### Modern JavaScript (ES6+)

- **Required:** Use ES6+ features unless project uses CommonJS
- **Const/Let:** Never use `var`, prefer `const` over `let`
- **Arrow Functions:** Prefer arrow functions: `const getName = (user) => user.name`. Only use `function` when you need `this` binding.
- **Template Literals:** For string interpolation
- **Destructuring:** For cleaner variable assignment
- **Spread/Rest:** For array/object operations

### Import Conventions

- **Always:** Use namespace imports for modules: `import * as moduleName from 'module'`
- **Never:** Import individual named exports
- **Benefit:** Creates clear namespaces and improves code readability
- **Pattern:** All module imports use the namespace pattern to provide clear context

### Async Patterns

- **Always:** Use async/await for asynchronous operations
- **Never:** Nested callbacks or long promise chains
- **Error Handling:** Try-catch blocks for async operations
- **Concurrency:** Promise.all() for parallel operations

## Functional Programming Principles

### Core Principles

- **Pure Functions:** Default approach for all functions
- **Immutability:** Never mutate data, create new copies
- **Composition:** Build complex behavior from simple functions
- **No Side Effects:** Functions should not modify external state
- **Declarative:** Describe what, not how

### Function Patterns

- **Higher-Order Functions:** Functions that accept/return functions
- **Currying:** Break down multi-argument functions
- **Partial Application:** Pre-fill function arguments
- **Function Composition:** Combine simple functions
- **Pipe/Compose:** Chain operations declaratively

### Immutability Rules

- **Objects:** Use spread operator or Object.assign for updates
- **Arrays:** Use map, filter, reduce instead of mutations
- **Never:** Use push, pop, splice, shift, unshift directly
- **Freeze:** Consider Object.freeze for true constants
- **Libraries:** Consider Immutable.js or Immer for complex cases

## Preferred Patterns

### Module Organization

1. **Modules** - Export functions directly from files
2. **Singletons** - IIFE modules for stateful behavior
3. **Functional Composition** - Compose small functions into larger ones

### Pattern Details

- **Modules:** Export functions directly, leveraging ES6 module system
- **Singletons:** Use IIFE pattern to create modules with encapsulated state
- **Composition:** Build complex functionality by composing pure functions

## Code Structure Limits

### Function Metrics

- **Length:** Maximum 30 lines (warn at 20)
- **Parameters:** Maximum 3 (use object destructuring for more)
- **Complexity:** Cyclomatic complexity < 10
- **Nesting:** Maximum 3 levels deep
- **Return Points:** Prefer single return or early returns

### Control Flow Formatting

- **Single Statements:** Omit curly braces for single-statement if/else/for/while
- **Multiple Statements:** Always use braces for multiple statements
- **Nested Conditions:** Always use braces when nesting to maintain clarity
- **Line Length:** Keep single-statement conditions on one line if under 80 chars

### File Metrics

- **Length:** Maximum 150 lines (warn at 100)
- **Exports:** One primary export per file
- **Imports:** Always use namespace imports, group and order consistently
- **Dependencies:** Justify each external dependency

## Naming Conventions

### Variables and Functions

- **Variables:** camelCase, descriptive (minimum 3 characters)
- **Constants:** UPPER_SNAKE_CASE for true constants
- **Functions:** Short verb patterns leveraging namespace context
- **Principle:** Namespace provides context, function name provides action only
- **Good Examples:** `db.connect()`, `db.query()`, `user.create()`, `cache.clear()`
- **Bad Examples:** `db.connectDatabase()`, `db.queryDatabase()`, `user.createUser()`
- **Booleans:** is/has/should prefix (e.g., `isValid`)
- **Arrays:** Plural nouns (e.g., `users`, `items`)

### Naming With Namespaces

- Since all imports use namespace pattern, keep function names short
- Namespace provides domain context
- Function name provides action only
- Avoid redundant naming that repeats the namespace

### Files and Directories

- **Files:** kebab-case for files (e.g., `user-service.js`)
- **Components:** PascalCase for React/Vue components
- **Tests:** `.test.js` or `.spec.js` suffix
- **Index Files:** Use sparingly, only for public APIs

## Common Anti-Patterns

### Code Smells to Flag

- **God Functions:** Functions doing multiple unrelated things
- **Deep Nesting:** More than 3 levels of nesting
- **Magic Numbers:** Hardcoded values without named constants
- **Duplicate Code:** Same logic repeated (>5 lines)
- **Dead Code:** Unused variables, functions, or imports
- **Console Logs:** Left in production code

### JavaScript-Specific Issues

- **Type Coercion:** Implicit type conversions
- **Global Variables:** Polluting global scope
- **Mutable Operations:** Any mutation of objects/arrays
- **Stateful Functions:** Functions with side effects
- **Imperative Loops:** Using for/while instead of map/filter/reduce
- **Synchronous Operations:** Blocking I/O in Node.js
- **Memory Leaks:** Uncleaned event listeners, timers
- **Individual Imports:** Using named imports instead of namespace imports
- **Redundant Names:** Function names that repeat the namespace context

## Documentation Requirements

### File Documentation

- Every JavaScript file must start with a module description
- Brief description of module purpose
- Use JSDoc format for documentation

```js
/**
 * User authentication and session management.
 * Handles login, logout, and token refresh.
 */
```

### Function Documentation

Every function must include:

- Brief description of function purpose
- Parameter types and descriptions using @param
- Return value type and description using @returns
- Error conditions using @throws

```js
/**
 * Validate user credentials against the database.
 * @param {string} email - User email address
 * @param {string} password - Plain text password
 * @returns {Promise<User>} Authenticated user object
 * @throws {AuthError} When credentials are invalid
 */
```

### Documentation Rules

- **Brevity:** One-line descriptions preferred
- **No Examples:** Don't include code examples in comments
- **Type Accuracy:** Use correct JavaScript types
- **Optional Params:** Mark with brackets in JSDoc
- **Default Values:** Document with equals sign

### Type Definitions

- Define reusable types at file top using @typedef
- Document all object properties
- Include type for every parameter
- Use consistent naming for types

### Common Type Patterns

- **Arrays:** `{Array<string>}` or `{string[]}`
- **Objects:** `{Object}` or custom `@typedef`
- **Functions:** `{Function}` or `{(param: type) => returnType}`
- **Promises:** `{Promise<type>}`
- **Union Types:** `{string|number}`
- **Any:** Avoid, use `{*}` only when truly any type

### Special Tags

- **@deprecated** - Mark obsolete code
- **@since** - Version when added
- **@todo** - Pending improvements
- **@see** - Reference related code
- **@async** - Mark async functions
- **@static** - Static methods
- **@public** - Public API
- **@private** - Internal use only
- **@protected** - Subclass access
- **@readonly** - Read-only properties

### Documentation Requirements

- All exported functions must be documented
- All module files must have file headers
- Complex data structures must have @typedef
- Error conditions must be documented

### AI-Friendly Patterns

- Use consistent tag order
- Always include types in braces
- Keep descriptions on same line as tag
- Use standard JSDoc tags only
- Avoid custom or framework-specific tags
