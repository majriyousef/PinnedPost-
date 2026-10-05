# Repository-Regeln

- Lies `CLAUDE.md` vor jeder inhaltlichen Änderung.
- Bearbeite keine Dateien unter `references/`; sie sind unveränderte Quellen.
- Neue bestätigte Fakten kommen in `knowledge/`, operative Abläufe in `sops/`.
- Unsichere Informationen werden als `OFFEN` markiert, nicht als Tatsache formuliert.
- Rohchats, Handles, Passwörter, Tokens und Zahlungsdaten dürfen nicht committed werden.
- Änderungen an Regeln erhalten einen Eintrag in `CHANGELOG.md` mit Quelle und Datum.
- Vor Abschluss `powershell -ExecutionPolicy Bypass -File scripts/validate_repo.ps1` ausführen.
