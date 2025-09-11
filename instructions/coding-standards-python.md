# Python Coding Standards

## Purpose
Technical standards and best practices for Python projects. These standards combine PEP 8 compliance with minimalist principles and measurable quality metrics.

## Language Requirements

### Python Version
- **Minimum:** Python 3.8+ for new projects
- **Type Hints:** Required for all public functions
- **F-strings:** Preferred for string formatting
- **Pathlib:** For file path operations
- **Dataclasses:** For data structures

### Pythonic Patterns
- **Comprehensions:** When readable and simple
- **Generators:** For memory efficiency with large data
- **Context Managers:** For resource management
- **Decorators:** Only when they simplify code
- **Multiple Assignment:** For related values

## Code Structure Limits

### Function Metrics
- **Length:** Maximum 30 lines (warn at 20)
- **Parameters:** Maximum 4 (use dataclass/dict for more)
- **Complexity:** Cyclomatic complexity < 10
- **Nesting:** Maximum 3 levels deep
- **Return Points:** Early returns for guard clauses

### File Metrics
- **Length:** Maximum 200 lines (warn at 150)
- **Classes per File:** Preferably one main class
- **Import Groups:** Standard, third-party, local
- **Module Docstring:** Required for all modules

### Class Metrics
- **Size:** Maximum 200 lines (warn at 150)
- **Methods:** Maximum 10 public methods
- **Init Method:** Minimal logic, primarily assignment
- **Inheritance:** Maximum 2 levels deep
- **Mixins:** Use sparingly, document purpose

## PEP 8 Compliance

### Naming Conventions
- **Variables/Functions:** snake_case
- **Constants:** UPPER_SNAKE_CASE
- **Classes:** PascalCase
- **Private:** Leading underscore (_private)
- **Protected:** Leading underscore (_protected)
- **Module Private:** Leading underscore

### Code Layout
- **Line Length:** Maximum 88 characters (Black default)
- **Indentation:** 4 spaces (never tabs)
- **Blank Lines:** 2 between top-level, 1 between methods
- **Imports:** Grouped and alphabetically sorted
- **Whitespace:** Follow PEP 8 guidelines

## Type Hints

### Required Type Hints
```python
def process_data(
    input_data: list[dict[str, Any]],
    validate: bool = True
) -> pd.DataFrame:
    """Process input data and return DataFrame."""
    pass
```

### Type Hint Guidelines
- **All Public Functions:** Must have type hints
- **Return Types:** Always specify, use -> None explicitly
- **Optional:** Use Optional[T] or T | None (3.10+)
- **Collections:** Use generic types (list[str], dict[str, int])
- **Custom Types:** Define with TypeAlias or TypedDict

## Common Anti-Patterns

### Python-Specific Issues
- **Mutable Defaults:** Never use mutable default arguments
- **Bare Except:** Always specify exception types
- **Global State:** Avoid global variables
- **Star Imports:** Never use `from module import *`
- **Late Binding:** Be aware of closure gotchas

### Code Smells to Flag
- **God Classes:** Classes doing too many things
- **Long Parameter Lists:** More than 4 parameters
- **Deep Nesting:** More than 3 levels
- **Duplicate Code:** Same logic repeated (>5 lines)
- **Dead Code:** Unused imports, variables, functions
- **Print Statements:** Left in production code

## Error Handling

### Exception Patterns
- **Specific Exceptions:** Catch specific exception types
- **Custom Exceptions:** Create domain-specific exceptions
- **Error Messages:** Descriptive and actionable
- **Logging:** Use logging module, not print
- **Cleanup:** Use finally or context managers

```python
# Good
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise ProcessingError(f"Cannot process: {e}") from e

# Bad
try:
    result = risky_operation()
except:
    print("Error occurred")
```

## Performance Considerations

### Optimization Rules
- **Profile First:** Use cProfile before optimizing
- **Algorithm Choice:** Use appropriate data structures
- **Lazy Evaluation:** Generators for large datasets
- **Caching:** Use functools.cache for expensive operations
- **Vectorization:** NumPy/Pandas for numerical operations

### Memory Management
- **Generators:** For large sequences
- **Slots:** For classes with fixed attributes
- **Weak References:** When appropriate
- **Context Managers:** Ensure cleanup

## Testing Requirements

### Test Structure
- **Naming:** test_should_behavior_when_condition
- **Arrangement:** Given-When-Then or AAA pattern
- **Isolation:** Tests independent of each other
- **Fixtures:** Use pytest fixtures for setup
- **Coverage:** Minimum 80% for critical paths

### Testing Patterns
```python
def test_calculate_total_should_return_sum_with_tax():
    # Given
    items = [Item(price=10), Item(price=20)]
    tax_rate = 0.1

    # When
    total = calculate_total(items, tax_rate)

    # Then
    assert total == 33.0
```

## Documentation

