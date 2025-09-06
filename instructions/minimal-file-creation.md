# Minimal File Creation Standard

Every file must be absolutely necessary and include a clear description of its purpose.

## Universal Rules

1. **Only create files that are essential** - Modify existing files when possible
2. **Every file needs a header** - 1-2 sentences explaining what it does and why
3. **Start minimal** - Add only what's immediately needed
4. **Use descriptive names** - Avoid generic names like "utils" or "helpers"

## File-Specific Standards

### JavaScript (.js, .mjs, .jsx, .ts, .tsx)
```javascript
/**
 * [Concise description of what this file does and why]
 */
```
- No unused imports, variables, or console.logs
- Prefer pure functions over classes
- No commented-out code or TODO sections

### Python (.py)
```python
"""
[Concise description of what this file does and why]
"""
```
- Follow PEP 8 with minimal lines
- Functions over classes unless state is needed
- No placeholder `pass` statements or unused imports

### Markdown (.md)
```markdown
# [Title]

[Brief description of what this document covers]

---
```
- No boilerplate or "Coming Soon" sections
- Bullet points over paragraphs
- Only essential information

## Pre-Creation Checklist
- [ ] Is this file absolutely necessary?
- [ ] Can I modify an existing file instead?
- [ ] Does it have a clear, single purpose?
- [ ] Is the header description included?