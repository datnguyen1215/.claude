# Task Grouping Guidelines

## Core Principles

When creating tasks.md, organize tasks into **independent parallel groups**:

1. **Group Independence**: Tasks in one group CANNOT depend on tasks in another group
2. **Group Format**: Use `## Group: [Descriptive Name]` as headers
3. **Group Metadata**: Include purpose and constraints
4. **Task Organization**: Related tasks belong in the same group
5. **Parallel Thinking**: Ask "What can be done simultaneously?"

## Anti-patterns to Avoid

- ❌ **Sequential Dependencies**: Group B needs output from Group A
- ❌ **Mixed Concerns**: Unrelated tasks in one group
- ❌ **Overhead Groups**: Too many small groups (1-2 tasks)
- ❌ **Monolithic Groups**: One giant group (no parallelism)

## Best Practices for Task Groups

### Optimal Group Size
- **3-8 tasks per group**: Balanced workload
- **Avoid single-task groups**: Overhead not worth it
- **Split large groups**: If >10 tasks, consider splitting

### Verifying Independence
- Read each group in isolation
- Ask: "Can this complete without other groups?"
- Check: No "after X is done" references
- Test: Could different developers work on each group simultaneously?

### Common Grouping Patterns

#### By Layer
- Frontend / Backend / Database
- UI / API / Infrastructure
- Client / Server / Shared

#### By Feature
- Feature A / Feature B / Feature C
- User Management / Payment / Notifications
- Search / Browse / Filter

#### By Type
- Core Logic / Utilities / Tests / Documentation
- Models / Views / Controllers
- Components / Services / Repositories

#### By Operation
- Create / Read / Update / Delete
- Import / Process / Export
- Fetch / Transform / Display

## Group Dependencies Checklist

Before finalizing groups, verify:

- [ ] Each group has a clear, single purpose
- [ ] No group references tasks from another group
- [ ] Resources (files, APIs, databases) don't create hidden dependencies
- [ ] Groups could theoretically be assigned to different team members
- [ ] Completing any group provides standalone value

## Dependency Management

### Wave-Based Execution

When groups have dependencies on other groups, they are organized into **waves**:

- **Wave 1**: Groups with no dependencies (can all run in parallel)
- **Wave 2**: Groups that depend only on Wave 1 groups
- **Wave 3**: Groups that depend on Wave 1 or Wave 2 groups
- And so on...

### Declaring Dependencies

Add a `**Depends on**` field to each group:

```markdown
## Group: API Integration
**Purpose**: Connect to external services
**Depends on**: [Authentication Service, Core Infrastructure]
```

### Dependency Rules

1. **No Circular Dependencies**: Group A cannot depend on Group B if B depends on A
2. **Reference by Name**: Use exact group names in the depends_on list
3. **Empty for Independent**: Use `[]` or omit for groups with no dependencies
4. **Forward References Only**: Can only depend on groups defined earlier in the plan

### Wave Calculation Algorithm

1. Identify all groups with no dependencies → Wave 1
2. For each remaining group:
   - Find the maximum wave number of its dependencies
   - Assign to (max_wave + 1)
3. Groups in the same wave can execute in parallel
4. Start next wave only after previous wave completes

### Example Wave Organization

```
Wave 1 (Parallel):
  - Database Setup (no dependencies)
  - Authentication Service (no dependencies)
  - Core Libraries (no dependencies)

Wave 2 (Parallel, after Wave 1):
  - API Gateway (depends on: Authentication Service)
  - User Service (depends on: Database Setup, Authentication Service)

Wave 3 (After Wave 2):
  - Integration Tests (depends on: API Gateway, User Service)
  - Performance Tests (depends on: API Gateway)
```

### Benefits of Wave-Based Execution

- **Maximum Parallelism**: All groups in a wave run simultaneously
- **Clear Dependencies**: Explicit declaration prevents race conditions
- **Predictable Order**: Waves provide deterministic execution sequence
- **Easy Visualization**: Can see the flow of work at a glance

## Dependency Validation

### Validation Rules

The system validates dependencies to ensure correct execution:

#### 1. Circular Dependency Detection
- **Check**: No dependency cycles (A→B→C→A)
- **Error**: "Circular dependency detected: Group A → Group B → Group A"
- **Fix**: Restructure groups to eliminate the cycle

#### 2. Missing Group References
- **Check**: All groups in `Depends on` lists exist
- **Error**: "Unknown group 'GroupName' referenced in dependencies"
- **Fix**: Correct the group name or create the missing group

#### 3. Self-Dependencies
- **Check**: Groups cannot depend on themselves
- **Error**: "Group 'GroupName' cannot depend on itself"
- **Fix**: Remove self-reference from depends_on list

#### 4. Forward Reference Check
- **Check**: Groups can only depend on previously defined groups
- **Error**: "Forward reference: 'GroupB' referenced before definition"
- **Fix**: Reorder groups or restructure dependencies

### Validation Process

```
1. Parse all group definitions
2. Build dependency graph
3. Check for cycles using depth-first search
4. Verify all referenced groups exist
5. Calculate wave assignments
6. Report any validation errors
```

### Common Validation Errors and Solutions

| Error | Example | Solution |
|-------|---------|----------|
| Circular dependency | A→B, B→C, C→A | Merge groups or extract common dependencies |
| Missing group | Depends on: [NonExistent] | Fix typo or add missing group |
| Self-reference | Group A depends on: [A] | Remove self-dependency |
| Orphaned group | No path from Wave 1 | Ensure proper dependency chain |

### Validation Output Example

```
✅ Validation Successful:
  - 8 groups found
  - 3 waves calculated
  - No circular dependencies
  - All references valid

Wave Structure:
  Wave 1: 3 groups (Database, Auth, Core)
  Wave 2: 3 groups (API, Users, Cache)
  Wave 3: 2 groups (Tests, Monitoring)
```