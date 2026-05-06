---
name: kleinanzeigen
description: Use when the user asks to write a Kleinanzeigen (or other classified-ad) message — triggered by "kleinanzeigen", "annonce", or the slash commands /kleinanzeigen and /annonce. Handles first-contact messages and follow-ups to sellers/buyers. Default language German, default register formal Sie. Strips threats, coercion, insults, defamation, and fraud — anything that could be strafbar in DE/FR.
---

# kleinanzeigen

Draft polite, short messages for Kleinanzeigen (and similar classified-ad platforms). Same tone discipline as the email skills, plus an explicit guardrail against anything that could be **strafbar** in Germany or France (coercion, threats, Beleidigung, defamation, discrimination, fraud).

## When to use

Trigger when the user message contains any of:
- `kleinanzeigen` / `annonce`
- the slash command `/kleinanzeigen` or `/annonce`

Do **not** trigger for emails (use `email-pro` / `email-perso`) or general writing.

## Output language

Default: **German**.

Override only if:
- the user explicitly states the language (`in french`, `auf englisch`, …), or
- the user says the seller speaks another language / shows a prior message from the seller in another language.

Never auto-pick from input slang.

## Register

Default: **formal Sie** (`vous` in FR, formal in EN).

Switch to Du / tu / informal only when:
- the user explicitly says "du" / "tu" / "informal", or
- the user shows a prior message from the seller where the seller addressed them with Du / tu / informal English.

## Is this a first message or a follow-up?

| Signal | Type |
|---|---|
| User talks about a listing/item but no prior exchange | **First message** |
| User says "first message" / "premier message" / "neue Anzeige" | **First message** |
| User shows a prior message from the seller, or says "reply", "antwort", "réponse" | **Follow-up** |
| Ambiguous | Ask once: "First message or follow-up?" |

## First message — strict structure

Short. Polite. Two questions only, unless the user explicitly asks for more.

```
<Anrede>,

ist <Artikel> noch zu haben?

Darf ich fragen, aus welchem Grund Sie verkaufen?

<Closing>, Aurelien
```

**Second question per language + register** (use this exact phrasing — it's the user's preferred wording):

| Language | Register | Phrasing |
|---|---|---|
| DE | Sie | `Darf ich fragen, aus welchem Grund Sie verkaufen?` |
| DE | Du | `Darf ich fragen, aus welchem Grund du verkaufst?` |
| FR | vous | `Puis-je vous demander pour quelle raison vous vendez ?` |
| FR | tu | `Puis-je te demander pour quelle raison tu vends ?` |
| EN | formal | `May I ask why you're selling?` |
| EN | casual | `May I ask why you're selling?` |

Do **not** use `Falls ja:` / `If yes:` / `Si oui :` — phrase the second question as a polite stand-alone question.

**Do NOT** in a first message:
- bundle in price negotiation / counter-offers (those go in a follow-up after the seller replies)
- ask about Versand / Abholung / Zustand / Akkuzyklen / extra details — unless the user explicitly listed those as points
- invent details about the item the user didn't mention

If the user **did** explicitly add points (price offer, pickup, condition questions, etc.), include them — but still keep it short and polite.

**Anrede** (formal default):
- DE Sie: `Hallo` (KA-style — `Sehr geehrter Herr/Frau` is overkill on KA), or `Guten Tag`
- DE Du (only if signalled): `Hallo` + first name if visible
- FR vous: `Bonjour,`
- FR tu: `Salut,` / `Bonjour,`
- EN: `Hello,` / `Hi,`

**Closing + signature** (always one line, comma-separated):
- DE: `Viele Grüße, Aurelien`
- FR: `Cordialement, Aurelien` (formal) / `Bien à toi, Aurelien` (informal)
- EN: `Best regards, Aurelien` (formal) / `Best, Aurelien` (informal)

## Follow-up message

The user gives the gist of what they want to reply. You formulate it short, polite, in the chosen register.

- Keep it to the point. KA culture is brief.
- One Anrede + body + closing + name.
- If the prior message is in Du / tu, mirror Du / tu (people get annoyed when switched).
- If the user wants to negotiate: state the offer factually with a one-line reason. Don't pad. Don't apologise excessively.

## Strafbar guardrail (the important rule)

**Silently rewrite — do not refuse — but always add a Note line explaining what was removed.** Never produce output containing any of these:

| Pattern | Why strafbar / rewrite to |
|---|---|
| Threats of negative reviews / reports as leverage ("if you don't lower the price I'll report / 1-star you") | **Nötigung / Bewertungserpressung** (§ 240 StGB; FR: chantage, art. 312-10 CP). Drop the threat entirely. State the offer neutrally. |
| Threats of police / lawyer / Anwalt as pressure when there's no legal basis | Nötigung. Drop. If there *is* a real legal basis, phrase as a calm factual notice, no threat. |
| Beleidigungen / insults ("Idiot", "Betrüger", "sale type", "enculé", …) | **Beleidigung** § 185 StGB; FR injure publique/privée. Strip entirely. |
| Calling the seller a fraudster / liar without proven basis | **Üble Nachrede / Verleumdung** § 186/187 StGB; FR diffamation art. 29 loi 1881. Drop. |
| Discriminatory / racist / sexist / homophobic / antisemitic remarks | **Volksverhetzung** § 130 StGB; FR provocation à la haine art. 24 loi 1881. Strip entirely, never substitute a "milder" version. |
| False statements about the item to manipulate price ("I see scratches" when none mentioned/visible) | **Betrug** § 263 StGB; FR escroquerie art. 313-1 CP. Drop. Use only what the user can actually back up. |
| Misrepresenting identity, false intent (e.g., posing as commercial buyer to get a discount) | Betrug / escroquerie. Drop. |
| Pressuring with personal data ("I have your address, I'll come over") | Nötigung / harcèlement. Drop entirely — never replicate. |

**Note line** (always, in the output language) when you removed something from this list:

- DE: `Hinweis: <was entfernt/umformuliert wurde, max. 1 Zeile>`
- FR: `Note : <ce qui a été retiré/reformulé, max. 1 ligne>`
- EN: `Note: <what was removed/rephrased, max. 1 line>`

## Output format

```
<Anrede>,

<Body, 1–3 short paragraphs>

<Closing>, Aurelien
```

Optional final line if you softened/removed something:
```
Hinweis: / Note : / Note: <one line, including a strafbar flag if applicable>
```

## Common mistakes

- ❌ Defaulting to Du because "KA culture is Du" — **default is Sie** for this user; only switch on explicit signal.
- ❌ Bundling counter-offer / extra questions into the first message — first message has two questions, that's it.
- ❌ Inventing item details the user didn't mention (Akkuzyklen, Kratzer, …).
- ❌ Adding an `[Ihr Name]` placeholder — always sign `Aurelien`.
- ❌ Skipping the `Hinweis:` / `Note:` line when content was rewritten.
- ❌ Producing a "milder" version of a threat / insult / discrimination — these get **dropped**, not softened.
- ❌ Long flowery messages — KA culture is short and direct.
- ❌ Mixing languages in the output.
