---
name: architect
description: Design software modules with Unix mentality — small, single-purpose, composable, with clear inputs and outputs. Use when designing a new module, system, or feature; when deciding file/module boundaries; when creating 3+ new files; when adding a new layer, package, or dependency; when the user asks how to structure, organize, or build something; when reviewing a plan before implementation.
---

# Architect — Unix-style module design

Design philosophy stolen from Unix:

1. Make each module do one thing well. To do a new job, build fresh rather than complicate old.
2. Expect the output of one module to become the input of another.
3. Prefer data over control. Data is inspectable, testable, composable.
4. Small is beautiful. Small is testable. Small is replaceable.

If you cannot state what a module does in one sentence without "and", it is too big.

## 1. Single purpose

- Each module owns one concept. The module name is the concept.
- One sentence test: "This module {verb}s {noun}." No "and". No "or".
- If two reasons to change exist, split into two modules.
- A module doing config parsing AND validation AND loading = three modules.

## 2. Inputs and outputs

- Every function and module has explicit input and explicit output. No hidden input (globals, ambient state). No hidden output (side effects) unless that IS the job.
- Prefer plain data in, plain data out. Object, array, primitive. Not class instance, not callback, not event emitter — unless that is the point.
- Output of one module should be valid input to another without glue. If glue needed, the shape is wrong.
- Keep input shape narrow. Accept exactly what is needed, nothing more. No "options" bag that hides 12 flags.

## 3. Composition over configuration

- Build behavior by combining small modules, not by adding flags to big modules.
- A function with a boolean flag that changes its behavior = two functions.
- Options object with 6+ keys = the function is doing too much.
- Pipeline over monolith: `parse -> validate -> transform -> save` as four modules, not one `process()` with flags.

## 4. Boundaries

- Validate at the edge: user input, network, file, third-party API. Trust inside.
- Side effects at the edge: I/O, logging, DB write. Pure core.
- Error handling at the edge. Throw or return error inside; handle at boundary.
- The core should be testable with zero mocks. If core needs mocks, the boundary leaked in.

## 5. Data flow and dependency direction

- Dependencies flow one direction. Never circular. If A imports B, B never imports A.
- Data flows down the call tree. Events bubble up. No sideways calls between siblings — lift to common parent.
- One source of truth per piece of data. Derived values are computed, not stored.
- Server state, UI state, URL state are separate concerns. Do not mix in one store.

## 6. State ownership

- State lives closest to where it is used. Lift only when two or more consumers need it.
- Prefer stateless modules. State is cost; justify it.
- Stateful module is a module whose identity matters across calls. Most modules are not that.

## 7. Size limits (hard)

- Function body: max 20 lines.
- File: max 150 lines.
- Function params: max 3 (use object destructure past that, but also question why).
- Module public API: max 5 exports. More means the module is multiple modules.
- Nesting depth: max 2.

Past limits, split. No exceptions without a named reason.

## 8. Testability as design signal

- If a module is hard to test, its design is wrong. Fix design, not test.
- Pure function = trivial test. Prefer pure.
- Module with zero mocks needed = good shape.
- Module needing mocks for every call = wrong boundary.
- If you must test private behavior, it wants to be a separate module with a public API.

## 9. Refuse to add

Before adding, ask:
- Does this concept already exist nearby? Reuse, do not re-create.
- Is there one caller? Inline it.
- Is there one implementation of this interface? Delete the interface.
- Is this "future-proofing"? Delete it. Add when a second caller appears.
- Is this a wrapper that only renames? Delete, use the original.
- Is this a factory/builder for a 2-field object? Use an object literal.
- Is this an event/pubsub for 2 known callers? Direct call.
- Is this middleware for 2 steps? Two lines inline.

## 10. Refuse to abstract

- No abstraction until the third concrete repeat.
- No generic/parameterized module for one type.
- No "extensible" interface with one impl.
- No dependency injection for a thing that is never swapped.
- No config file for values that never change.
- No design pattern the project does not already use. New pattern = onboarding cost for every future reader.

## 11. Naming as design check

- If the best name for a module uses "and" or "or", the module is wrong shape.
- Banned names signal missing design: `Helper`, `Util`, `Manager`, `Handler`, `Wrapper`, `Service` (without domain), `Data`, `Info`, `Common`, `Shared`.
- A good module name is a noun for the concept or a verb for the action. Not a category.

## 12. When existing code fights these rules

- Note the drift. Do not silently expand scope of the current task to fix it.
- Propose the refactor as a separate step. Let the user choose.
- A bug fix is not a refactor. A feature is not a rewrite.

## Output when invoked

When designing or reviewing a design, produce this:

1. **Concept** — one sentence: "This module {verbs} {noun}."
2. **Input** — exact shape. Plain data.
3. **Output** — exact shape. Plain data.
4. **Side effects** — none, or named explicitly.
5. **Dependencies** — what it imports. Direction must flow one way.
6. **Boundary** — what is edge (I/O, validation, error), what is core (pure).
7. **What NOT to build** — named anti-additions for this design.
8. **Trade-off** — what this design gives up. If nothing, you missed something.

If any of 1–5 cannot be stated in one short line, the design is not ready. Keep cutting.

## Unix heuristics cheat sheet

- "Do one thing well" — one-sentence test.
- "Write programs that work together" — output of A = input of B.
- "Small is beautiful" — 150 line file, 20 line function.
- "Store data in flat text files" — plain data over class/object graph.
- "Avoid captive user interfaces" — library first, UI second. Logic is not bound to a UI.
- "Make each program a filter" — pure transform when possible.
