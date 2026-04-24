---
name: sveltekit
description: SvelteKit 2+ with Svelte 5 runes. Self-contained standards for components, routing, load, form actions, hooks, state, env, errors, SSR/CSR, and testing. Use when writing, editing, or reviewing .svelte, .svelte.js, .svelte.ts files; any file under src/routes/ or src/lib/; +page, +layout, +server, +error, hooks.server, hooks.client, app.d.ts; SvelteKit config or design questions about a SvelteKit app.
---

# SvelteKit 2+ with Svelte 5 runes

This skill is self-contained. It covers both Svelte 5 component rules and SvelteKit framework rules. Assume SvelteKit 2+ and Svelte 5 runes mode. Anything from Svelte 4 or SvelteKit 1 is banned unless noted.

Principle: thin routes, fat lib. Plain data in, plain data out. Validate at the edge, trust the core.

---

## 1. Version and mode

- SvelteKit 2+, Svelte 5 runes mode only.
- `svelte.config.js` must have `compilerOptions: { runes: true }`.
- TypeScript preferred but not required. Rules apply to `.js`, `.ts`, `.svelte`, `.svelte.js`, `.svelte.ts`.

## 2. Runes — state and reactivity

- `$state()` for any reactive value. Never plain `let` for reactive data.
- `$derived(expr)` for computed. `$derived.by(() => { ... })` for multi-line.
- `$effect(() => { ... })` for side effects. Return cleanup when the effect attaches anything (event listener, interval, subscription).
- `$effect.pre()` for pre-DOM layout work. Rare.
- `$inspect(value)` for dev debug only. Remove before commit.
- Keep state granular. Multiple `$state` calls, not one monolithic object, unless the fields always change together.
- `$derived` placed next to its dependency, not in a distant `$effect`.
- Never use `$:` reactive statements. Banned.

Effect cleanup example:
```svelte
<script>
  let count = $state(0)

  $effect(() => {
    const id = setInterval(() => count++, 1000)
    return () => clearInterval(id)
  })
</script>
```

## 3. Runes — props and bindings

- `$props()` with destructuring. Inline defaults.
- Rest: `const { foo, ...rest } = $props()`.
- Two-way bindable: `$bindable()` only when parent needs to read AND write the same value. Prefer one-way + callback otherwise.
- Never `export let`. Never `$$props` / `$$restProps`.
- Typed props: define a `type Props = {...}` and `const { ... }: Props = $props()`.

## 4. Events and communication

- Lowercase HTML event attributes: `onclick`, `oninput`, `onsubmit`. Never `on:click`, never `onClick`.
- No event modifiers. Write a wrapper function if needed (e.g. `preventDefault` helper).
- Parent-child communication: callback props. Not `createEventDispatcher` (banned).
- Child calls parent via `onSomething?.()` — optional chain in case the parent did not pass it.

## 5. Snippets replace slots

- Use `{#snippet name(args)}` / `{@render name(args)}`.
- Pass snippets as props to components.
- `<slot />` is banned. `children` snippet is the default content slot.

## 6. Template rules

- All `{#each}` must be keyed: `{#each items as item (item.id)}`.
- Max 2 levels of `{#if}` / `{#each}` nesting in markup. Extract a component past that.
- Ternary for short inline conditional. `{#if}` block for multi-line.
- `class:cond` directive for conditional class. `style:var` for dynamic CSS vars. Inline `style="..."` only when value is truly dynamic and not suitable for a CSS variable.

## 7. Styling

- Styles are scoped by default. Keep them that way.
- `:global(...)` allowed but comment the reason.
- Apply classes to HTML elements, not to child components (component selector is not scoped the way you expect).
- No CSS-in-JS. No inline style for static values.

## 8. File conventions (routes)

- `+page.svelte` — page UI.
- `+page.js` — universal load (runs server then client).
- `+page.server.js` — server-only load and form actions.
- `+layout.svelte`, `+layout.js`, `+layout.server.js` — same shape at layout level.
- `+server.js` — HTTP endpoint (GET/POST/...). Not for form submissions.
- `+error.svelte` — error boundary UI for the route subtree.
- `+page@.svelte` / `+layout@.svelte` — layout reset/break-out.
- `(group)` folder — route grouping without URL segment.
- `[param]`, `[...rest]`, `[[optional]]`, `[param=matcher]` — param folders.
- `src/params/<matcher>.js` — matcher definitions.

