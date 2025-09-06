# JSDoc Standards

## Core Rules
- Document all public APIs and exported functions
- Document complex internal functions
- Skip simple getters/setters and utility functions
- **NO @example tags** - Examples belong in tests, README, or separate docs

## Function Documentation

```javascript
/**
 * Brief description in active voice.
 *
 * @param {string} name - Parameter description
 * @param {Object} options - Configuration object
 * @param {boolean} [options.cache=true] - Optional with default
 * @param {number} options.timeout - Required property
 * @returns {Promise<User>} What the function returns
 * @throws {ValidationError} When validation fails
 */
```

## Type Documentation

```javascript
/**
 * @typedef {Object} User
 * @property {string} id - Unique identifier
 * @property {string} name - Full name
 * @property {string} [email] - Optional property
 */

/**
 * @typedef {('active'|'inactive'|'pending')} Status
 */
```

## Class Documentation

```javascript
/**
 * Manages user authentication.
 * @class
 */
class AuthManager {
  /**
   * Creates an AuthManager.
   * @param {AuthConfig} config
   */
  constructor(config) {}
}
```

## Writing Guidelines

### Descriptions
- First line: one-sentence summary
- Use active voice: "Validates input" not "Input is validated"
- Start parameter descriptions with lowercase
- Include units when relevant: "Timeout in milliseconds"

### Types
- Use brackets for optional: `[paramName]` or `[paramName=default]`
- Import types: `@param {import('./types').User}`
- Be specific: `{string[]}` not `{Array}`
- Use union types: `{(string|number)}`

## Essential Tags

**Common:**
- `@param` - Function parameters
- `@returns` - Return value
- `@throws` - Exceptions thrown
- `@typedef` - Custom type definitions

**When needed:**
- `@deprecated` - Mark obsolete (include migration path)
- `@private` - Internal APIs
- `@see` - Reference related code
- `@since` - Version added
- `@readonly` - Immutable properties

## Don't Document
- Obvious parameters: `@param {string} name - The name`
- Function name repetition in description
- Internal implementation details
- Self-evident code