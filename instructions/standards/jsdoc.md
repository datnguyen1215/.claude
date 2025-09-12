# JSDoc Documentation Standards

## Purpose
AI-friendly documentation requirements for JavaScript projects. Focused on machine-readable, parseable documentation without verbose examples.

## File Documentation

### Required File Header
Every JavaScript file must start with a module description:

```javascript
/**
 * Brief description of what this module does with purpose
 */
```

## Function Documentation

### Required Elements
Every function must include, even inner/private ones:

```javascript
/**
 * Brief description of function purpose
 * @param {type} paramName - Parameter description
 * @returns {type} Return value description
 * @throws {ErrorType} When and why errors occur
 */
```

### Documentation Rules
- **Brevity:** One-line descriptions preferred
- **No Examples:** Don't include code examples in comments
- **Type Accuracy:** Use correct JavaScript types
- **Optional Params:** Mark with brackets: `[paramName]`
- **Default Values:** Document with equals: `paramName=defaultValue`

## Type Definitions

### Complex Types
Define reusable types at file top:

```javascript
/**
 * @typedef {Object} UserConfig
 * @property {string} name - User identifier
 * @property {number} timeout - Milliseconds before timeout
 * @property {boolean} [optional] - Optional flag
 */
```

### Common Type Patterns
- **Arrays:** `{Array<string>}` or `{string[]}`
- **Objects:** `{Object}` or custom `@typedef`
- **Functions:** `{Function}` or `{(param: type) => returnType}`
- **Promises:** `{Promise<type>}`
- **Union Types:** `{string|number}`
- **Any:** Avoid, use `{*}` only when truly any type

## Class Documentation

### Class Header
```javascript
/**
 * Brief class description
 * @class
 * @extends {ParentClass}
 */
```

### Constructor and Methods
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

## Special Tags

### Priority Tags
- **@deprecated** - Mark obsolete code
- **@since** - Version when added
- **@todo** - Pending improvements
- **@see** - Reference related code
- **@async** - Mark async functions
- **@static** - Static class methods
- **@override** - Overridden methods

### Access Modifiers
- **@public** - Public API
- **@private** - Internal use only
- **@protected** - Subclass access
- **@readonly** - Read-only properties

## AI-Friendly Patterns

### Machine Parsing
- Use consistent tag order
- Always include types in braces
- Keep descriptions on same line as tag
- Use standard JSDoc tags only
- Avoid custom or framework-specific tags

### Structured Data
- Define all data structures with @typedef
- Use consistent naming for types
- Document all object properties
- Include type for every parameter

## Validation Rules

### Must Document
- All exported functions
- All public class methods
- All module files
- Complex data structures
- Error conditions

### Optional Documentation
- Private helper functions under 5 lines
- Simple getters/setters
- Obvious utility functions
- Test helper functions

## Integration

### Tooling Compatibility
- Compatible with JSDoc parser
- VS Code IntelliSense support
- Documentation generation ready
- Type checking with TypeScript JSDoc mode

### Reference
This document complements `standards/javascript.md` for complete JavaScript standards.
