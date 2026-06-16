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
├── inbox/               ← default destination
│   ├── Work/            ← work-related docs
│   │   └── {project}/   ← project subfolders (e.g. jubilee_tz/)
│   │       ├── requirements/
│   │       ├── reference/
│   │       ├── issues/
│   │       ├── prs/
│   │       ├── docs/
│   │       ├── archive/
│   │       └── others/
│   └── Personal/        ← personal docs
├── quick/               ← short, ephemeral notes
├── archive/             ← archived docs
└── trash/               ← deleted docs
```

Top-level routing rules:

- **No folder specified** → `inbox/`
- **"work"** → `inbox/Work/`
- **"personal"** → `inbox/Personal/`
- **"quick"** → `quick/`
- **"archive"** → `archive/`

Always use `inbox/` unless the user explicitly names another folder.

### Project & Category Auto-Routing

When writing to **Work**, always determine the **project** and **category** subfolder automatically — never dump files flat into `inbox/Work/` or `inbox/Work/{project}/`.

**Project detection** — infer from context:
- Current working directory (e.g. `jubilee_life_portal_backend_tz` → project `jubilee_tz`)
- User mentions a project name explicitly
- Existing project folders under `inbox/Work/` (list with `ssh rasp "ls $VAULT/inbox/Work/"`)
- If no project is identifiable, ask the user

**Category auto-routing** — classify the document and place it in the correct subfolder:

| Category | Subfolder | Signals |
|----------|-----------|----------|
| Requirements | `requirements/` | BRD, business requirements, functional specs, user stories, acceptance criteria |
| Reference | `reference/` | API docs, database schemas, architecture diagrams, technical references, cheatsheets |
| Issues | `issues/` | GitHub issues, implementation plans, bug plans, feature plans keyed to an issue number |
| PRs | `prs/` | Pull request descriptions, PR review notes, release notes |
| Docs | `docs/` | How-to guides, runbooks, setup guides, onboarding docs, meeting notes, general documentation |
| Others | `others/` | Anything that doesn't fit the above categories |

**Rules:**
- Always auto-route — do not ask the user to pick a category unless the document is genuinely ambiguous
- Create project/category subfolders on write if they don't exist (`mkdir -p`)
- Match the existing project folder name exactly (check with `ls` before writing)
- For issue files, prefix with the issue number: `01-da-customer-lookup.md`, `02-profile-creation.md`

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

For Work — auto-route to project/category:

```bash
# Create subfolder if needed
ssh rasp "mkdir -p $VAULT/inbox/Work/{project}/{category}"

# Copy to the Pi (example: jubilee_tz project, issues category)
scp /tmp/01-da-customer-lookup.md rasp:$VAULT/inbox/Work/jubilee_tz/issues/01-da-customer-lookup.md
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

1. Determine the **project** (from context or cwd) and **category** (from document content) automatically.
2. Draft the content.
3. Write using the `write` tool to `/tmp/`.
4. `mkdir -p` the target folder on the Pi, then `scp` to the correct project/category path.
5. Verify with `ssh rasp "cat $VAULT/..."`.
6. Confirm the full file path to the user.