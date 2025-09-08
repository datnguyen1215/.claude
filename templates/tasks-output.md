# Task List: {description}

Generated: {timestamp}
Session: {session_id}

## 📊 Summary

- Total Tasks: {total} (P0: {p0}, P1: {p1}, P2: {p2}, P3: {p3})
- Failed/Retry Tasks: {retry_count}
- Dependencies Identified: {dep_count}
- Estimated Completion Order: {order_summary}

## 🔴 P0 - Critical Priority

### T001: {task_name} {retry_badge}

**Dependencies:** [T002, T005]
**Files:** `src/module.js:45-60`, `lib/helper.ts:120`

**Objective:** {clear_description}

**Tasks:**

- [ ] Research current implementation in `module.js:handleRequest()`
- [ ] Update error handling to prevent data loss
- [ ] Add validation for user input parameters
- [ ] Write unit tests for edge cases

**Commands:**

```bash
npm test src/module.test.js
grep -r "handleRequest" src/
```

**Success Criteria:**

- All tests pass without errors
- No security vulnerabilities in scan
- Error handling covers all edge cases

---

## 🟡 P1 - High Priority

{similar_structure}

## 🟢 P2 - Medium Priority

{similar_structure}

## 🔵 P3 - Low Priority

{similar_structure}

## 📋 Dependency Graph

```
T001 ──> T002 ──> T004
     └─> T003 ──> T005
T006 (independent)
```

## ⚠️ Previously Failed Tasks

{if_any_found_list_with_original_context}
