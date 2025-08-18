# Parallel Execution & Batchtools Operations

## Detection Keywords
**Primary**: batch, parallel, concurrent, multiple, simultaneous
**Context**: TodoWrite, Task tool, agents, swarm, coordination
**Intent**: spawn multiple, run together, execute simultaneously
**Negative**: single, sequential, one at a time

## When This Rule Applies
- Multiple TodoWrite operations needed
- Spawning multiple Task agents
- Concurrent file operations
- Parallel command execution
- Swarm coordination tasks

## 🚨 CRITICAL: Mandatory Session Cleanup After Operations

**ABSOLUTE RULE**: All concurrent operations MUST run in named tmux sessions AND sessions MUST be cleaned up after completion - NO EXCEPTIONS!

### 🧹 MANDATORY SESSION LIFECYCLE
1. **CREATE** → Named tmux session with operations
2. **EXECUTE** → Run concurrent operations with logging
3. **CAPTURE** → Save all logs before cleanup
4. **CLEANUP** → Kill session and validate removal

## 🚀 CRITICAL: Use Tmux for Concurrent Operations

**RULE**: All concurrent operations MUST run in named tmux sessions for proper logging and monitoring.

## 📋 Session Naming Convention

Use descriptive, unique names with timestamp:
```bash
# Format: project-operation-timestamp
session_name="myapp-dev-$(date +%Y%m%d-%H%M%S)"
session_name="api-build-$(date +%Y%m%d-%H%M%S)"  
session_name="frontend-test-$(date +%Y%m%d-%H%M%S)"
```

## 🔧 Quick Setup Commands

### Create Session with Multiple Panes
```bash
# Create session and split into panes
tmux new-session -d -s "myapp-dev-$(date +%Y%m%d-%H%M%S)"
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
tmux split-window -v

# Send commands to each pane
tmux send-keys -t 0 'npm run dev' Enter
tmux send-keys -t 1 'npm run api' Enter  
tmux send-keys -t 2 'npm run test:watch' Enter
tmux send-keys -t 3 'npm run build:watch' Enter
```

### One-Liner Setup
```bash
# Quick 4-pane development session
session="dev-$(date +%Y%m%d-%H%M%S)" && tmux new-session -d -s "$session" \; split-window -h \; split-window -v \; select-pane -t 0 \; split-window -v \; send-keys -t 0 'npm run dev' Enter \; send-keys -t 1 'npm run api' Enter \; send-keys -t 2 'npm test' Enter \; send-keys -t 3 'npm run build' Enter \; attach-session -t "$session"
```

## 📊 Monitor and Retrieve Logs

### Attach to Running Session
```bash
# List all sessions
tmux list-sessions

# Attach to specific session
tmux attach-session -t myapp-dev-20241230-143022
```

### Capture Logs from Panes
```bash
# Capture pane output to file
tmux capture-pane -t myapp-dev-20241230-143022:0 -p > dev-server.log
tmux capture-pane -t myapp-dev-20241230-143022:1 -p > api-server.log
tmux capture-pane -t myapp-dev-20241230-143022:2 -p > test-results.log

# Capture all panes at once
for i in {0..3}; do
  tmux capture-pane -t "myapp-dev-20241230-143022:$i" -p > "pane-$i.log"
done
```

### Real-time Log Monitoring
```bash
# Watch logs in real-time
tmux capture-pane -t myapp-dev-20241230-143022:0 -p | tail -f

# Monitor specific pane
tmux send-keys -t myapp-dev-20241230-143022:0 'tail -f server.log' Enter
```

## 🎯 Common Concurrent Patterns

### Development Stack
```bash
session="fullstack-$(date +%Y%m%d-%H%M%S)"
tmux new-session -d -s "$session"
tmux send-keys 'npm run dev' Enter
tmux split-window -h
tmux send-keys 'npm run api:dev' Enter
tmux split-window -v
tmux send-keys 'npm run db:dev' Enter
tmux select-pane -t 0
tmux split-window -v
tmux send-keys 'npm run test:watch' Enter
```

### Build Pipeline
```bash
session="build-$(date +%Y%m%d-%H%M%S)"
tmux new-session -d -s "$session"
tmux send-keys 'npm run build:frontend' Enter
tmux split-window -h
tmux send-keys 'npm run build:backend' Enter
tmux split-window -v
tmux send-keys 'npm run test:all' Enter
```

## 🧹 MANDATORY SESSION CLEANUP

**RULE**: Always cleanup tmux sessions after operations complete.

### Required Cleanup Steps
```bash
# 1. Capture logs before cleanup
session_name="myapp-dev-20241230-143022"
log_dir="logs/session-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$log_dir"

# Save all pane outputs
tmux list-panes -t "$session_name" -F "#{pane_index}" | while read pane; do
    tmux capture-pane -t "$session_name:$pane" -p > "$log_dir/pane-$pane.log"
done

# 2. Kill session
tmux kill-session -t "$session_name"

# 3. Verify cleanup
tmux has-session -t "$session_name" 2>/dev/null || echo "✅ Session cleaned up"
```

### Quick Cleanup Commands
```bash
# Kill specific session
tmux kill-session -t session-name

# Kill all development sessions  
tmux list-sessions | grep "dev-" | cut -d: -f1 | xargs -I {} tmux kill-session -t {}

# Emergency: Kill all sessions
tmux kill-server
```

## 📁 Log Organization

### Structured Log Collection
```bash
# Create log directory with timestamp
log_dir="logs/session-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$log_dir"

# Collect all pane logs
session_name="myapp-dev-20241230-143022"
for i in {0..3}; do
  tmux capture-pane -t "$session_name:$i" -p > "$log_dir/pane-$i.log"
done

# Create summary log
echo "Session: $session_name" > "$log_dir/summary.log"
echo "Timestamp: $(date)" >> "$log_dir/summary.log"
echo "Panes: $(tmux list-panes -t "$session_name" | wc -l)" >> "$log_dir/summary.log"
```

## 💡 Best Practices

1. **Always use unique session names** with timestamps
2. **Capture logs before killing sessions** - MANDATORY!
3. **Clean up sessions after operations complete** - NO EXCEPTIONS!
4. **Use descriptive pane titles** with `tmux rename-window`
5. **Monitor resource usage** in dedicated pane
6. **Keep sessions organized** by project/purpose

**Critical**: Sessions MUST be cleaned up after use. Never leave orphaned tmux sessions running.