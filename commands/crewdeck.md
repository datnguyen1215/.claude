You are interacting with the CrewDeck API on behalf of the user. Use `curl` to make API calls.

**User request:** $ARGUMENTS

## Connection

- **Base URL:** `$CREWDECK_BASE_URL` (environment variable, e.g., `http://localhost:9380`)
- **API Prefix:** `/api/v1` - All endpoints below are relative to `$CREWDECK_BASE_URL/api/v1`
- **Format:** All requests and responses are JSON
- **Authentication:** Bearer token via `Authorization: Bearer $CREWDECK_API_KEY` header

## Endpoints

### Projects

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects` | List projects |
| GET | `/api/v1/projects?stats` | List projects with issue counts |
| GET | `/api/v1/projects/:id` | Get project |
| POST | `/api/v1/projects` | Create project (body: `github_url` required, optional `name`, `description`, `memory`, `max_concurrency`, `github_account_id`) |
| PATCH | `/api/v1/projects/:id` | Update project (body: any subset of `name`, `description`, `memory`, `max_concurrency`, `github_account_id`) |
| DELETE | `/api/v1/projects/:id` | Delete project (cascades all data) |

### Repos

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects/:projectId/repos` | List repos for project |
| POST | `/api/v1/projects/:projectId/repos` | Add repo (body: `github_url` required, optional `default_branch`) |
| DELETE | `/api/v1/projects/:projectId/repos/:repoId` | Remove repo |

### Issues

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects/:projectId/issues` | List issues (query: `status`, `created_by`, `sort`, `order`) |
| GET | `/api/v1/projects/:projectId/issues/:issueId` | Get issue with comments, PRs, activity |
| POST | `/api/v1/projects/:projectId/issues` | Create issue (body: `title` + `description` required, optional `priority`) |
| PATCH | `/api/v1/projects/:projectId/issues/:issueId` | Update issue (body: any subset of `title`, `description`, `status`, `priority`, `chain_depth`) |
| DELETE | `/api/v1/projects/:projectId/issues/:issueId` | Delete issue |

**Status values:** `open`, `in_progress`, `pr_created`, `done`

**Status transitions:** open -> in_progress/done, in_progress -> pr_created/done, pr_created -> in_progress/done, done is terminal.

**Filtering examples:**
- `?status=open` or `?status=open,in_progress`
- `?created_by=user` or `?created_by=agent`
- `?sort=priority&order=desc`

### Comments

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects/:projectId/issues/:issueId/comments` | List comments |
| POST | `/api/v1/projects/:projectId/issues/:issueId/comments` | Add comment (body: `content`) |
| PATCH | `/api/v1/projects/:projectId/issues/:issueId/comments/:commentId` | Edit comment (body: `content`, user comments only) |
| DELETE | `/api/v1/projects/:projectId/issues/:issueId/comments/:commentId` | Delete comment (user comments only) |

### Activity Log

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects/:projectId/activity` | List activity (query: `issue_id`, `actor_type`, `action`, `since`, `limit`, `offset`) |

### Agent Runs

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects/:projectId/issues/:issueId/runs` | List runs for issue |
| GET | `/api/v1/projects/:projectId/runs/:runId` | Get run with events |
| GET | `/api/v1/projects/:projectId/runs` | List runs for project (query: `limit`, `offset`) |

### Crew / Agents

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/crew` | List the 4-agent crew (captain, engineer, lead, docs) |

### Environment Variables

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/projects/:projectId/environment` | List env vars (secrets masked) |
| POST | `/api/v1/projects/:projectId/environment` | Create env var (body: `key`, `value`, optional `is_secret`) |
| PATCH | `/api/v1/projects/:projectId/environment/:envVarId` | Update env var |
| DELETE | `/api/v1/projects/:projectId/environment/:envVarId` | Delete env var |

### GitHub Accounts

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/github-accounts` | List connected accounts |
| DELETE | `/api/v1/github-accounts/:id` | Disconnect account |

## Error Format

```json
{ "error": { "code": "ERROR_CODE", "message": "..." } }
```

Codes: `NOT_FOUND` (404), `VALIDATION_ERROR` (400), `INVALID_TRANSITION` (400), `CONFLICT` (409), `FORBIDDEN` (403), `INTERNAL_ERROR` (500).

## Workflow Guidelines

1. **Always start by listing projects** (`GET /api/v1/projects?stats`) to discover project IDs before making other calls.
2. When the user says "issues", they mean CrewDeck issues (not GitHub issues).
3. Present results in a readable format -- use tables or lists, not raw JSON.
4. When creating issues, ask for missing required fields (title, description) if not provided.
5. For ambiguous project references, show the user a list and ask which one.
6. Priority is an integer where higher = more urgent. Use 0-10 scale.
7. When listing issues to decide what to work on, sort by priority descending and filter for open/in_progress statuses.
