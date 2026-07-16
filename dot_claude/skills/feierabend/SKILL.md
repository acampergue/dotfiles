---
name: feierabend
description: Tagesabschluss — reconstruct today's work from evidence (git, JIRA, session memory), reconcile against Tempo bookings, propose missing worklogs, do housekeeping, and write a handoff note for tomorrow. Use at the end of the workday.
---

# Feierabend — Day Close

Close the user's workday: what happened, is it all booked, what carries over.
Narrate in English; show German source text verbatim alongside translations.

`gipm` may not be on `PATH` — fall back to `~/workspace/gipm/.venv/bin/gipm`.

## 1. Mark the run

```bash
mkdir -p ~/.claude/rituals/handoff ~/.claude/rituals/plan
date +%F > ~/.claude/rituals/last-feierabend
```

## 2. Evidence sweep (three sources)

**Git activity in task clones** — commits today and, critically, dirty trees
(uncommitted end-of-day work is a loss risk — flag it prominently):

```bash
find ~/workspace/tasks -maxdepth 7 -name .git -type d 2>/dev/null | while read -r git_dir; do
  repo=${git_dir%/.git}
  echo "== $repo"
  git -C "$repo" log --oneline --since=midnight --author="$(git -C "$repo" config user.email)" 2>/dev/null
  git -C "$repo" status --porcelain 2>/dev/null | head -5
  git -C "$repo" log --branches --not --remotes --oneline 2>/dev/null | head -5  # unpushed
done
```

**JIRA activity on my tickets today** (transitions, comments, edits).
Credentials go to curl via stdin config (`-K -`), never on the command line
(argv is visible in the process list):

```bash
curl -s -K - "https://jira.gipmbh.de/rest/api/2/search?jql=assignee%20%3D%20currentUser()%20AND%20updated%20%3E%3D%20startOfDay()&fields=summary,status,updated" <<EOF
user = "$JIRA_USERNAME:$JIRA_PASSWORD"
EOF
```

Known gap: comments posted on OTHER people's tickets are not reliably
queryable — session memory covers those.

**Session memory** — memory files touched today plus what the current session
worked on: `find ~/.claude/projects/*/memory -maxdepth 1 -name "*.md" -newermt "$(date +%F)"`

## 3. Tempo reconciliation

Booked so far: `gipm time show --today`. Then present a table:

| Ticket | Evidence today | Booked | Gap |

For each worked-but-unbooked (or under-booked) ticket, propose a concrete
command with an estimated duration (from session time data when available,
otherwise ask):

```
gipm time log <TICKET> <dur> -m "<short comment>"
```

**Proposals only. Execute a booking ONLY after the user explicitly confirms
that specific booking. Never book automatically.**

## 4. Housekeeping

- Tickets that look finished → propose `gipm ticket close <TICKET>` (optionally
  `--log <dur>`); needs explicit confirmation.
- MRs with green pipelines and approvals → report as "ready to merge".
  **NEVER merge — merging always stays with the user.**
- Stale task dirs (ticket closed but workspace remains) → list them.
- Update per-ticket memory files with the day's end state.

## 5. Handoff note for tomorrow

Compare against today's plan (`~/.claude/rituals/plan/$(date +%F).md`, if any)
and write `~/.claude/rituals/handoff/$(date +%F).md`:

```markdown
# Handoff YYYY-MM-DD

## Done today
- <TICKET> — <what was accomplished> (booked: <dur>)

## Plan vs. done
- <planned item> — done / carried over / dropped (why)

## Open threads
- <TICKET> — where we stopped, next concrete step

## Tomorrow first
- <the single best entry point for tomorrow>
```

## 6. Prune old state

```bash
find ~/.claude/rituals/handoff ~/.claude/rituals/plan -name "*.md" -mtime +30 -delete
```

If JIRA is unreachable, still do the git scan, memory review, and handoff
note; state explicitly that the JIRA/Tempo sections are missing.
