# Hierarchical State Machine (HSMJS) Implementation Guidelines

Complete reference for implementing state machines using @datnguyen1215/hsmjs library. Load this instruction when working with state management, complex UI flows, event-driven logic, or multi-step processes.

## Core Functions Reference

### createMachine(config, options)

**config parameter structure**:

- `id`: String identifier for the machine
- `initial`: String name of the initial state
- `context`: Object containing initial context data
- `states`: Object defining all states and their configurations

**options parameter structure**:

- `actions`: Object mapping action names to functions
- `guards`: Object mapping guard names to condition functions
- `historySize`: Number specifying history stack size (default 50)

### assign(updates)

**updates parameter**: Object or function

- When object: Static key-value pairs for context updates
- When function: Receives `{context, event, machine}` and returns update object
- Multiple properties can be updated simultaneously
- Each property can be static value or computed function

## State Definition Syntax

### State Configuration Properties

- `entry`: Array of actions to execute when entering state
- `exit`: Array of actions to execute when leaving state
- `on`: Object defining event handlers
- `initial`: String for nested states' initial child
- `states`: Object containing nested state definitions
- `id`: Optional string for state identification in transitions

### Transition Configuration

**Simple form**: String target state name

**Object form properties**:

- `target`: String state name or ID reference
- `cond`: Guard function or named guard string
- `actions`: Array of actions to execute

**Array form**: Multiple transition options with conditions (first match wins)

## Machine Methods

### send(eventName, payload)

- `eventName`: String event identifier
- `payload`: Optional object with event data
- Returns: Promise resolving to `{state, context, results}`

### sendPriority(eventName, payload)

- Same parameters as `send`
- Clears event queue before processing
- Use for emergency/critical events

### clearQueue()

- No parameters
- Returns: Array of cleared events
- Empties pending event queue

### matches(stateValue)

- `stateValue`: String state name or dot-notation path
- Returns: Boolean indicating current state match
- Supports nested state checking with dot notation

### subscribe(callback)

- `callback`: Function receiving `{previousState, nextState, event}` object
  - `previousState`: Object with `{state, context}` before transition
  - `nextState`: Object with `{state, context}` after transition
  - `event`: Object with `{type, ...payload}` that triggered transition
- Returns: Unsubscribe function
- Executes on every state change

**Example**:

```typescript
machine.subscribe(({ previousState, nextState, event }) => {
  console.log(`${previousState.state} -> ${nextState.state} (${event.type})`);
  syncState(nextState.state, nextState.context);
});
```

### restore(snapshot)

- `snapshot`: Object with `{state, context}` properties
- Returns: Promise after restoration
- Restores machine to previous state

### validate()

- No parameters
- Returns: Object with `valid` boolean and `errors`/`warnings` arrays
- Checks configuration integrity

### visualize(options)

- `options`: Optional object with:
  - `type`: String 'mermaid' or 'plantuml'
  - `direction`: String for diagram direction (LR, TB, etc.)
- Returns: String diagram representation

## Event Handler Patterns

### Guard Functions

- Receive: `{context, event, machine}` object
- Return: Boolean for transition approval
- Can be inline or named reference

### Action Functions

- Receive: `{context, event, machine}` object
- Return: Void or Promise for async
- Can modify external systems or trigger side effects

## Special Syntax Elements

### Wildcard Events

- Use `'*'` as event name to catch unhandled events
- Processes after specific event handlers
- Useful for logging or fallback behavior

### Relative Targets

- Prefix with `.` for relative state navigation
- Use `#stateid` for ID-based navigation
- Empty target for self-transitions

### History Access

- `machine.history`: Array of state snapshots
- `machine.historySize`: Current history length
- `machine.snapshot`: Current state snapshot

## Context Update Patterns

- **Static updates**: Direct value assignment
- **Computed updates**: Function-based calculations
- **Event-based updates**: Using event payload data
- **Nested object updates**: Spread operator patterns
- **Array manipulations**: Push, filter, map operations

## Usage Guidelines

### When to Use State Machines

- Complex UI flows with multiple states
- Clear transition rules between states
- Need for state history/undo functionality
- Visual debugging requirements
- Predictable state management needs

### Best Practices

- Use SCREAMING_SNAKE_CASE for events
- camelCase for state names
- Group related states hierarchically
- Keep context flat when possible
- Name actions and guards descriptively
- Validate configuration during development
- Use visualization for documentation

## Guards vs Multiple Transition Targets

### When to Use Guards

**Single Guard Scenarios**:

- Simple boolean conditions based on context
- Permission/authorization checks
- Data validation before transition
- Feature flags or configuration checks

