# Drizzle ORM Standards

## Purpose

Technical standards and best practices for Drizzle ORM database management. Schema-as-code patterns, migration workflows, type-safe queries, and framework integration.

## Core Concepts

### Schema Definition

**Dialect-Specific Tables**:

- PostgreSQL: Use `pgTable` from `drizzle-orm/pg-core`
- MySQL: Use `mysqlTable` from `drizzle-orm/mysql-core`
- SQLite: Use `sqliteTable` from `drizzle-orm/sqlite-core`

**Identity Columns (Preferred)**:

- Use `integer().generatedAlwaysAsIdentity()` for auto-incrementing IDs
- Replaces older `serial()` pattern
- More explicit and standards-compliant

**Reusable Column Patterns**:

- Extract common columns (timestamps, audit fields) into shared objects
- Use spread operator to include in table definitions
- Maintains consistency across schema

**Type Safety Requirements**:

- Use `InferSelectModel` and `InferInsertModel` for type extraction
- Insert types make auto-generated fields optional
- Select types include all fields as required
- Define types immediately after table definitions

### Configuration Standards

**drizzle.config.ts Structure**:

- Required: `dialect`, `schema`, `out`
- Connection: Use `dbCredentials` object or connection string
- Schema: Support glob patterns for multiple files
- Output: Default `./drizzle` for migrations

**Connection Management**:

- Use connection pooling for production
- Configure pool size, timeouts, SSL appropriately
- Use environment variables for credentials
- Never commit credentials to version control

**Development HMR Pattern**:

- Persist db client on global object in development
- Prevents connection pool exhaustion during hot reload
- Check `process.env.NODE_ENV` to conditionally apply

## Migration Workflows

### Development Workflow

**Push Approach** (Rapid Iteration):

- Use `drizzle-kit push` for quick schema changes
- No migration files generated
- Ideal for solo developers and prototyping
- Changes immediately reflected in database

### Production Workflow

**Generate and Migrate** (Version Control):

1. Make schema changes in code
2. Run `drizzle-kit generate` to create SQL migration
3. Review generated SQL in `drizzle` folder
4. Test migration in staging environment
5. Apply with `drizzle-kit migrate` or runtime migrator

**Migration Safety**:

- Never modify migration history manually
- Review all generated migrations before applying
- Test destructive changes (drops, renames) carefully
- Maintain sequential migration ordering
- Keep meta folder in version control

### Runtime Migrations

**Application Startup Pattern**:

- Import `migrate` from appropriate driver migrator
- Run migrations on application boot
- Ensure single instance runs migrations in distributed systems
- Handle migration failures gracefully

## CRUD Patterns

### Insert Operations

**Single Insert**:

- Use `db.insert(table).values(data)`
- Add `.returning()` to get inserted record
- Use `.$returningId()` for ID only

**Bulk Insert**:

- Pass array to `.values()` for multiple records
- Consider transaction for large batches
- Use prepared statements for repeated operations

**Upsert Pattern**:

- Use `.onConflictDoUpdate()` for insert-or-update
- Specify conflict target explicitly
- Define update behavior

### Update Operations

**Conditional Updates**:

- Always use `.where()` to limit scope
- Use SQL expressions with `sql` tag for computed updates
- Add `.returning()` to get updated records

**Batch Updates**:

- Use transactions for consistency
- Consider prepared statements for performance

### Delete Operations

**Scoped Deletes**:

- Always use `.where()` unless intentionally deleting all
- Use cascade rules in foreign keys when appropriate
- Consider soft deletes for audit requirements

### Select Operations

**Partial Selection**:

- Use object in `.select()` to choose specific fields
- Reduces data transfer and improves performance
- Maintains type safety for selected fields

**Filtering and Ordering**:

- Import operators from `drizzle-orm`
- Chain `.where()`, `.orderBy()`, `.limit()`, `.offset()`
- Use type-safe operators: `eq`, `gt`, `lt`, `and`, `or`

## Relations and Joins

### Defining Relations

