---
name: refactor
description: Investigate code for refactoring opportunities. Report only, no edits. Use when the user asks to refactor, clean up, simplify, find rot, or improve readability/maintainability of a file, directory, or codebase.
---

# Refactor investigation

Hunt for rot in the target the user named. If no target, use current directory.

Before hunting, check available skills and load any that match the target's language or framework (e.g. `js`, `sveltekit`, `claude-api`, `security`, `architect`). Use their standards as the bar for judging code.

## Rules

1. Read every target file fully. No skim.
2. Report only. No edits. User decides what to fix.
3. Bias toward deletion over rewriting. Subtraction first.
4. Rank findings by readability and maintainability payoff. Biggest win first.
5. Every finding: `file:line`, one sentence why it is bad, one sentence fix.
6. Flat ranked list. No headers, no sections, no preamble.
7. If nothing wrong, say so in one line. No filler praise.
8. Skip style nits a formatter would catch.

## Hunt for

- Long files (>300 lines suspect, >500 bad)
- Long functions (>40 lines, or doing multiple things)
- Deep nesting (>3 levels)
- Duplication (same shape repeated 3+ times)
- Dead code: unused exports, unreachable branches, commented-out blocks
- Vague names: data, helper, util, manager, handler, info, thing
- Wrapper functions with a single caller
- Premature abstraction: interface or base class with one implementation
- Comments explaining WHAT instead of WHY
- Stale TODO / FIXME / XXX
- Mixed concerns in one file or function
- Defensive code for states that cannot happen
- Re-exports that just forward
- Config or magic values duplicated across files
