---
name: morgen
description: Tagesstart — collect standup data, review high-priority tickets, unfinished work from yesterday and waiting MRs, then propose a prioritized day plan. Use at the start of the workday.
model: opus[1m]
---

# Morgen — Day Kickoff

Brief the user on their day and agree on a prioritized plan. Narrate in
English; show German source text (ticket summaries, comments) verbatim in a
clearly marked block alongside any translation.

`gipm` may not be on `PATH` — fall back to `~/workspace/gipm/.venv/bin/gipm`.

## 1. Mark the run

Create the state dir if missing and write the marker FIRST (reminders check it):

```bash
mkdir -p ~/.claude/rituals/handoff ~/.claude/rituals/plan
date +%F > ~/.claude/rituals/last-morgen
```

## 2. Gather (run these in parallel)

- `gipm daily` — standup: yesterday's worklogs, today so far, in review, active, blockers
- `gipm ticket list` — open tickets, priority-sorted
- `gipm mr list` — open MRs
- Latest handoff note before today: `ls ~/.claude/rituals/handoff/ | sort | awk -v t="$(date +%F).md" '$0 < t' | tail -1` (then read that file)
- Task workspaces: `ls ~/workspace/tasks/`

If JIRA/GitLab calls fail (VPN down), present what IS available, state
explicitly which sections are missing, and point the user at the VPN
reconnect procedure (`~/bin/connect_vpn.sh`). Never fail silently.

## 3. Present the briefing

- **High-priority tickets**: those with priority `Hoch`/`Höchste` or a near
  due date, each with the German summary verbatim + English translation.
  Remaining tickets as a one-line-each compact backlog.
- **Unfinished from yesterday**: open threads from the handoff note. If no
  handoff exists, reconstruct from memory and a quick git scan of
  `~/workspace/tasks/*/` (dirty trees, unpushed branches) and say the handoff
  was missing.
- **MRs needing attention**: failed pipelines, reviews waiting on the user.
- **Stale workspaces**: task dirs under `~/workspace/tasks/` whose ticket is
  no longer in the open-ticket list.

## 4. Propose the day plan

Suggest "today: 1, 2, 3" with one line of reasoning each, ordered by:

1. Unfinished work from yesterday (finish before starting new)
2. Priority and due dates
3. Quick wins

Adjust in dialogue with the user. When agreed, write the plan to
`~/.claude/rituals/plan/$(date +%F).md`:

```markdown
# Plan YYYY-MM-DD

1. <TICKET> — <intent for today>
2. ...

## Also on the radar
- <deferred items / waiting-on-others>
```

Do NOT start any ticket automatically — offer `gipm ticket start` for the top
item and let the user decide.
