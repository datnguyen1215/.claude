---
description: "Execute implementation based on architectural plan using parallel agents"
argument-hint: "[architectural plan or reference]"
allowed-tools:
  ["Read", "Bash", "Glob", "Grep", "Task", "TodoWrite"]
---

You are in IMPLEMENTATION MODE.

## Primary Objective
Execute implementation using specialized agents working in parallel based on the architectural plan.

## Workflow

### Phase 1: Agent Discovery & Plan Analysis
1. **Discover Available Agents**
   - Check Claude Code for available agents
   - Identify implementation-focused agents (engineer, developer types)
   - Map agents to different components/tasks

2. **Analyze the Plan**
   - Understand architectural decisions
   - Identify independent components that can be built in parallel
   - Group related tasks that share dependencies
   - Create separation boundaries to prevent conflicts

### Phase 2: File-Based Task Distribution
1. **Extract Files from Plan**
   - Identify ALL files to be created/modified from the architectural plan
   - Each file becomes a separate work unit for ONE agent
   - The plan already specifies what each file should contain
   - Create a mapping: one agent per file

2. **File Assignment Structure**
   ```
   Agent 1 → /src/components/UserProfile.tsx
   - Implement complete file based on plan specifications

   Agent 2 → /src/api/userRoutes.js
   - Implement complete file based on plan specifications

   Agent 3 → /src/models/User.js
   - Implement complete file based on plan specifications

   Agent 4 → /src/utils/validation.js
   - Implement complete file based on plan specifications

   [Continue for all files in the plan...]
   ```

### Phase 3: Parallel Agent Execution
1. **Simultaneous Agent Invocation**
   - **CRITICAL**: Invoke multiple agents IN THE SAME MESSAGE using multiple Task tool calls
   - Each agent gets EXACTLY ONE FILE to implement
   - The architectural plan already contains complete specifications
   - No coordination needed between agents - each works independently

2. **Agent Prompt Template (Per File)**
   ```
   "Implement the file: [exact file path]

   Based on this specification from the architectural plan:
   [Exact specifications for this file from the plan]

   IMPORTANT:
   - You are ONLY responsible for this ONE file
   - The plan already specifies exactly what to implement
   - Read existing codebase patterns first
   - Implement the complete file according to the specifications
   - Do NOT modify any other files"
   ```

### Phase 4: Coordination & Integration
1. **Monitor Progress**
   - Track completion of each agent's tasks
   - Ensure no file conflicts occurred
   - Verify architectural boundaries maintained

2. **Integration Phase**
   - After parallel work completes, integrate components
   - Resolve any integration issues
   - Run final validation and checks

## Parallel Execution Rules

### Agent Coordination
1. **ALWAYS invoke multiple agents in ONE message** - Use multiple Task tool calls in the same response
2. **Clear Boundaries** - Each agent must have explicit file ownership
3. **No Overlapping Work** - Agents must work on different files/components
4. **Independent Tasks** - Only parallelize truly independent work

### File-Based Execution Strategy
1. **One Agent Per File**: Each agent owns exactly one file
2. **Complete Specifications**: Plan already contains full implementation details
3. **True Parallelism**: No dependencies between agents working on different files
4. **No Conflicts**: Each agent has exclusive ownership of their file

### Example Parallel Invocation
```
[Single message with multiple Task tool calls]
- Task 1: Agent implements /src/components/Header.tsx
- Task 2: Agent implements /src/components/Footer.tsx
- Task 3: Agent implements /src/api/auth.js
- Task 4: Agent implements /src/models/User.js
- Task 5: Agent implements /src/utils/helpers.js
[All invoked simultaneously in the same message - can be 10+ agents at once]
```

## Critical Guidelines
- **DISCOVER agents first** - Always check what's available
- **ONE FILE PER AGENT** - Each agent implements exactly one file
- **INVOKE IN PARALLEL** - Multiple Task calls in one message (can be 10+ agents)
- **PLAN HAS EVERYTHING** - The architectural plan already contains complete specifications
- **NO COORDINATION NEEDED** - Each agent works independently on their file
- **FOLLOW THE PLAN** - Agents implement exactly what's specified
- **NO DIRECT IMPLEMENTATION** - You orchestrate; agents implement

## Success Criteria
Implementation is complete when:
1. All files from the plan are implemented
2. Each agent successfully completes their assigned file
3. All files follow the architectural specifications
4. Integration between files works as designed
5. Build and validation checks pass

## Important Notes
- You are the ORCHESTRATOR, not the implementer
- ALWAYS use agents for actual code writing
- Your role is to coordinate, monitor, and ensure quality
- Focus on parallel execution for maximum efficiency
- MAINTAIN existing code conventions
- TRACK progress with TodoWrite
- VALIDATE implementation against plan
- RUN checks after implementation

## Success Criteria
Implementation is complete when:
1. All plan components are implemented
2. Code follows existing patterns
3. Build and checks pass
4. Architectural integrity is maintained
5. All todos are marked complete

Remember: You are IMPLEMENTING based on an existing plan. Stay focused on execution, not re-architecting.