## 9. Routing

- Route groups `(app)`, `(marketing)`, `(auth)` to share layouts without adding URL segments.
- Matchers in `src/params/` for typed/validated params. Keep them pure.
- Dynamic params: destructure from `params` in load. Never parse `url.pathname` manually to get a param.

## 10. Load functions

- **Default:** `+page.server.js`. Server-only. Private data, secrets, DB, full SSR.
- **Universal** (`+page.js`): only when data is public AND client-side navigation speed matters AND the fetch is idempotent.
- Always return an object. Avoid deeply nested return shape — flat is easier to consume.
- Use `fetch` from the `load` event, not global — it forwards cookies and dedupes on the server.
- Use `depends('tag:key')` + `invalidate('tag:key')` for targeted refresh. Use `invalidateAll()` sparingly.
- `parent()` to access parent layout data. Call it once; do not serialize calls.
- Never throw a plain `Error`. Use `error(status, message)` helper from `@sveltejs/kit`.
- Never call `goto` from load. Use `redirect(status, location)`.
- Return streamed promises for slow non-critical data. Block on critical data.

Load example:
```js
// +page.server.js
import { error } from '@sveltejs/kit'

export const load = async ({ params, locals, depends, fetch }) => {
  depends('app:post')
  const post = await locals.db.post.find(params.id)
  if (!post) error(404, 'Not found')

  return {
    post,
    // streamed, does not block render
    comments: fetch(`/api/posts/${params.id}/comments`).then((r) => r.json()),
  }
}
```

## 11. Form actions (mutation default)

- All mutations go through form actions. Not `fetch('/api/...')`. Not manual client POST.
- Named actions for multiple mutations on one page: `?/delete`, `?/update`.
- Return `fail(status, { field errors })` for validation failures. Return data for success. `redirect()` for post-success navigation.
- `use:enhance` for progressive enhancement. Works without JS. Gets better with JS.
- Always validate on the server. Client validation is UX only.

Form action example:
```js
// +page.server.js
import { fail, redirect } from '@sveltejs/kit'

export const actions = {
  default: async ({ request, locals }) => {
    const data = await request.formData()
    const title = data.get('title')?.toString().trim()
    if (!title) return fail(400, { title, missing: true })

    const post = await locals.db.post.create({ title, authorId: locals.user.id })
    redirect(303, `/posts/${post.id}`)
  },
}
```

```svelte
<script>
  import { enhance } from '$app/forms'
  const { form } = $props()
</script>

<form method="POST" use:enhance>
  <input name="title" value={form?.title ?? ''} />
  {#if form?.missing}<p>Title is required.</p>{/if}
  <button>Save</button>
</form>
```

## 12. Endpoints (`+server.js`)

Allowed only for:
- Webhooks (Stripe, GitHub, etc.).
- File downloads, image responses, non-HTML content.
- External API consumers (mobile app, third party).

Not allowed for:
- Form submissions. Use form actions.
- Client-side SPA fetches to your own app. Use load + invalidate.

Shape: export `GET`, `POST`, etc. Each takes a `RequestEvent`, returns a `Response` or `json()` helper result.

## 13. Hooks

- `src/hooks.server.js` — server request pipeline.
- `src/hooks.client.js` — client-side navigation hooks and error handling.
- `handle({ event, resolve })` — core middleware. Set `event.locals` here. Use `sequence()` to compose multiple handles.
- `handleFetch` — rewrite outgoing fetches from load.
- `handleError` — log unexpected errors. Return a safe shape for `+error.svelte`.

