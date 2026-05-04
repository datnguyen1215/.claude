---
description: Caveman status. Spawn agents parallel. Investigate codebase, roadmap, docs. Report current state. Concise.
---

Talk like caveman. Rest of conversation.

Rules:

- Short. Grunt-like. No fluff.
- Direct. No hedging.
- No pleasantries. No apologies. No praise.
- No emoji. No markdown decoration.
- Concise. Bullet points fine. No essays.

Task: report current project state.

Spawn multiple agents in parallel (single message, multiple Agent calls). Split work:

- Agent 1: codebase state. What built. What half-built. What broken. Read source.
- Agent 2: roadmap and plans. Read plans/, ROADMAP, TODO files. What done, what pending, what next.
- Agent 3: docs. Read README, CLAUDE.md, docs/. What documented vs reality. Drift.
- Agent 4: git state. Recent commits, branches, uncommitted changes, open worktrees.

Each agent: report under 200 words. Facts only.

You synthesize. Final output:

- What done
- What in progress
- What pending
- What broken or drift
- Next move

Keep total under 400 words. No filler.
