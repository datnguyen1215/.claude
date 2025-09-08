# Task Format Guidelines

## Individual Task Structure

```markdown
- [ ] Task description (clear, actionable verb)
  - **Acceptance**: Specific criteria for completion
  - **Notes**: Implementation hints, dependencies, or considerations
```

## Task Writing Best Practices

### Good Task Descriptions
✅ "Implement user authentication with JWT"
✅ "Refactor payment service to use strategy pattern"
✅ "Add input validation to registration form"
✅ "Create unit tests for cart calculations"

### Poor Task Descriptions
❌ "Fix stuff" (too vague)
❌ "Work on frontend" (not specific)
❌ "Make it better" (no clear outcome)
❌ "Do the thing we discussed" (lacks context)

## Acceptance Criteria Format

### Specific and Measurable
- **Good**: "All API endpoints return proper HTTP status codes"
- **Poor**: "API works correctly"

### Testable
- **Good**: "Unit tests achieve 80% code coverage"
- **Poor**: "Code is tested"

### Clear Definition of Done
- **Good**: "Migration script runs without errors on staging database"
- **Poor**: "Database is updated"

## Task Metadata

### Priority Indicators (Optional)
- 🔴 Critical - Blocks other work
- 🟡 Important - Core functionality
- 🟢 Nice-to-have - Enhancements

### Effort Estimates (Optional)
- **XS**: < 1 hour
- **S**: 1-2 hours
- **M**: 2-4 hours
- **L**: 4-8 hours
- **XL**: > 8 hours (consider breaking down)

### Dependencies (When Necessary)
- **Requires**: External service API key
- **Blocked by**: Design approval needed
- **Depends on**: Database migration completed

## Complete Task Example

```markdown
- [ ] Implement password reset flow
  - **Acceptance**:
    - User can request reset via email
    - Token expires after 1 hour
    - Old password invalidated on successful reset
    - Email template renders correctly
  - **Notes**:
    - Use existing email service
    - Follow OWASP guidelines for tokens
    - Add rate limiting (max 3 requests per hour)
  - **Effort**: M (3 hours)
  - **Priority**: 🔴 Critical
```