Auth hook example:
```js
// src/hooks.server.js
import { sequence } from '@sveltejs/kit/hooks'

const authenticate = async ({ event, resolve }) => {
  const token = event.cookies.get('session')
  event.locals.user = token ? await lookupUser(token) : null
  return resolve(event)
}

const logRequests = async ({ event, resolve }) => {
  const start = Date.now()
  const res = await resolve(event)
  console.info(`${event.request.method} ${event.url.pathname} ${Date.now() - start}ms`)
  return res
}

export const handle = sequence(authenticate, logRequests)
```

## 14. Auth and route guards

- Authenticate in `hooks.server.js`. Populate `event.locals.user`.
- Authorize in `+layout.server.js` at the route group level. One guard per protected subtree.
- Redirect unauthenticated users with `redirect(303, '/login?next=' + encodeURIComponent(event.url.pathname))`.
- Never guard in `+page.svelte`. Never guard in universal `+page.js`.

Layout guard example:
```js
// src/routes/(app)/+layout.server.js
import { redirect } from '@sveltejs/kit'

export const load = async ({ locals, url }) => {
  if (!locals.user) redirect(303, `/login?next=${url.pathname}`)
  return { user: locals.user }
}
```

## 15. State management

- Component-local state: `$state()` in the component.
- Shared state: state class in `src/lib/state/<name>.svelte.js`. Export a singleton instance for app-wide, or a factory for per-context.
- Per-request/page data: the `data` prop from load. Not a store.
- Page info (params, url, route): `import { page } from '$app/state'`. Read as `page.url`, `page.params`. No `$` prefix. `$app/stores` is deprecated in Kit 2 — do not use.
- Context (`setContext` / `getContext`) for passing state class instances down a subtree without prop drilling.

State class example:
```js
// src/lib/state/cart.svelte.js
class Cart {
  items = $state([])
  get total() {
    return this.items.reduce((sum, i) => sum + i.price * i.qty, 0)
  }
  add(item) {
    this.items = [...this.items, item]
  }
}

export const cart = new Cart()
```

## 16. Navigation

- `import { goto, invalidate, invalidateAll, preloadData, beforeNavigate, afterNavigate } from '$app/navigation'`.
- `goto(url, { replaceState, invalidateAll })` for programmatic nav.
- `invalidate('tag:key')` to rerun loads that declared that dep.
- `beforeNavigate` to warn on unsaved changes. Cancel with `cancel()`.
- Never `window.location = ...` for internal nav.

## 17. Page state

- `page` from `$app/state` — url, params, route, data, form, status, error.
- No `$page` store. No manual subscribe.

```svelte
<script>
  import { page } from '$app/state'
</script>

<p>Current path: {page.url.pathname}</p>
```

## 18. Env and secrets

- `$env/static/private` — build-time secrets. Tree-shaken. Server only.
- `$env/dynamic/private` — runtime secrets (e.g. platform env). Server only.
- `$env/static/public` — `PUBLIC_`-prefixed, build-time, exposed to client.
- `$env/dynamic/public` — `PUBLIC_`-prefixed, runtime, exposed to client.
- Never `process.env.X` in app code. Never read secrets from universal load.

## 19. Error handling

- Expected errors: `error(status, message | { message, code, ... })` helper. Surfaces via `+error.svelte`.
- Unexpected errors: let them throw. `handleError` hook logs and shapes them.
- `+error.svelte` at route / layout level renders the error page. Keep it minimal, no loads.
- Never swallow errors silently. Never `try { ... } catch {}` without a logged reason.

## 20. SSR, CSR, and prerender

- Default: SSR on, CSR on (hydration).
- `export const prerender = true` — route is built as static HTML. Use for marketing, docs, blog.
- `export const ssr = false` — client-only. Use only for true client-exclusive flows (auth-gated dashboard with heavy client libs, WebGL scene). Loses SEO and first-paint speed.
- `export const csr = false` — no client JS. Pure HTML pages. Rare.
- Configure at `+page.js` / `+layout.js`. Configure at layout for whole subtree.

## 21. Folder structure

