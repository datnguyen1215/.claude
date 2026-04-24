# CrewDeck Issue Creator

Create issues from conversation context. Short sentences. No fluff.

**Argument:** Project name or ID (required)

## Workflow

1. **Validate** - No argument? Error: "Project name or ID required"

2. **Find project** - `git remote get-url origin` for current repo, then `GET $CREWDECK_BASE_URL/api/v1/projects` with `Authorization: Bearer $CREWDECK_API_KEY`
   - Match by ID or partial name (case-insensitive)
   - Verify repo belongs to project (`GET /api/v1/projects/:id/repos`)
   - No match: list projects, stop. Multiple: ask. Wrong repo: warn

3. **Investigate** - Read the code. Trace the paths. Know what touches what. Think about edge cases and breaking changes. For each change, also hunt:
   - **Tests** - find existing tests covering the touched code (`*test*`, `*spec*`, `__tests__/`, etc.). Note files that need updates or new coverage
   - **Docs** - grep for references in `README*`, `docs/`, inline doc comments, API references, changelogs. Note what goes stale
   - **Cleanup** - find code the change makes obsolete: dead functions, unused imports, now-unreachable branches, stale comments, feature flags, deprecated callers. List concrete paths + symbols

4. **Decompose** - Smallest shippable issues. Each one works on its own. No circular deps. Dependency order

5. **Write issues** - Each issue gets:
   - **Title:** What changes. Short
   - **Description:** Written for a dev with zero context. Clear, short sentences. No filler. Use this structure:

   ```markdown
   ## Why
   Why this exists. What's broken or missing. Be specific — file paths, function names, line numbers

   ## What
   What it should do when done. Concrete. No ambiguity

   ## How
   Exact steps. File paths. Function names. What to change where:
   1. In `path/file.ext`, change `func()` to ...
   2. Add `newFunc()` in `path/other.ext` that ...

   **Tests:** files found in investigation that need updates / new coverage. List them. Also sweep for anything missed
   **Docs:** files found that reference the old behavior. List them. Also sweep for anything missed
   **Cleanup:** obsolete code found — paths + symbols. Remove in this issue. Also sweep for anything missed

   ## Risks
   Side effects. Breaking changes. Edge cases. Skip if none

   ## Done when
   Testable conditions that prove it works
   ```

   Skip Risks if there are none. No empty sections. Tests/Docs/Cleanup must list what investigation found — if truly none, write "None found — sweep anyway"

6. **Create** - `POST $CREWDECK_BASE_URL/api/v1/projects/:id/issues` with `Authorization: Bearer $CREWDECK_API_KEY`
   ```json
   { "title": "...", "description": "..." }
   ```
   Dependencies first. Wire up IDs from responses into subsequent descriptions

7. **Confirm** - Summary table: ID, title, dependency chain
