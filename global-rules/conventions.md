# Namenskonventionen und Sprachregelung

## Datenbank vs. Code
- Supabase/PostgreSQL Feldnamen: snake_case (z. B. `date_of_birth`, `feeding_events`)
- Dart-Klassen und Felder: camelCase (z. B. `dateOfBirth`, `FeedingEvent`)
- JSON-Serialisierung: Schlüssel in snake_case, Mapping in Dart via `@JsonKey(name: '...')`

## Enum-Namen
- Enum-Typen: PascalCase (z. B. `FoodType`, `ReminderType`)
- Enum-Werte: camelCase (z. B. `dryFood`, `vetVisit`)

## Fehlercodes
- Format: `BEREICH_KURZBESCHREIBUNG` (z. B. `AUTH_INVALID_EMAIL`, `FEEDING_AMOUNT_TOO_HIGH`)

## Sprache
- Feldnamen, Variablen, Funktionen: Englisch
- Beispielwerte, Beschreibungen, UI-Texte: Deutsch
- Commit-Messages: Deutsch
