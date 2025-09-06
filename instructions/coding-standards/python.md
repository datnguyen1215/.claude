# Python Coding Standards

## Naming
- Use snake_case for functions and variables
- Use PascalCase for classes
- Use UPPER_SNAKE_CASE for constants
- Prefix private methods with underscore
- Choose descriptive names over abbreviations

## Functions
- Limit functions to 20 lines maximum
- Accept maximum 5 parameters, use dataclass for more
- Include type hints for all parameters and returns
- Return early for edge cases
- Assign one responsibility per function
- Write docstrings for public functions

## Code Structure
- Maintain maximum 2 levels of nesting
- Use guard clauses instead of nested if statements
- Extract nested logic into separate functions
- Keep modules under 300 lines
- Keep lines under 88 characters

## Type Hints
- Always use type hints
- Use Optional[] for nullable types
- Use Union[] or | for multiple types
- Import typing utilities as needed
- Use TypedDict for complex dictionaries

## Error Handling
- Use specific exception types
- Handle expected errors explicitly
- Never use bare except clauses
- Use context managers for resources
- Log errors with meaningful context

## Classes
- Use dataclasses for data containers
- Keep single responsibility per class
- Prefer composition over inheritance
- Use properties for computed attributes
- Initialize all attributes in __init__

## Imports
- Order: standard library, third-party, local
- One import per line
- No wildcard imports
- Group imports by type
- Use absolute imports

## Best Practices
- Use f-strings for formatting
- Use pathlib for file paths
- Use enumerate() over range(len())
- Use with statement for file operations
- Use is None instead of == None
- Prefer list comprehensions for simple transforms
- Use defaultdict and Counter when appropriate
- Run black for formatting
- Run mypy for type checking

## Comments
- Write self-documenting code
- Comment why, not what
- Use docstrings for modules, classes, and functions
- Remove commented-out code