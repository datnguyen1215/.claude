---
description: "Engineer with mandatory code review and fixes"
allowed-tools: ["Task", "Read", "Grep", "Glob", "Bash", "LS"]
---

# Engineer-Review Command

This command implements engineering changes with comprehensive code review and feedback application in three sequential steps.

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
- description: "Comprehensive code review"
- prompt: "Review these recently modified files: [list files from Step 1]. Provide comprehensive feedback including: bugs, security issues, broken functionality, code cleanliness, maintainability concerns, performance considerations, readability improvements, and best practices. Return a numbered list with specific file:line references, categorized by severity (Critical/Important/Suggested)."

Parse the reviewer's output to extract all feedback organized by severity.

## Step 3: Apply Review Feedback

Apply the feedback from code review based on priority.

Use the Task tool with:
- subagent_type: "engineer"
- description: "Address review feedback"
- prompt: "Address the following issues from code review: [list all issues from Step 2, organized by severity]. Start with Critical issues (must fix), then Important issues (should fix), and finally Suggested improvements (nice to have). Make minimal changes to address each issue. For each change, specify the file:line and confirm what was addressed."

If no issues were found, skip this step and report successful completion.

## Completion

After all three steps:
1. Report the final status
2. List all files that were modified
3. Confirm all feedback has been addressed appropriately
4. Present a summary of the work completed

## Workflow Summary

1. **Engineer** implements the requested changes
2. **Code Reviewer** performs comprehensive review for all code quality aspects
3. **Engineer** addresses feedback based on priority (Critical → Important → Suggested)
4. Report completion with summary

This ensures all code changes undergo comprehensive review with feedback addressed by priority before completion.