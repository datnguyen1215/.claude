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
const withLogging =
  (fn) =>
  (...args) => {
    const result = fn(...args);
    console.log(result);
    return result;
  };

// Over classes
const createUser = (name) => ({
  name,
  greet: () => `Hello, ${name}`,
});
```

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
- **Examples:**

  ```javascript
  // Good - single statement, no braces
  if (!value) throw new Error("Value required");
  if (isValid) return true;

  // Good - multiple statements, use braces
  if (error) {
    logger.error(error);
    throw error;
  }
  ```

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

## Documentation Requirements

### Purpose

AI-friendly documentation requirements for JavaScript projects. Focused on machine-readable, parseable documentation without verbose examples.

### File Documentation

#### Required File Header

Every JavaScript file must start with a module description:

```javascript
/**
 * Brief description of what this module does with purpose
 */
```

### Function Documentation

#### Required Elements

Every function must include, even inner/private ones:

```javascript
/**
 * Brief description of function purpose
 * @param {type} paramName - Parameter description
 * @returns {type} Return value description
 * @throws {ErrorType} When and why errors occur
 */
```

#### Documentation Rules

- **Brevity:** One-line descriptions preferred
- **No Examples:** Don't include code examples in comments
- **Type Accuracy:** Use correct JavaScript types
- **Optional Params:** Mark with brackets: `[paramName]`
- **Default Values:** Document with equals: `paramName=defaultValue`

### Type Definitions

#### Complex Types

Define reusable types at file top:

```javascript
/**
 * @typedef {Object} UserConfig
 * @property {string} name - User identifier
 * @property {number} timeout - Milliseconds before timeout
 * @property {boolean} [optional] - Optional flag
 */
```

#### Common Type Patterns

- **Arrays:** `{Array<string>}` or `{string[]}`
- **Objects:** `{Object}` or custom `@typedef`
- **Functions:** `{Function}` or `{(param: type) => returnType}`
- **Promises:** `{Promise<type>}`
- **Union Types:** `{string|number}`
- **Any:** Avoid, use `{*}` only when truly any type

### Class Documentation

#### Class Header

```javascript
/**
 * Brief class description
 * @class
 * @extends {ParentClass}
 */
```

#### Constructor and Methods

```javascript
/**
 * @constructor
 * @param {type} param - Description
 */

/**
 * Method description
 * @public/@private/@protected
 * @param {type} param - Description
 * @returns {type} Description
 */
```

### Special Tags

#### Priority Tags

- **@deprecated** - Mark obsolete code
- **@since** - Version when added
- **@todo** - Pending improvements
- **@see** - Reference related code
- **@async** - Mark async functions
- **@static** - Static class methods
- **@override** - Overridden methods

#### Access Modifiers

- **@public** - Public API
- **@private** - Internal use only
- **@protected** - Subclass access
- **@readonly** - Read-only properties

### AI-Friendly Patterns

#### Machine Parsing

- Use consistent tag order
- Always include types in braces
- Keep descriptions on same line as tag
- Use standard JSDoc tags only
- Avoid custom or framework-specific tags

#### Structured Data

- Define all data structures with @typedef
- Use consistent naming for types
- Document all object properties
- Include type for every parameter

### Validation Rules

#### Must Document

- All exported functions
- All public class methods
- All module files
- Complex data structures
- Error conditions

#### Optional Documentation

- Private helper functions under 5 lines
- Simple getters/setters
- Obvious utility functions
- Test helper functions

### Integration

#### Tooling Compatibility

- Compatible with JSDoc parser
- VS Code IntelliSense support
- Documentation generation ready
- Type checking with TypeScript JSDoc mode

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
- [ ] Unnecessary braces on single-statement conditions

## Exceptions

Justified complexity is acceptable when:

- Required by external APIs
- Significant performance improvement (measured)
- Framework requirements
- Legacy system constraints

Document why the exception exists and contain its scope.
