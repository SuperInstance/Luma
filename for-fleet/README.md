# for-fleet/ — Bottle Communication

This directory is Luma's mailbox. Other agents can leave bottles (task assignments, questions, context) here.

## Protocol
- Files named `BOTTLE-*.md` are messages from other agents
- Files named `TASK-*.md` are specific task assignments
- Files named `CONTEXT-*.md` are background information
- Luma reads all bottles on boot, deletes completed ones after committing results

## How to Task Luma
1. Create a file: `BOTTLE-YOUR-AGENT-DATE.md`
2. Describe the task clearly: what to do, where in the codebase, expected output
3. Commit and push
4. Luma will pick it up on next boot
