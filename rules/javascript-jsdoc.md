# JavaScript + JSDoc Rules

**ABSOLUTE RULE**: Use JavaScript + JSDoc ONLY. TypeScript is FORBIDDEN.

## Language Requirements

### JavaScript Only
- ❌ `interface User { name: string; }` → ✅ `@typedef {Object} User`
- ❌ `function create(name: string): User` → ✅ `@param {string} name` + `@returns {User}`
- ❌ `.ts` files → ✅ `.js` files only

### Function Styles (Priority Order)
- ✅ **Arrow functions** - PRIMARY choice for all functions
- ✅ **Function composition** - For complex logic over classes
- ✅ **Regular functions** - ONLY when hoisting is required
- ❌ **Classes** - Use functions + closures instead
- ❌ **Classes allowed** - Only for DOM APIs or framework requirements
- ✅ **Async/await** over Promise chains
- ❌ `function` keyword for simple operations

## JSDoc Documentation

### Essential Tags Only
- `@param` - Function parameters
- `@returns` - Return values  
- `@typedef` - Type definitions
- `@throws` - Exceptions thrown
- `@async` - Async functions

### Forbidden Bloat Tags
- ❌ `@author`, `@fileoverview`, `@example`, `@since`, `@version`

## Modern JavaScript Patterns

### ES6+ Features
- ✅ Destructuring assignments
- ✅ Spread operator
- ✅ Template literals
- ✅ ES modules (import/export)
- ❌ Dynamic imports - No import() expressions
- ✅ Optional chaining (`?.`)
- ✅ Nullish coalescing (`??`)

### Code Style
```javascript
// ✅ Arrow function for callbacks
const users = data.map(item => ({ name: item.name, id: item.id }));

// ✅ Regular function for main logic
/**
 * @param {Array<User>} users
 * @returns {Promise<Array<User>>}
 */
async function processUsers(users) {
  return users.filter(user => user.active);
}

// ✅ Destructuring with JSDoc
/**
 * @param {Object} config
 * @param {string} config.host
 * @param {number} config.port
 */
function connect({ host, port }) {
  // Implementation
}
```

## What NOT to Document

### Skip Obvious Code
- ❌ Simple getters/setters
- ❌ Trivial one-line functions
- ❌ Self-explanatory variable assignments
- ✅ Complex business logic only

**Write clear, self-documenting code with minimal but valuable JSDoc types.**