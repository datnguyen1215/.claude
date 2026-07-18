# Java Coding Standards

## Identity

Senior software engineer. Production-grade clean code. No shortcuts.

## Naming

- Classes: PascalCase, noun. One responsibility per name.
- Methods: camelCase, verb. `sendMessage`, `parseResponse`, not `doStuff`.
- Constants: UPPER_SNAKE_CASE. No magic numbers/strings.
- Variables: camelCase, descriptive. No single letters except loops.
- Booleans: is/has/should prefix. `isConnected`, `hasPermission`.
- Packages: lowercase, singular. `com.screenbeam.vsb.service`.

## Class Design

- Max 200 lines. Split if bigger.
- One responsibility. If "and" in description, split.
- Fields at top, constructors next, public methods, then private.
- No God classes. No God methods.
- Prefer composition over inheritance.
- Final fields where possible. Immutable by default.
- No public fields. Use getters only when needed, skip trivial setters.

## Methods

- Max 20 lines. Shorter better.
- Max 3 params. Use object if more.
- Single responsibility. Does one thing.
- Early return for guard clauses. No deep nesting.
- Max 2 levels of nesting. Extract method if deeper.
- No side effects unless method name makes it obvious.

## Error Handling

- Never swallow exceptions. Log at minimum.
- Catch specific exceptions. Never bare `catch (Exception e)` unless top-level.
- Fail fast. Validate inputs at boundary, trust internals.
- No nulls as return values. Use Optional or empty collections.
- Log with full context: what failed, what inputs were, what was expected.

## Android Specific

- Activities/Services: thin. Delegate to controllers/managers.
- No business logic in lifecycle methods. Wire only.
- Foreground services: proper notification, proper cleanup in onDestroy.
- Callbacks from native (JNI): post to main thread if touching UI.
- SharedPreferences: single wrapper class per prefs file. No scattered access.
- No context leaks. Static refs to Activity/Context = memory leak.

## JNI Bridge

- JNI methods: thin wrappers. No logic in jni.cpp.
- One direction per call. Java→C or C→Java. No ping-pong.
- String conversion at boundary. JNI layer handles jstring↔char*.
- Null-check every JNI object before use. JNI crashes are silent death.
- Log entry/exit of every JNI callback. Debugging without logs = blind.

## Concurrency

- Synchronized blocks: small as possible. Lock ordering documented.
- No nested locks without documented order.
- Handler/Looper for Android threading. No raw Thread unless justified.
- Volatile for simple flags. AtomicReference for CAS.
- No busy-wait. Use CountDownLatch, Semaphore, or callbacks.

## Formatting

- Braces: K&R style (opening brace same line).
- Single-statement if: braces optional if one line, required if multi-line.
- Imports: no wildcards. Organized: android, java, third-party, project.
- One blank line between methods. No double blanks.
- Line length: 120 max.

## Anti-Patterns — Flag and Fix

- Duplicate code (>5 lines same logic): extract method.
- Dead code: delete. No commenting out.
- String concatenation in loops: use StringBuilder.
- Mutable static state: eliminate or synchronize.
- Catching and rethrowing same exception: pointless, remove.
- Empty catch blocks: never. Log or rethrow.
- Long parameter lists: use builder or config object.
- Boolean params: replace with enum or two methods.
- Deep inheritance (>2 levels): flatten, use composition.

## Logging

- Every method entry with key params.
- Every error with full context.
- Every state transition, callback, external call.
- Use project log system (LmiJNI.log for VSB). No raw Log.d in production.
- Levels: I=normal flow, W=unexpected but ok, E=failure.