### Docstring Requirements
```python
def process_transaction(
    amount: Decimal,
    account_id: str,
    transaction_type: TransactionType
) -> TransactionResult:
    """Process a financial transaction.

    Args:
        amount: Transaction amount in base currency.
        account_id: Unique identifier for the account.
        transaction_type: Type of transaction to process.

    Returns:
        Result object containing transaction status and ID.

    Raises:
        InsufficientFundsError: If account balance is too low.
        InvalidAccountError: If account_id doesn't exist.
    """
```

### Documentation Style
- **Module Docstring:** Purpose and usage
- **Class Docstring:** Responsibility and usage
- **Method Docstring:** Google style preferred
- **Inline Comments:** Only for "why", not "what"

## Common Patterns

### Data Processing
```python
# Good: Generator for memory efficiency
def process_large_file(filepath: Path) -> Iterator[ProcessedRecord]:
    with open(filepath) as f:
        for line in f:
            if record := parse_line(line):
                yield process_record(record)

# Bad: Loading everything into memory
def process_large_file(filepath: Path) -> list[ProcessedRecord]:
    with open(filepath) as f:
        lines = f.readlines()
    return [process_record(parse_line(l)) for l in lines]
```

### Configuration
```python
# Good: Dataclass for configuration
@dataclass
class Config:
    host: str
    port: int
    timeout: float = 30.0
    retries: int = 3

# Bad: Dictionary with magic strings
config = {
    'host': 'localhost',
    'port': 8080,
    'timeout': 30.0
}
```

## Framework Guidelines

### Django Patterns
- **Views:** Thin views, fat models
- **Queries:** Use select_related/prefetch_related
- **Migrations:** Review before applying
- **Settings:** Environment-specific configuration
- **Security:** Use Django's built-in protections

### FastAPI Patterns
- **Dependencies:** Use dependency injection
- **Validation:** Pydantic models for all I/O
- **Async:** Use async/await throughout
- **Documentation:** OpenAPI schema generation
- **Error Handling:** HTTP exception handlers

### Flask Patterns
- **Blueprints:** Modular application structure
- **Extensions:** Use Flask extensions properly
- **Context:** Understand application/request context
- **Configuration:** Environment-based config
- **Testing:** Use test client for integration tests

## Security Requirements

### Input Validation
- **Type Checking:** Validate types at boundaries
- **Sanitization:** Clean user input
- **SQL:** Use parameterized queries (never f-strings)
- **Command Injection:** Never use shell=True
- **Path Traversal:** Validate file paths

### Security Checklist
- [ ] No hardcoded secrets
- [ ] Input validation on all endpoints
- [ ] Parameterized database queries
- [ ] Proper authentication/authorization
- [ ] Secure random for security features
- [ ] Dependencies regularly updated

## Code Review Checklist

### Must Fix (Critical)
- [ ] Functions over 30 lines
- [ ] Missing type hints on public functions
- [ ] Mutable default arguments
- [ ] Bare except clauses
- [ ] Security vulnerabilities
- [ ] SQL injection risks

### Should Fix (Important)
- [ ] Functions over 20 lines
- [ ] More than 4 parameters
- [ ] Deep nesting (>3 levels)
- [ ] Missing error handling
- [ ] Code duplication (>5 lines)
- [ ] Print statements in production code

### Consider Fixing (Suggested)
- [ ] Complex comprehensions
- [ ] Missing docstrings
- [ ] Performance optimizations
- [ ] Additional type hints
- [ ] Test coverage gaps

## Refactoring Priorities

1. **Security Issues:** Fix immediately
2. **Bugs:** Fix before features
3. **Type Safety:** Add type hints
4. **Performance:** When measurably slow
5. **Readability:** During maintenance
6. **Structure:** During feature additions

## Python-Specific Guidelines

### Import Organization
```python
# Standard library
import json
import sys
from pathlib import Path

# Third-party
import pandas as pd
import requests
from django.db import models

# Local
from myapp.utils import helper
from myapp.models import User
```

### String Formatting
```python
# Good: f-strings (Python 3.6+)
message = f"User {user.name} logged in at {timestamp}"

# Acceptable: format method
message = "User {} logged in at {}".format(user.name, timestamp)

# Bad: % formatting (outdated)
message = "User %s logged in at %s" % (user.name, timestamp)
```

### Context Managers
```python
# Good: Context manager for resources
with open('file.txt') as f:
    content = f.read()

# Good: Multiple context managers
with open('input.txt') as fin, open('output.txt', 'w') as fout:
    fout.write(process(fin.read()))

# Bad: Manual resource management
f = open('file.txt')
content = f.read()
f.close()  # Easy to forget
```

## Exceptions

Justified complexity is acceptable when:
- Required by framework conventions
- Significant performance improvement (profiled)
- External API requirements
- Legacy system integration

Document why the exception exists and limit its scope.