---
name: zennotes
description: Read and write plans, notes, and documents in a Zennotes vault on a Raspberry Pi via SSH. Use when the user asks to read, write, save, create, list, or browse notes in their vault.
---

# Zennotes

Read and write markdown documents to the Zennotes vault on the Raspberry Pi.

**VAULT**: `~/docker/zennotes/vault` — all paths below are relative to this root.

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

## How to Read

Use `ssh rasp` to read or list files in the vault:

```bash
# List files in a folder
ssh rasp "ls $VAULT/inbox/"

# List recursively (for searching)
ssh rasp "ls -R $VAULT/inbox/"

# Read a file — always use head first to avoid context blowout
ssh rasp "head -n 200 $VAULT/inbox/my-note.md"

# Read the full file only once you know it's short
ssh rasp "cat $VAULT/inbox/my-note.md"
```

Use the `read` tool to read images (jpg, png, gif, webp). First `scp` the image from the Pi to `/tmp/`, then read it locally:

```bash
scp rasp:$VAULT/inbox/screenshot.png /tmp/
# Then use the read tool on /tmp/screenshot.png
```

## How to Write

Use the `bash` tool with a two-step approach — write to a local temp file, then `scp` it to the Pi:

```bash
# Step 1: Write content to a temp file locally
# (Use the write tool for this)

# Step 2: Copy to the Pi
scp /tmp/PLAN_NAME.md rasp:$VAULT/inbox/PLAN_NAME.md
```

For Work or Personal:

```bash
scp /tmp/PLAN_NAME.md rasp:$VAULT/inbox/Work/PLAN_NAME.md
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

## Read Workflow

1. If the user doesn't specify a filename, list the relevant folder first (`ls $VAULT/...`).
2. Read the file with `head -n 200` initially; use `cat` if it's short.
3. Present the content to the user.

## Write Workflow

1. Ask what the document is about (if not obvious from the request).
2. Draft the content.
3. Confirm the destination folder (default: `inbox/`).
4. Write using the `write` tool to `/tmp/`, then `scp` to the Pi.
5. Verify with `ssh rasp "cat $VAULT/..."`.
6. Confirm the file path to the user.