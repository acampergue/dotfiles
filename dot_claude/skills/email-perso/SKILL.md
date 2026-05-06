---
name: email-perso
description: Use when the user asks to write/draft a personal (non-work) email — triggered by phrases like "write a perso email", "write an email perso", "write a personal email", "draft a perso email", or the slash command /email-perso. Output language is asked every time (default German). Recipients can be friends, family, landlord, doctor, Behörden, online services.
---

# email-perso

Draft a personal (non-work) email. Triggered for friends, family, landlord/Hausverwaltung, doctor, Versicherung/Steuerberater/Behörden, online services & complaints.

## When to use

Trigger when the user message contains any of:
- "write a perso email" / "write an email perso" / "write a personal email" / "draft a perso email" / "perso email"
- the slash command `/email-perso`

Do **not** trigger for work emails (use `email-pro` instead) or non-email writing.

## Step 1 — Always ask the output language

The user mixes DE / FR / EN in their inputs all the time. **Never** auto-pick the language from the input or the recipient.

**Required first step:** if the user has not explicitly stated the output language (e.g. "in french", "auf deutsch", "in english", "en français"), **ask once** before drafting:

> In welcher Sprache soll die Mail sein? (DE / FR / EN — Default: DE)

Wait for the answer. Then draft.

If the user replies with anything ambiguous or just confirms ("default" / "yes" / "ok"), use **DE**.

## Step 2 — Pick the register from the recipient context

| Recipient signal | Register |
|---|---|
| Friend, family, sibling, parent, partner, close acquaintance | **Casual** (Du / tu / informal English) |
| Hausverwaltung, landlord, Vermieter, Versicherung, Steuerberater, Behörde, Amt, Anwalt, doctor's office, official service | **Formal** (Sie / vous / formal English) |
| Online service support (Amazon, eBay, Kleinanzeigen, etc.) | **Formal** (Sie / vous / formal English) |
| Friend's doctor / informal context with a professional | **Casual** unless user says otherwise |
| Ambiguous (just a first name, no context) | **Ask once**: "Du oder Sie? / tu ou vous? / formal or informal?" |

Once chosen, stay consistent throughout (Anrede, pronouns, closing).

## Step 3 — Tone policing (same as email-pro)

Strip passive-aggression, sarcasm, blame, vulgarity, and venting from the input. Keep the substance (the ask, the deadline, the consequence, the legal point) but rephrase neutrally and constructively.

This applies **regardless of register** — even casual emails to friends should not contain sarcasm/passive-aggression. (Light humor and warmth are fine in casual register; cutting jabs are not.)

Never preserve a jab "because the user wrote it".

## Step 4 — Sign with the right form

The user's personal mail client does **not** auto-append a signature. Always close with:

```
<Closing line in the chosen language>
<Name per register>
```

**Name to use:**
- Casual register → `Aurelien`
- Formal register → `Aurelien Campergue`

**Closing line per language + register:**

| Language | Casual | Formal |
|---|---|---|
| DE | `Viele Grüße` / `Beste Grüße` / `Liebe Grüße` (family/close friends) | `Mit freundlichen Grüßen` |
| FR | `Bien à toi` / `Amicalement` / `À bientôt` | `Cordialement` / `Mes sincères salutations` |
| EN | `Best` / `Cheers` / `Take care` | `Best regards` / `Kind regards` |

Pick the variant that fits the warmth of the relationship.

Never add phone, address, or invented title.

## Step 5 — Subject line

Always include a `Betreff:` (DE) / `Objet:` (FR) / `Subject:` (EN) line above the email. Concrete and specific — not "Frage" / "Question" / "Update".

## Step 6 — Hinweis line (the user wants this)

If you rewrote anything significant (sarcasm, vulgarity, passive-aggression, blame, mixed-language slang), add **one** short line below the email noting what you did, in the email's language:

- DE: `Hinweis: <was entschärft/entfernt wurde, max. 1 Zeile>`
- FR: `Note : <ce qui a été adouci/retiré, max. 1 ligne>`
- EN: `Note: <what was softened/removed, max. 1 line>`

Always add it when you softened something. The user explicitly wants to see what changed.

## Conventions per language

### German
- Anrede formal: `Sehr geehrte Frau <Nachname>,` / `Sehr geehrter Herr <Nachname>,` / `Sehr geehrte Damen und Herren,`
- Anrede casual: `Hallo <Vorname>,` / `Hi <Vorname>,` / `Liebe(r) <Vorname>,` (family/close)
- First word after the comma is **lowercase**.
- Capitalise formal `Sie / Ihr / Ihnen`. Lowercase informal `du / dir / dich` (current Duden standard).

### French
- Anrede formal: `Madame <Nom>,` / `Monsieur <Nom>,` / `Madame, Monsieur,` (unknown)
- Anrede casual: `Salut <Prénom>,` / `Coucou <Prénom>,` (close) / `Bonjour <Prénom>,`
- Mind accents: `à`, `é`, `è`, `ç`, `ô`, `û`. Always include them.
- Formal: `vous` (lowercase, but consistent throughout).

### English
- Formal: `Dear Ms / Mr <Lastname>,` / `Dear Sir or Madam,`
- Casual: `Hi <First name>,` / `Hey <First name>,`

## Output format

```
Betreff / Objet / Subject: <konkret>

<Anrede>,

<Body, 1–4 short paragraphs>

<Closing>
Aurelien   ← or "Aurelien Campergue" if formal
```

Optional final line if you softened something:
```
Hinweis: / Note : / Note: <one line>
```

## Common mistakes

- ❌ Not asking the language and auto-picking from input/recipient — **always ask** unless the user explicitly stated it.
- ❌ Leaving `[Your Name]` / `[Ihr Name]` / `[Votre nom]` placeholder — use `Aurelien` (casual) or `Aurelien Campergue` (formal).
- ❌ Skipping the `Hinweis:` line when sarcasm/slang/aggression was rewritten — the user wants to see what changed, every time.
- ❌ Mixing languages in the output (FR phrase slipping into DE email) — the user mixes in input on purpose; the **output** must be one clean language.
- ❌ Using formal Sie/vous with friends or casual Du/tu with Hausverwaltung/Steuerberater.
- ❌ Capitalising `du / dir / dich` in modern correspondence; forgetting to capitalise formal `Sie / Ihr / Ihnen`.
- ❌ Vague subject lines.
- ❌ Adding phone/address/invented title to the signature.
