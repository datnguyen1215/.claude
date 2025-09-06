# JavaScript Coding Standards

## Naming
- Use camelCase for variables and functions
- Use PascalCase for classes and components
- Use UPPER_SNAKE_CASE for constants
- Choose descriptive names over abbreviations

## Functions
- Limit functions to 20 lines maximum
- Accept maximum 3 parameters, use object for more
- Return early for edge cases
- Assign one responsibility per function
- Use arrow functions for callbacks
- Always handle errors in async functions

## Code Structure
- Maintain maximum 2 levels of nesting
- Use guard clauses instead of nested if statements
- Extract nested logic into separate functions
- Keep files under 200 lines
- Group related utilities in single file

## Variables
- Use const by default, let when reassignment needed
- Never use var
- Destructure objects and arrays when possible
- Define constants for magic numbers

## Async Operations
- Use async/await over callbacks and .then()
- Wrap await calls in try/catch blocks
- Never mix promises with async/await
- Handle all promise rejections

## Comparisons and Operators
- Use === and !== for comparisons
- Use optional chaining (?.) for nested property access
- Use nullish coalescing (??) for default values
- Use template literals for string concatenation

## Modules
- Export one component/class per file
- Use named exports for utilities
- Use default export for main component
- Import third-party modules before local modules

## Comments
- Write self-documenting code
- Comment why, not what
- Use JSDoc for public APIs
- Remove commented-out code

## Best Practices
- Test edge cases and error paths
- Log errors with meaningful context
- Return meaningful error messages
- Validate inputs at function boundaries
- Keep dependencies minimal