**One-to-One**:

- Use `relations()` helper with `one()` reference
- Define bidirectional relationships separately
- Specify fields and references explicitly

**One-to-Many**:

- Parent uses `many()`, child uses `one()`
- Child table contains foreign key column
- Use `.references()` in column definition

**Many-to-Many**:

- Create junction table with composite primary key
- Both sides use `many()` to junction table
- Junction table contains foreign keys to both tables

### Relational Queries

**Nested Data Fetching**:

- Use `db.query.table.findMany()` syntax
- Specify `with` object for nested relations
- Support infinite nesting depth
- Apply filters and limits to nested queries

**Partial Relation Loading**:

- Use `columns` to select specific fields
- Combine with `with` for nested selection
- Reduces payload size

## Transactions

### Basic Transactions

**Transaction Callback Pattern**:

- Use `db.transaction(async (tx) => { ... })`
- All operations use `tx` instead of `db`
- Automatic rollback on error
- Automatic commit on success

### Rollback Control

**Manual Rollback**:

- Call `tx.rollback()` to abort transaction
- Use for conditional transaction logic
- Stops execution immediately

### Nested Transactions

**Savepoint Support**:

- Nest `tx.transaction()` for savepoints
- Inner transaction can rollback independently
- Outer transaction controls final commit

## Performance Optimization

### Prepared Statements

**Reusable Queries**:

- Use `.prepare('name')` for frequently executed queries
- Define placeholders with `sql.placeholder('name')`
- Execute with `.execute({ params })`
- Improves performance through query plan caching

### Selective Loading

**Field Limitation**:

- Only select necessary columns
- Especially important for large text/blob fields
- Use partial selection in production

**Batch Operations**:

- Use `db.batch([queries])` for multiple independent queries
- Executes in single round trip
- Returns array of results

### Connection Pooling

**Pool Configuration**:

- Set appropriate `max` connections (typically 10-20)
- Configure idle timeout to release connections
- Set connection timeout for failure handling
- Monitor pool utilization

## Validation Integration

### Schema Validation

**Drizzle-Zod Pattern**:

- Use `createInsertSchema` and `createSelectSchema`
- Extend with additional Zod refinements
- Validate before database operations
- Extract types with `z.infer`

**Drizzle-Valibot Alternative**:

- Use for smaller bundle size
- Same pattern as Zod integration
- Choose based on project dependencies

## Error Handling

### Database Errors

**PostgreSQL Error Codes**:

- Catch `DrizzleQueryError` for query failures
- Check `error.cause` for underlying database error
- Handle common codes: `23505` (unique), `23503` (foreign key), `23502` (not null)
- Provide user-friendly error messages

**Error Patterns**:

- Wrap operations in try-catch
- Log errors with context
- Return meaningful error responses
- Never expose raw database errors to users

## Framework Integration

### SvelteKit Pattern

**Database Setup**:

- Create `src/lib/server/db.ts` for database instance
- Import schema and create drizzle instance
- Use `$env/static/private` for credentials
- Never import in client-side code

**Server-Side Usage**:

- Import db in `+page.server.ts` and `+server.ts` files
- Use in `load` functions for data fetching
- Use in form actions for mutations
- Return serializable data only

### Next.js Pattern

**Database Setup**:

- Create `lib/db.ts` or `db/index.ts`
- Use appropriate driver for deployment target
- Configure for serverless if needed

**Server Components**:

- Import and use db directly in async components
- No API route needed for data fetching
- Automatic request deduplication

**API Routes**:

- Import db in route handlers
- Return JSON responses
- Handle errors appropriately

### Serverless Environments

**Edge-Compatible Drivers**:

- Use HTTP-based drivers (Neon, PlanetScale serverless)
- Avoid TCP-based connections on edge runtimes
- Use `drizzle-orm/neon-http` or similar

**Cold Start Optimization**:

- Minimize bundle size
- Use lazy initialization when possible
- Consider connection pooling services

## Common Patterns

### Seed Data

**Manual Seeding**:

