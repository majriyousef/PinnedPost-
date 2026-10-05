# Leonie Claude Ops

Lokales Claude-Code-Repository für Leonies Onboarding, Chatting, Feed, Stories, Pinned Post, Listenpflege und Qualitätskontrolle.

## Schnellstart

1. Repository in Claude Code öffnen.
2. `CLAUDE.md` vollständig lesen lassen.
3. Für Model-Fakten zuerst `knowledge/leonie-model.md` verwenden.
4. Vor operativen Aufgaben `knowledge/operations-status.md` prüfen.
5. Den passenden Ablauf aus `sops/` anwenden.
6. Bei Widersprüchen die Quellenhierarchie in `CLAUDE.md` befolgen.

## Wichtige Befehle

- `/audit-chat`: Chat strukturiert backreaden und nächste Antwort empfehlen.
- `/reply`: eine kurze, passende Antwort in Leonies Stimme erstellen.
- `/create-feed-post`: Bild und Auftrag gegen Feed-SOP und Branding prüfen.
- `/analyze-ns`: New-Subscriber-Funnel und Drop-offs auswerten.

## Struktur

- `.claude/commands/`: wiederverwendbare Claude-Code-Befehle
- `knowledge/`: bestätigte Fakten, Stimme, Chat- und Pinned-Post-Erkenntnisse
- `sops/`: operative Standardabläufe
- `templates/`: einheitliche Arbeitsvorlagen
- `scripts/`: lokale Prüf- und Auswertungshilfen
- `references/`: importierte Originalquellen und ältere Masterunterlagen
- `sources/`: Herkunft, Abdeckung und bekannte Lücken

## Datenschutz

Rohchats und Subscriber-Daten gehören nicht dauerhaft in Git. Namen, Handles, Zahlungsdetails und intime persönliche Angaben von Fans werden nur verarbeitet, wenn sie für den konkreten Auftrag erforderlich sind. Für Analysen werden sie anonymisiert.

## Lokale Prüfung

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate_repo.ps1
powershell -ExecutionPolicy Bypass -File scripts/analyze_chat_export.ps1 data/example_chat_export.csv
```