```
src/
  lib/
    server/         # server-only code. Never imported from .svelte.
    state/          # *.svelte.js state classes.
    components/     # shared components.
    <domain>/       # domain-organized modules (auth, billing, posts).
  routes/
    (app)/          # authenticated group.
      +layout.server.js
      dashboard/
        +page.svelte
        +page.server.js
    (marketing)/    # public group.
    api/            # +server.js endpoints only.
  params/           # param matchers.
  hooks.server.js
  hooks.client.js
  app.d.ts          # declare App.Locals, App.PageData, etc.
  app.html
```

- Routes are thin. Route file = 20 lines max. Delegate logic to `src/lib/`.
- `src/lib/server/` is enforced by SvelteKit — importing from a non-server file is a build error. Use it.
- No business logic in `+page.svelte`. No DB calls in `+page.svelte`. UI only.

## 22. Type declarations

```ts
// src/app.d.ts
declare global {
  namespace App {
    interface Locals {
      user: User | null
      db: DbClient
    }
    interface PageData {}
    interface Error {
      code?: string
    }
    interface Platform {}
  }
}
export {}
```

## 23. Testing

- Unit: Vitest. Co-locate: `foo.js` next to `foo.test.js`.
- Component: `@testing-library/svelte` + Vitest. Keep component tests for real interaction, not render snapshots.
- E2E: Playwright. `tests/` folder at project root.
- State classes and lib functions are trivial to unit test — that is the point of fat lib, thin routes.
- Load functions and form actions: test the lib functions they call. Do not mock SvelteKit internals.

## 24. Security

- Never render user content with `{@html}`. If truly needed, sanitize with DOMPurify first and comment why.
- Form actions have built-in CSRF protection. Endpoints do not — validate origin for state-changing endpoints.
- Cookies: `httpOnly: true`, `secure: true` in prod, `sameSite: 'lax'` default, `'strict'` for auth.
- Never trust `event.request` headers like `X-Forwarded-*` unless you control the proxy.
- Validate all input in form actions and endpoints. Trust `event.locals.user` (set by your auth hook).

## 25. Banned patterns

Svelte 4 / SvelteKit 1 relics. Do not use:

- `export let` for props.
- `$:` reactive statements.
- `on:event` directives and `|modifier` syntax.
- `createEventDispatcher`.
- `$$props`, `$$restProps`.
- `<slot />` — use snippets.
- `import { page } from '$app/stores'` — use `$app/state`.
- Auto-subscribe `$store` syntax for app state — use state classes.
- `goto` for post-mutation redirect inside a load or action — use `redirect()` helper.
- `fetch('/api/...')` from a component for app-owned data — use load + invalidate.
- `process.env.X` in app code — use `$env/*`.

## 26. Design workflow (before writing)

1. **Decide the boundary.** Is this a page, a layout, a library module, an endpoint, or a state class? The wrong boundary costs more than the wrong code.
2. **Data flow first.** Where does data enter (load / form action)? Where does it leave (render / redirect)? Draw the path.
3. **Pick the thinnest route.** Can this be a form action? Then not an endpoint. Can this be a layout guard? Then not a per-page check.
4. **Lib it.** Any logic beyond 5 lines belongs in `src/lib/`. Test it there.
5. **Name the state owner.** One place per datum. If two components need it, lift or state-class it.
6. **Error paths explicit.** Expected errors use `error()`. Unexpected bubble. Never silent.
7. **Check size.** Route file > 20 lines, component > 200 lines, state class > 150 lines = split.

## 27. Size limits

- Route file (`+page.server.js`, `+page.js`): 20 lines. It should delegate.
- Component (`+page.svelte`, `.svelte`): 200 lines.
- State class file: 150 lines.
- Lib function: 20 lines body, 3 params.
- Max template nesting: 2.
- Max component public API: 7 props. More = split.

## 28. Output when invoked for design

When asked to design or review a SvelteKit feature, produce:

1. **Routes** — paths, groups, dynamic params.
2. **Load plan** — server vs universal, what each returns, dependencies.
3. **Mutations** — form actions, named or default.
4. **Auth** — which guard at which layout.
5. **State** — component-local vs state class vs page data.
6. **Errors** — expected paths, `+error.svelte` scope.
7. **Rendering** — SSR / CSR / prerender per route.
8. **What NOT to build** — endpoints that should be actions, stores that should be classes, etc.
