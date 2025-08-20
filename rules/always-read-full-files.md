# Always Read Full Files

**ABSOLUTE RULE**: Always read complete files. NEVER use limit or offset parameters with the Read tool.

## Detection Keywords
**Primary**: read, file, partial, limit, offset, lines
**Context**: Read tool, file reading, code analysis
**Intent**: understanding code, reviewing files, analyzing structure

## The Rule

### ✅ ALWAYS Read Complete Files
```
# Correct - Read entire file for full context
Read file_path="/path/to/file.js"
```

### ❌ NEVER Use Partial Reads
```
# Wrong - Missing critical context
Read file_path="/path/to/file.js" limit=50 offset=100
```

## Why This Matters

- **Full context prevents errors** - Partial reads miss critical dependencies, imports, and related code
- **Better understanding** - Complete files show the full picture of implementation
- **Accurate analysis** - All functions, classes, and logic are visible at once

## Enforcement

When using the Read tool:
- ✅ Use only the `file_path` parameter
- ❌ Never add `limit` or `offset` parameters
- ✅ Read the whole file first, then focus on specific sections

**Remember**: Context is king. Always read the complete file.