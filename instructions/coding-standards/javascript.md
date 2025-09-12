# JavaScript Coding Standards

## Purpose
Technical standards and best practices for JavaScript projects. These standards focus on measurable quality metrics and proven patterns.

## Language Requirements

### Modern JavaScript (ES6+)
- **Required:** Use ES6+ features unless project uses CommonJS
- **Const/Let:** Never use `var`, prefer `const` over `let`
- **Arrow Functions:** For callbacks and simple functions
- **Template Literals:** For string interpolation
- **Destructuring:** For cleaner variable assignment
- **Spread/Rest:** For array/object operations

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

### Composition Patterns
```javascript
// Prefer composition
const withLogging = (fn) => (...args) => {
  const result = fn(...args);
  console.log(result);
  return result;
};

// Over classes
const createUser = (name) => ({
  name,
  greet: () => `Hello, ${name}`
});
```

## Code Structure Limits

### Function Metrics
- **Length:** Maximum 30 lines (warn at 20)
- **Parameters:** Maximum 3 (use object destructuring for more)
- **Complexity:** Cyclomatic complexity < 10
- **Nesting:** Maximum 3 levels deep
- **Return Points:** Prefer single return or early returns

### File Metrics
- **Length:** Maximum 150 lines (warn at 100)
- **Exports:** One primary export per file
- **Imports:** Group and order consistently
- **Dependencies:** Justify each external dependency

### When Classes Are Justified
- **Framework Requirements:** When framework demands classes (rare)
- **Performance:** Proven performance benefit (measured)
- **External APIs:** When interfacing with class-based libraries
- **Always Prefer:** Factory functions and object composition
- **Never:** Use classes for simple data structures or utilities

## Naming Conventions

### Variables and Functions
- **Variables:** camelCase, descriptive (minimum 3 characters)
- **Constants:** UPPER_SNAKE_CASE for true constants
- **Functions:** verbNoun pattern (e.g., `getUserData`)
- **Booleans:** is/has/should prefix (e.g., `isValid`)
- **Arrays:** Plural nouns (e.g., `users`, `items`)

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
- **Mutable Operations:** Any mutation of objects/arrays (critical anti-pattern)
- **Class Overuse:** Using classes when functions suffice
- **Stateful Functions:** Functions with side effects
- **Imperative Loops:** Using for/while instead of map/filter/reduce
- **Synchronous Operations:** Blocking I/O in Node.js
- **Memory Leaks:** Uncleaned event listeners, timers

## Framework Guidelines

### React Patterns
- **Components:** Functional components only (no class components)
- **State:** useState, useReducer with immutable updates
- **Props:** Pure functions of props to JSX
- **Effects:** Minimize useEffect, prefer derived state
- **Composition:** Custom hooks for logic reuse

### Node.js Patterns
- **Modules:** Pure function exports
- **Middleware:** Functional composition pattern
- **Data Processing:** Stream transformations
- **Error Handling:** Functional error handling (Result/Either pattern)
- **No Classes:** Use factory functions for instances

### Vue Patterns
- **Composition API:** Always use over Options API
- **Composables:** Pure functions returning reactive state
- **Computed:** Prefer computed over watchers
- **Components:** Functional where possible

## Documentation Requirements

### JSDoc Standards
- **Required:** All functions and files must be documented
- **Reference:** See `coding-standards/jsdoc.md` for detailed requirements
- **File Headers:** Every file must explain its purpose and module context
- **Function Docs:** Parameters, returns, and throws must be documented
- **Type Definitions:** Use @typedef for complex data structures
- **AI-Friendly:** Documentation must be machine-readable and parseable

## Performance Considerations

### Memory Management
- **Cleanup:** Remove listeners, clear timers
- **References:** Avoid circular references
- **Closures:** Be aware of closure scope
- **Large Data:** Use streams or pagination

## Error Handling

### Error Patterns
- **Specific Errors:** Create custom error classes
- **Error Messages:** Descriptive and actionable
- **Logging:** Log errors with context
- **Recovery:** Graceful degradation when possible
- **User Feedback:** Clear error messages to users

## Security Requirements

### Input Validation
- **Always Validate:** Never trust user input
- **Sanitization:** Clean data before use
- **Parameterization:** Use parameterized queries
- **Authentication:** Verify user identity
- **Authorization:** Check permissions

### Common Vulnerabilities
- **XSS:** Escape output, use CSP
- **Injection:** Parameterize all queries
- **CSRF:** Use tokens for state changes
- **Dependencies:** Keep dependencies updated
- **Secrets:** Never commit secrets to code

## Code Review Checklist

### Must Fix (Critical)
- [ ] Functions over 30 lines
- [ ] Files over 150 lines
- [ ] Nested callbacks or promise chains
- [ ] Security vulnerabilities
- [ ] Memory leaks
- [ ] Direct mutations of data
- [ ] Unnecessary class usage
- [ ] Side effects in pure functions

### Should Fix (Important)
- [ ] Functions over 20 lines
- [ ] More than 3 parameters
- [ ] Deep nesting (>3 levels)
- [ ] Missing error handling
- [ ] Code duplication (>5 lines)
- [ ] Imperative code that could be declarative
- [ ] Missing pure function documentation
- [ ] Stateful operations

### Consider Fixing (Suggested)
- [ ] Complex conditionals
- [ ] Missing tests for critical paths
- [ ] Inconsistent naming
- [ ] Performance optimizations
- [ ] Additional documentation

## Exceptions

Justified complexity is acceptable when:
- Required by external APIs
- Significant performance improvement (measured)
- Framework requirements
- Legacy system constraints

Document why the exception exists and contain its scope.
