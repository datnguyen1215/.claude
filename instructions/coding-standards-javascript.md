# JavaScript Coding Standards

## Purpose
Technical standards and best practices for JavaScript/TypeScript projects. These standards focus on measurable quality metrics and proven patterns.

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

### Class Metrics
- **Size:** Maximum 200 lines (warn at 150)
- **Methods:** Maximum 10 public methods
- **Constructor:** Minimal logic, primarily assignment
- **Inheritance:** Prefer composition over inheritance

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
- **Mutable Operations:** Modifying objects/arrays in place
- **Synchronous Operations:** Blocking I/O in Node.js
- **Memory Leaks:** Uncleaned event listeners, timers

## Framework Guidelines

### React Patterns
- **Components:** Functional components with hooks
- **State:** Minimal state, derived values when possible
- **Props:** PropTypes or TypeScript interfaces
- **Effects:** Cleanup in useEffect returns
- **Memoization:** Only when measurably needed

### Node.js Patterns
- **Modules:** Small, focused modules
- **Error Handling:** Proper error propagation
- **Streams:** For large data processing
- **Environment:** Use environment variables for config
- **Security:** Input validation, parameterized queries

### Vue Patterns
- **Composition API:** Preferred over Options API
- **Reactivity:** Understand ref vs reactive
- **Components:** Single-file components < 150 lines
- **Props/Events:** Clear parent-child communication

## Type Safety

### TypeScript Usage
- **Interfaces:** Define all data structures
- **Types:** Avoid `any`, use `unknown` when needed
- **Generics:** When truly reusable
- **Enums:** Prefer const assertions or union types
- **Strict Mode:** Enable all strict checks

### JSDoc (When Not Using TypeScript)
- **Functions:** Document parameters and returns
- **Complex Types:** Define with @typedef
- **Public APIs:** Full documentation required

## Performance Considerations

### Optimization Rules
- **Measure First:** Profile before optimizing
- **Algorithm Choice:** O(n) better than O(n²)
- **Lazy Loading:** Load only what's needed
- **Caching:** Cache expensive computations
- **Bundling:** Minimize bundle size

### Memory Management
- **Cleanup:** Remove listeners, clear timers
- **References:** Avoid circular references
- **Closures:** Be aware of closure scope
- **Large Data:** Use streams or pagination

## Testing Requirements

### Test Structure
- **Coverage:** Critical paths must be tested
- **Isolation:** Tests should not depend on each other
- **Speed:** Unit tests < 100ms each
- **Clarity:** Test names describe behavior
- **Maintenance:** Tests shouldn't break from refactoring

### Testing Patterns
- **AAA Pattern:** Arrange, Act, Assert
- **Mocking:** Mock external dependencies only
- **Edge Cases:** Test boundaries and errors
- **Integration:** Test critical user paths

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

### Should Fix (Important)
- [ ] Functions over 20 lines
- [ ] More than 3 parameters
- [ ] Deep nesting (>3 levels)
- [ ] Missing error handling
- [ ] Code duplication (>5 lines)

### Consider Fixing (Suggested)
- [ ] Complex conditionals
- [ ] Missing tests for critical paths
- [ ] Inconsistent naming
- [ ] Performance optimizations
- [ ] Additional documentation

## Refactoring Priorities

1. **Security Issues:** Fix immediately
2. **Bugs:** Fix before adding features
3. **Performance:** When measurably slow
4. **Readability:** When maintaining
5. **Structure:** During feature additions

## Exceptions

Justified complexity is acceptable when:
- Required by external APIs
- Significant performance improvement (measured)
- Framework requirements
- Legacy system constraints

Document why the exception exists and contain its scope.