---
description: "Engineer with mandatory code review and fixes"
allowed-tools: ["Task", "Read", "Grep", "Glob", "Bash", "LS"]
---

# Engineer-Review Command

This command implements engineering changes with mandatory code review and critical fix application in three sequential steps.

## MANDATORY FIRST STEP - Check Project Rules

Before starting ANY engineering task, you MUST:

1. Run `LS /home/dnguyen/.claude/rules/` to list files in the rules directory
2. Read rules relevant to: $ARGUMENTS
3. Apply these rules throughout your implementation
4. **MANDATORY - NO EXCEPTIONS**: When using Read tool, ALWAYS read complete files. NEVER use limit or offset parameters. Full file reading is REQUIRED.

## Step 1: Engineer Implementation

First, spawn the engineer agent to implement the requested changes.

Use the Task tool with:
- subagent_type: "engineer"
- description: "Implement requirements"
- prompt: "Implement the following requirements: $ARGUMENTS. At the end of your work, list all files you modified with their full paths."

Capture the output to identify which files were modified.

## Step 2: Automatic Code Review

After the engineer completes, identify the modified files from the engineer's output.

Use the Task tool with:
- subagent_type: "code-reviewer"
- description: "Review critical issues"
- prompt: "Review ONLY for CRITICAL issues in these recently modified files: [list files from Step 1]. Focus exclusively on CRITICAL problems that must be fixed - bugs, security issues, broken functionality. Return a numbered list of critical issues with specific file:line references. Do not include suggestions, minor issues, or style improvements."

Parse the reviewer's output to extract critical issues.

## Step 3: Mandatory Fix Application

If the code reviewer identified any critical issues, they MUST be fixed.

Use the Task tool with:
- subagent_type: "engineer"
- description: "Fix critical issues"
- prompt: "Fix ONLY these CRITICAL issues identified by code review: [list issues from Step 2]. Make minimal changes to address each issue. For each fix, confirm the issue is resolved and specify the file:line where you made the change."

If no critical issues were found, skip this step and report successful completion.

## Completion

After all three steps:
1. Report the final status
2. List all files that were modified
3. Confirm all critical issues have been addressed
4. Present a summary of the work completed

## Workflow Summary

1. **Engineer** implements the requested changes
2. **Code Reviewer** automatically reviews for critical issues only
3. **Engineer** mandatorily fixes all critical issues found
4. Report completion with summary

This ensures all code changes undergo review and critical issues are always addressed before completion.