- Create dedicated seed script
- Use transactions for consistency
- Make idempotent when possible
- Document seed data purpose

**Drizzle Seed Library**:

- Use `drizzle-seed` for test data generation
- Define data relationships
- Generate realistic fake data
- Useful for development and testing

### Schema Organization

**Single File** (Small Projects):

- Keep all tables in one `schema.ts`
- Simple to navigate
- Good for < 10 tables

**Multiple Files** (Large Projects):

- Separate by domain or feature
- Create `schema/index.ts` to export all
- Maintain clear separation
- Scale to hundreds of tables

**Shared Columns**:

- Extract common patterns (timestamps, audit)
- Create separate file for shared definitions
- Import and spread into table definitions

### Indexes and Constraints

**Index Definitions**:

- Define in second parameter callback
- Use `index()` for regular indexes
- Use `uniqueIndex()` for unique constraints
- Support composite indexes

**Foreign Keys**:

- Define inline with `.references()`
- Specify cascade behavior with options
- Use composite foreign keys when needed

**Check Constraints**:

- Use `check()` in table callback
- Define with `sql` tag
- Validate data at database level

## Best Practices

### Schema Design

- Use identity columns for primary keys
- Define NOT NULL constraints explicitly
- Add indexes for foreign keys
- Use enums for fixed value sets
- Keep context flat when possible
- Document complex relationships

### Migration Management

- Review generated SQL before applying
- Test migrations in development first
- Never edit migration files after applying
- Keep migrations small and focused
- Use descriptive migration names

### Query Optimization

- Use prepared statements for repeated queries
- Limit selected columns to necessary fields
- Add indexes for frequently queried columns
- Use transactions for multi-step operations
- Batch independent operations

### Type Safety

- Extract types immediately after table definitions
- Use inferred types throughout application
- Avoid type assertions
- Leverage TypeScript strict mode

### Security

- Parameterize all queries (built-in protection)
- Validate input before database operations
- Use environment variables for credentials
- Implement row-level security when needed
- Never expose raw errors to users

## Anti-Patterns to Avoid

### Schema Issues

- Using `serial()` instead of `generatedAlwaysAsIdentity()`
- Missing NOT NULL constraints
- Circular foreign key dependencies
- Over-normalization or under-normalization
- Inconsistent naming conventions

### Migration Issues

- Modifying applied migrations
- Skipping migration review
- Applying untested migrations to production
- Mixing push and generate workflows
- Deleting migration history

### Query Issues

- Selecting unnecessary columns
- N+1 query problems (use relations)
- Missing indexes on filtered columns
- Not using prepared statements for repeated queries
- Ignoring transaction boundaries

### Integration Issues

- Importing database in client code
- Not using connection pooling
- Hardcoding credentials
- Exposing database errors to users
- Not handling connection failures

## Code Review Checklist

### Must Fix (Critical)

- [ ] Credentials in code
- [ ] Missing NOT NULL on required fields
- [ ] No WHERE clause on updates/deletes (unless intentional)
- [ ] Database imports in client-side code
- [ ] Modified applied migrations
- [ ] Missing error handling
- [ ] SQL injection vulnerabilities (if using raw SQL)

### Should Fix (Important)

- [ ] Using serial() instead of generatedAlwaysAsIdentity()
- [ ] Missing indexes on foreign keys
- [ ] No connection pooling in production
- [ ] Selecting unnecessary columns
- [ ] Not using prepared statements for repeated queries
- [ ] Missing validation before mutations
- [ ] Inconsistent naming conventions

### Consider Fixing (Suggested)

- [ ] Missing relations definitions
- [ ] No schema documentation
- [ ] Duplicate column definitions
- [ ] Complex queries without comments
- [ ] Missing transaction for multi-step operations
- [ ] No seed data for development

## Exceptions

Justified complexity is acceptable when:

- Framework or hosting platform requirements
- Significant performance improvement (measured)
- Legacy system constraints
- Specific database feature requirements

Document why the exception exists and contain its scope.
