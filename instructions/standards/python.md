# Python Coding Standards - Minimal & Modern

## Core Instructions

### Philosophy
- Write less, achieve more - every line must have purpose
- Modify existing code before creating new files
- Code must be self-documenting and maintainable by default

### File Creation Rules
- **ALWAYS check `~/.claude/instructions/minimal-file-creation.md` before creating any file**
- Only create files when modification is impossible
- Start every Python file with a one-line docstring
- No boilerplate, placeholders, or unnecessary imports
- Combine related functionality in single files

### Structure Limits
- Keep functions between 10-15 lines (20 absolute maximum)
- Keep modules under 200 lines (300 absolute maximum)
- Maintain maximum 2 nesting levels
- Use 3 parameters ideally (5 maximum, use dataclass beyond)

## Coding Instructions

### Type Hints
- Always include type hints for all parameters and returns
- Use modern syntax: `str | None` instead of `Optional[str]` (Python 3.10+)
- Use built-in generics: `list[str]` instead of `List[str]` (Python 3.9+)
- Include return types even for `None`

### Naming Conventions
- Use `snake_case` for functions and variables
- Use `PascalCase` for classes only
- Use `UPPER_SNAKE` for constants only
- Avoid abbreviations unless universally known (url, api, id)
- Names must explain intent, not implementation

### Function Design
- Each function must have single, clear responsibility
- Use early returns for edge cases
- Guard clauses instead of nested conditions
- Extract nested logic into separate functions
- Include docstring for public functions only

### Data Structures
- Use dataclasses for data containers
- Prefer dataclasses over dictionaries
- Use TypedDict for complex dictionary structures
- Initialize all class attributes in `__init__`

### Error Handling
- Use specific exception types
- Handle only expected errors
- Never use bare except clauses
- Always use context managers for resources
- Re-raise exceptions after logging

### Modern Python Practices
- Use pathlib for all file path operations
- Use f-strings for all string formatting
- Use list comprehensions for simple transforms
- Use generator expressions for memory efficiency
- Use walrus operator `:=` when it reduces lines
- Use match/case for complex conditionals (Python 3.10+)
- Use `with` statements for file operations
- Use `is None` instead of `== None`

### Import Organization
- Order: standard library, third-party, local
- One import per line
- No wildcard imports
- Group imports by type
- Use absolute imports only

## Quality Tools
- Run `black` for formatting (no configuration needed)
- Run `ruff` for linting (replaces flake8, isort, pylint)
- Run `mypy` for type checking (strict mode)

## Maintenance Requirements
- Write self-documenting code
- Comment why, not what
- Remove all commented-out code
- Use constants instead of magic numbers
- Make everything explicit over implicit
- Include tests alongside implementation when critical