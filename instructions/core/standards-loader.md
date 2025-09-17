# Standards Loader

## Automatic Standards Detection and Loading

### Language Identification

When encountering code files or code-related tasks, identify the programming language through:

- File extension analysis
- Content pattern recognition
- Explicit language declarations in file headers
- Context from surrounding files in the project

### Standards Mapping

Upon language identification, immediately load the corresponding standards from the Instructions Index:

#### JavaScript/TypeScript Files

When detecting files with extensions `.js`, `.jsx`, `.ts`, `.tsx`, `.mjs`, `.cjs`:

- Load instructions from `~/.claude/instructions/standards/javascript.md`
- Apply all JavaScript/TypeScript conventions and patterns
- Maintain these standards throughout the session until context changes

#### Python Files

When detecting files with extensions `.py`, `.pyi`, `.pyw`:

- Load instructions from `~/.claude/instructions/standards/python.md`
- Apply all Python conventions and idioms
- Maintain these standards throughout the session until context changes

#### Svelte Files

When detecting files with extensions `.svelte`:

- Load instructions from `~/.claude/instructions/standards/svelte.md`
- Apply all Svelte-specific patterns and conventions
- Maintain these standards throughout the session until context changes

### Application Rules

#### Immediate Application

Upon detecting a language, load the standards immediately without waiting for explicit request. The standards become active constraints on all subsequent operations.

#### Persistent Application

Once loaded, continue applying the standards for:

- All file modifications in that language
- New file creation in that language
- Code review and analysis tasks
- Refactoring operations
- Bug fixes and enhancements

#### Context Switching

When switching between files of different languages:

- Maintain all previously loaded standards
- Add new standards for newly encountered languages
- Apply the appropriate standard based on the current file context

#### Multi-Language Projects

In projects with multiple languages:

- Load all relevant standards as encountered
- Apply each standard to its respective language context
- Maintain separation between language-specific rules

### Loading Priority

1. Always load language-specific standards before beginning any code operation
2. If multiple languages are present, load all applicable standards
3. When standards conflict, prioritize based on the current file being modified
4. Maintain all loaded standards in memory for the session duration

### Standard Application Verification

After loading standards:

- Confirm standards are applied to all code operations
- Ensure new code follows loaded conventions
- Verify existing code modifications maintain consistency
- Check that all language-specific patterns are respected