**Guard Advantages**:

- Keeps transition logic close to state definition
- Reusable through named guards
- Clear separation of condition from action
- Better for binary decisions

### When to Use Multiple Transition Targets

**Multiple Target Scenarios**:

- Different destinations based on data types
- Response status codes (success/error/pending)
- User role-based navigation
- Multi-path workflows

**Multiple Target Advantages**:

- More readable for 3+ possible outcomes
- Explicit fallback handling
- Clear priority ordering (first match wins)
- Better for switch-like logic

### Decision Guidelines

- Use guards when: Single condition determines proceed/block
- Use multiple targets when: Same event leads to different states
- Combine both when: Complex conditions with multiple outcomes
- Consider readability: Multiple targets often clearer for many branches

## Machine Composition Patterns

### Splitting Strategies

#### By Feature Domain

- Create separate machines for distinct features
- Communication via parent orchestrator
- Each machine maintains its own context
- Parent coordinates through events

#### By Complexity Level

- **Root Machine**: Navigation and routing
- **Feature Machines**: Business logic per feature
- **UI Machines**: Component-specific states
- **Utility Machines**: Shared behaviors (auth, data fetching)

#### By Lifecycle

- **Session Machine**: User session management
- **Process Machines**: Multi-step workflows
- **Component Machines**: UI component states
- **Service Machines**: External service interactions

### Composition Techniques

#### Parent-Child Hierarchy

- Parent machine contains child machines as nested states
- Children inherit parent context access
- Events bubble up from children to parent
- Parent can send events to specific children

#### Sibling Coordination

Machines at same level communicate through:

- Shared event bus
- Parent machine as mediator
- Direct machine references
- Global state synchronization

#### Service Pattern

- Stateless utility machines for common operations
- Invoked by multiple consumer machines
- Return results through callbacks or promises
- Examples: API calls, validation, calculations

### Communication Patterns

#### Event Forwarding

- Parent listens to child events
- Forwards relevant events to other children
- Transforms events between machine boundaries
- Maintains loose coupling

#### Context Sharing

- Selective context exposure
- Read-only context references
- Context synchronization points
- Avoiding circular dependencies

#### State Aggregation

- Combine multiple machine states
- Create derived state from multiple sources
- Maintain single source of truth
- Update propagation strategies

## Architectural Guidelines

### Machine Size Indicators

**Too Large When**:

- More than 7-10 top-level states
- Context object exceeds 10-15 properties
- Single file exceeds 300-400 lines
- Difficult to visualize entire flow
- Multiple unrelated concerns

**Split When You See**:

- Repeated state patterns
- Independent feature areas
- Different update frequencies
- Separate error handling needs
- Distinct user permissions

### Refactoring Approach

1. Identify cohesive state groups
2. Extract shared behavior into services
3. Define clear machine boundaries
4. Establish communication protocol
5. Implement parent coordinator if needed
6. Validate inter-machine events

### Performance Considerations

- Minimize cross-machine subscriptions
- Batch related state updates
- Use lazy initialization for child machines
- Clear unused history periodically
- Optimize context update frequency

## Implementation Checklist

### Before Creating a Machine

- Define all possible states
- Map out all transitions
- Identify shared behaviors
- Determine context structure
- Plan machine boundaries

### During Implementation

- Start with flat structure, nest later
- Implement guards before actions
- Add validation early
- Test transitions incrementally
- Document complex logic

### After Implementation

- Validate configuration
- Generate visualization
- Review state reachability
- Check for redundant transitions
- Optimize performance hotspots

## Event Naming Conventions

- **User Actions**: USER_CLICK, USER_INPUT, USER_SUBMIT
- **System Events**: SYSTEM_READY, SYSTEM_ERROR, SYSTEM_TIMEOUT
- **Data Events**: DATA_LOADED, DATA_SAVED, DATA_DELETED
- **Navigation**: NAVIGATE_BACK, NAVIGATE_FORWARD, NAVIGATE_TO
- **Lifecycle**: INIT, READY, CLEANUP, DISPOSE

## State Naming Patterns

- **Loading States**: idle, loading, loaded, error
- **Form States**: pristine, dirty, validating, submitting, submitted
- **Connection States**: disconnected, connecting, connected, reconnecting
- **Process States**: pending, processing, completed, failed
- **UI States**: closed, opening, open, closing

## Common Anti-Patterns to Avoid

- Creating machines for simple boolean toggles
- Over-nesting states beyond 3 levels
- Mixing UI state with business logic state
- Circular state dependencies
- Unbounded context growth
- Missing error states
- Ignoring validation warnings
