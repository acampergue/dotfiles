---
name: email-pro
description: Use when the user asks to write/draft a professional work email — triggered by phrases like "write a pro email", "write an pro email", "draft a pro email", or the slash command /email-pro. Input may be in German, English, or French; output is always professional German.
---

# email-pro

Draft a professional work email in German from notes the user provides in DE / EN / FR.

## When to use

Trigger when the user message contains any of:
- "write a pro email" / "write an pro email" / "draft a pro email" / "pro email"
- the slash command `/email-pro`

Do **not** trigger for casual messages, Slack drafts, or non-email writing.

## Output rules

1. **Always German.** Regardless of input language (DE / EN / FR), the email itself is written in proper professional German.
2. **No signature block.** The user's Outlook appends one automatically. End with the closing line (e.g. `Viele Grüße` / `Mit freundlichen Grüßen`) followed by the user's first name only, or no name at all if not provided. Never invent a title, company, phone, or email line.
3. **Subject line.** Always include a `Betreff:` line above the email. Concrete and specific — not "Frage" or "Update".
4. **Polite & professional always.** Strip passive-aggression, sarcasm, blame, and venting from the input. Keep the substance (the ask, the deadline, the consequence) but rephrase neutrally and constructively. Never preserve a jab "because the user wrote it".
5. **No commentary by default.** Output the email only. If you removed something significant from the input (a sarcastic line, a personal attack), add a single short line below the email: `Hinweis: <kurze Notiz, was entschärft/entfernt wurde>`. No long explanation.

## Register: Du vs. Sie

| Signal in input | Use |
|---|---|
| User says "colleague", "Kollege", "team", "intern", or names a `@gipmbh.de` recipient | **Du** |
| User says "Kunde", "customer", "client", "extern", "supplier", "Lieferant", or a non-GiP domain | **Sie** |
| User explicitly says "du" / "sie" | follow the user |
| Ambiguous (e.g. only a first name, no context) | **Ask once**: "Du oder Sie?" — then proceed |

Once chosen, stay consistent throughout (Anrede, pronouns, closing).

## German email conventions (quick reference)

**Anrede (opening):**
- Formal Sie: `Sehr geehrte Frau <Nachname>,` / `Sehr geehrter Herr <Nachname>,`
- Formal Sie, unknown name: `Sehr geehrte Damen und Herren,`
- Formal Du (colleague): `Hallo <Vorname>,` or `Hi <Vorname>,`

**Schluss (closing):**
- Sie: `Mit freundlichen Grüßen`
- Du: `Viele Grüße` / `Beste Grüße` / `Danke dir` (when ending with a thank-you)

**Body:**
- First letter after the comma in Anrede is **lowercase** (`Hallo Markus,\n\nich brauche...`).
- Capitalise the formal `Sie`, `Ihr`, `Ihnen`. Do **not** capitalise informal `du`, `dir`, `dich` in modern business correspondence (Duden allows lowercase; lowercase is the current standard).
- Keep paragraphs short (2–4 lines). One idea per paragraph.
- Be concrete: name the artifact, the deadline, the next step.

## Tone-rewrite examples

| Input phrase | Rewrite |
|---|---|
| "frankly it's getting ridiculous" | drop entirely; replace with a factual `zum dritten Mal` if repetition is the point |
| "thanks for nothing on X" | drop entirely — never include in a work email |
| "if you don't do X I'll escalate" | `Sollte das bis <Datum> nicht möglich sein, müsste ich es an <Rolle> weitergeben — das würde ich gern vermeiden.` |
| "you keep saying tomorrow" | `die Zusage stand zuletzt für <Tag> aus` |
| "ASAP" / "now" | concrete deadline (`bis heute 17:00`, `bis Freitag EOD`) |

## Output format

```
Betreff: <konkreter Betreff>

<Anrede>,

<Body, 1–4 short paragraphs>

<Closing>
<Vorname or nothing>
```

Optional final line if you softened something:
```
Hinweis: <was entschärft/entfernt wurde, max. 1 Zeile>
```

## Common mistakes

- ❌ Adding a full signature block (name, title, GiP mbH, phone) — Outlook does this.
- ❌ Echoing English/French phrases that slipped through ("ASAP", "FYI", "best") — translate or drop.
- ❌ Writing `Du` capitalised in modern business correspondence — lowercase `du/dir/dich` is current standard.
- ❌ Writing `sie` lowercase when meaning formal `Sie` — must be capitalised.
- ❌ Vague subject lines (`Frage`, `Kurze Info`) — be specific.
- ❌ Preserving sarcasm/blame because "the user wrote it that way" — always rewrite.
- ❌ Long explanations after the email — at most one `Hinweis:` line.
