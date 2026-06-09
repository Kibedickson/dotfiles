---
name: zennotes
description: Write plans, notes, and documents to a Zennotes vault on a Raspberry Pi via SSH. Use when the user asks to write, save, or create a plan, note, or document in their vault.
---

# Zennotes

Write markdown documents to the Zennotes vault on the Raspberry Pi.

## Vault Structure

```
~/docker/zennotes/vault/
├── inbox/          ← default destination
│   ├── Work/       ← work-related docs
│   └── Personal/   ← personal docs
├── quick/          ← short, ephemeral notes
├── archive/        ← archived docs
└── trash/          ← deleted docs
```

## Routing Rules

- **No folder specified** → `inbox/`
- **"work"** → `inbox/Work/`
- **"personal"** → `inbox/Personal/`
- **"quick"** → `quick/`
- **"archive"** → `archive/`

Always use `inbox/` unless the user explicitly names another folder.

## How to Write

Use the `bash` tool with a two-step approach — write to a local temp file, then `scp` it to the Pi:

```bash
# Step 1: Write content to a temp file locally
# (Use the write tool for this)

# Step 2: Copy to the Pi
scp /tmp/PLAN_NAME.md rasp:~/docker/zennotes/vault/inbox/PLAN_NAME.md
```

For Work or Personal:

```bash
scp /tmp/PLAN_NAME.md rasp:~/docker/zennotes/vault/inbox/Work/PLAN_NAME.md
```

Always `scp` from `/tmp/` — it avoids quoting and heredoc nesting issues.

## Naming Conventions

- Use lowercase with hyphens: `project-apollo-plan.md`
- Be descriptive: `q3-goals.md` not `plan.md`
- Include date only when the user specifies it or asks for a date-stamped file

## Document Format

All documents are Markdown. Use frontmatter when appropriate:

```markdown
---
title: Plan Title
date: 2026-06-09
---

# Plan Title

## Overview
Brief summary.

## Details
...
```

Frontmatter is optional. When in doubt, skip it and use a Markdown heading instead.

## Workflow

1. Ask what the document is about (if not obvious from the request).
2. Draft the content.
3. Confirm the destination folder (default: `inbox/`).
4. Write using the `write` tool to `/tmp/`, then `scp` to the Pi.
5. Verify with `ssh rasp "cat <path>"`.
6. Confirm the file path to the user.