# Project Structure & Workspace Organization

## Detection Keywords
**Primary**: project, workspace, directory, structure, organize, codebase
**Context**: project management, file organization, workspace setup, development environment
**Intent**: work on projects, organize code, manage workspace, structure development
**Negative**: single file tasks, no project context, temporary scripts

## When This Rule Applies
- Working on multi-file projects
- Organizing development workspace
- Managing project structure
- Coordinating across project files

## Core Rule: Use Projects Directory with Symlinks

### 🚨 MANDATORY: Check Projects Folder First
Before working on any project-related task:

1. **Always check `./projects` directory first**
2. **List available project symlinks to identify target project**
3. **Work within the identified project symlink using RELATIVE paths**
4. **NEVER resolve symlinks to their absolute target paths**

### Implementation Pattern

```bash
# 1. First, check what projects are available in current workspace
LS ./projects

# 2. Identify relevant project based on task description
# Projects are organized as symbolic links pointing to actual locations

# 3. Work within the ./projects/[project-name] workspace using RELATIVE paths
# ✅ CORRECT: Use relative symlink path
Read ./projects/algotrading/src/main.py
Grep "function" ./projects/algotrading

# ❌ INCORRECT: Do NOT resolve to absolute paths
# Read /home/dnguyen/personal/projects/algotrading/src/main.py
# Grep "function" /home/dnguyen/personal/projects/algotrading
```

### Workspace Structure
```
./projects/
├── algotrading -> /home/dnguyen/personal/projects/algotrading/
├── hsmjs -> /home/dnguyen/personal/projects/hsmjs/
├── orchestrate -> /home/dnguyen/work/projects/orchestrate/
└── win-assistant -> /home/dnguyen/work/projects/o8/wa/
```

### ⚠️ Critical: Relative Path Usage for Symlinks

**Always use relative paths when working with symlinked projects:**
- Use `./projects/algotrading` instead of `/home/dnguyen/personal/projects/algotrading/`
- Use `./projects/hsmjs/src` instead of `/home/dnguyen/personal/projects/hsmjs/src`
- Symlinks should NOT be resolved to their absolute target paths

**Why relative paths matter:**
- Preserves workspace organization and project boundaries
- Maintains consistent working context within the workspace
- Avoids breaking workspace-relative operations
- Ensures portability across different environments

## Quick Reference
- ✅ **Always**: Check `./projects` directory first
- ✅ **List**: Available projects to match task requirements
- ✅ **Use**: Symlinked projects as workspace entry points with RELATIVE paths
- ✅ **Preserve**: Symlink structure - use `./projects/[name]` paths
- ✅ **Work**: Within symlink directories without resolving to targets
- ❌ **Never**: Work directly on original project paths without checking projects folder
- ❌ **Never**: Resolve symlinks to their absolute target paths
- ❌ **Never**: Use absolute paths when relative symlink paths are available

### Symlink Path Do's and Don'ts

**✅ DO:**
- `./projects/algotrading/config.json`
- `./projects/orchestrate/src/main.py`
- `LS ./projects/hsmjs`
- `Grep "import" ./projects/win-assistant`

**❌ DON'T:**
- `/home/dnguyen/personal/projects/algotrading/config.json`
- `/home/dnguyen/work/projects/orchestrate/src/main.py`
- `LS /home/dnguyen/personal/projects/hsmjs`
- `Grep "import" /home/dnguyen/work/projects/o8/wa`