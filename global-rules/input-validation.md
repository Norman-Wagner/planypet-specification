# Eingabevalidierung

**Status:** GLOBAL GÜLTIG FÜR ALLE FORMULARE

---

## 1. Alter / Geburtsdatum

### Option A: Genaues Geburtsdatum

- **UI-Element:** Systemeigener Date-Picker
- **Format:** YYYY-MM-DD (intern ISO 8601)
- **Validierung:**
  - Datum darf nicht in der Zukunft liegen
  - Maximalalter: 100 Jahre (kann angepasst werden)
- **Speicherung:** `birth_date: "2021-03-15"`, `is_estimated_birth_date: false`

### Option B: Geschätztes Alter

- **UI-Elemente:** Zwei Felder
  - "Jahre" (0-50, Spinner oder Texteingabe)
  - "Monate" (0-11, Spinner oder Texteingabe)
- **Berechnung:** Die App berechnet ein **fiktives Geburtsdatum**:
  - `birth_date = heute - (Jahre * 365,25 Tage) - (Monate * 30,44 Tage)`
  - Beispiel: Heute ist 01.05.2026, Alter "3 Jahre 2 Monate" → `birth_date: "2023-03-01"`
- **Speicherung:** `birth_date: "2023-03-01"`, `is_estimated_birth_date: true`
- **Flag:** `is_estimated_birth_date: true` kennzeichnet, dass es sich um eine Schätzung handelt

**UI-Hinweis:** "Das exakte Datum ist unbekannt" (Checkbox oder Toggle)

---

## 2. Gewicht

### Eingabe

- **UI-Element:** Numerisches Textfeld mit Einheit
- **Einheit:** Zeigt "kg" oder "lb" je nach Nutzereinstellung
- **Validierung:**
  - Nur Zahlen erlaubt
  - Min: 0.001 (für kleine Vögel/Fische)
  - Max: 1000 (für sehr große Tiere)
  - Dezimalstellen: maximal 3 (z.B. 0.015 kg = 15 g)

### Verarbeitung

1. **Nutzer gibt ein:** "28.5 kg" (metrisch) oder "62.8 lb" (imperial)
2. **App rechnet um in Gramm:**
   - 28.5 kg × 1000 = 28500 g
   - 62.8 lb × 453.592 = 28485 g
3. **Datenbank speichert:** `weight: 28500` (KEINE Kommazahlen, nur ganze Gramm)
4. **Rundung:** Auf nächstes Gramm runden

### Fehlerbehandlung

- **Leer:** "Bitte Gewicht eingeben"
- **Ungültig:** "Bitte eine gültige Zahl eingeben"
- **Zu klein/groß:** "Gewicht muss zwischen 0.001 kg und 1000 kg liegen"

---

## 3. Uhrzeit

### Eingabe

- **UI-Element:** NUR systemeigener Time-Picker
  - iOS: UIDatePicker (Mode: Time)
  - Android: TimePickerDialog
- **Format:** Automatisch 12h (US) oder 24h (DE) je nach Systemeinstellung

### Speicherung

- **Intern:** HH:MM im 24h-Format
- **Beispiel:** "18:00" (nicht "6:00 PM")
- **Datentyp:** String oder Time-Objekt (je nach Datenbank)

### Validierung

- Keine manuelle Eingabe → keine Validierung nötig
- System-Picker liefert immer gültige Werte

---

## 4. Chip-Nummer

### Eingabe

- **UI-Element:** Texteingabe mit Tastatur "number"
- **Länge:** 9, 10 oder 15 Ziffern
- **Format:** Nur Ziffern, keine Buchstaben oder Sonderzeichen

### Verarbeitung

1. **Nutzer gibt ein:** "123 456 789 012 345" (mit Leerzeichen zur Lesbarkeit)
2. **App entfernt Leerzeichen:** "123456789012345"
3. **Validierung:**
   - Nur Ziffern: `/^[0-9]+$/`
   - Länge: 9, 10 oder 15
4. **Speicherung:** `chip_number: "123456789012345"`

### Fehlerbehandlung

- **Ungültige Zeichen:** "Nur Ziffern erlaubt"
- **Falsche Länge:** "Chip-Nummer muss 9, 10 oder 15 Ziffern haben"

### Optionale Erweiterung: Barcode-Scanner

- Button "Scannen" öffnet Kamera
- Erkennt Code-128 und DataMatrix
- Füllt Feld automatisch aus

---

## 5. Medikamentendosierung

### Eingabe

- **Zwei Felder:**
  1. **Wert:** Numerisches Textfeld (z.B. "50")
  2. **Einheit:** Dropdown mit festen Optionen

### Erlaubte Einheiten (Enum)

```typescript
enum DosageUnit {
  mg = "mg",          // Milligramm
  ml = "ml",          // Milliliter
  tablets = "Tabletten",
  iu = "IE"           // Internationale Einheiten
}
```

### KEINE AUTOMATISCHE UMRECHNUNG!

Der Nutzer muss **exakt die tierärztliche Anweisung** eingeben.

**Beispiel:**
- Tierärztliche Verordnung: "2 ml morgens"
- Eingabe: `value: 2`, `unit: ml`
- Speicherung: `{"value": 2, "unit": "ml"}`

### Validierung

- **Wert:** Nur Zahlen, min: 0.01, max: 10000
- **Einheit:** Muss aus Enum ausgewählt werden

### Fehlerbehandlung

- **Leer:** "Bitte Dosierung eingeben"
- **Ungültig:** "Bitte eine gültige Zahl eingeben"

---

## 6. E-Mail

### Eingabe

- **UI-Element:** Texteingabe mit Tastatur "email"
- **Format:** RFC 5322 Standard

### Validierung

- **Regex:** `/^[^\s@]+@[^\s@]+\.[^\s@]+$/` (einfache Prüfung)
- **Erweitert:** Bibliothek wie `email-validator` (Flutter)

### Fehlerbehandlung

- **Leer:** "Bitte E-Mail-Adresse eingeben"
- **Ungültig:** "Bitte eine gültige E-Mail-Adresse eingeben"

---

## 7. Telefonnummer

### Eingabe

- **UI-Element:** Texteingabe mit Tastatur "phone"
- **Format:** International mit Ländervorwahl empfohlen

### Validierung

- **Min:** 7 Zeichen (lokale Nummern)
- **Max:** 20 Zeichen (internationale Nummern)
- **Erlaubte Zeichen:** Ziffern, `+`, `-`, `(`, `)`, Leerzeichen
- **Regex:** `/^[0-9+\-\(\) ]+$/`

### Optionale Erweiterung: Kontaktauswahl

- Button "Aus Kontakten wählen"
- Öffnet Systemkontakte

---

## 8. URL

### Eingabe

- **UI-Element:** Texteingabe mit Tastatur "url"
- **Format:** Vollständige URL mit Protokoll

### Validierung

- **Muss beginnen mit:** `http://` oder `https://`
- **Regex:** `/^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$/`

### Fehlerbehandlung

- **Ungültig:** "Bitte eine gültige URL eingeben (z.B. https://beispiel.de)"

---

## 9. Passwort

### Anforderungen

- **Mindestlänge:** 8 Zeichen
- **Empfohlen:** 12+ Zeichen
- **Muss enthalten:**
  - Mindestens 1 Großbuchstaben
  - Mindestens 1 Kleinbuchstaben
  - Mindestens 1 Ziffer
  - Optional: 1 Sonderzeichen

### UI-Elemente

- **Passwort-Eingabefeld** (verdeckt)
- **"Anzeigen"-Button** (Auge-Icon)
- **Stärkeanzeige:** Balken (Rot/Gelb/Grün)

### Validierung

```regex
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$
```

### Fehlerbehandlung

- **Zu kurz:** "Passwort muss mindestens 8 Zeichen haben"
- **Zu schwach:** "Passwort muss Groß- und Kleinbuchstaben sowie Ziffern enthalten"

---

## 10. Zusammenfassung der Validierungsregeln

| Feld | UI-Element | Validierung | Speicherung |
|------|-----------|-------------|-------------|
| Geburtsdatum | Date-Picker | Nicht in Zukunft | ISO 8601 |
| Alter (geschätzt) | Jahre + Monate | 0-50 Jahre, 0-11 Monate | Fiktives Datum + Flag |
| Gewicht | Numerisch + Einheit | 0.001-1000 kg | Integer in Gramm |
| Uhrzeit | Time-Picker | Automatisch gültig | HH:MM (24h) |
| Chip-Nummer | Numerisch | 9/10/15 Ziffern | String ohne Leerzeichen |
| Medikamentendosierung | Wert + Enum | Wert > 0, Einheit aus Liste | JSON {value, unit} |
| E-Mail | Text (email) | RFC 5322 | String |
| Telefon | Text (phone) | 7-20 Zeichen | String |
| URL | Text (url) | http(s):// | String |
| Passwort | Verdeckt | Min 8 Zeichen, Mix | Gehasht (bcrypt) |

---

## 11. Globale Formular-Regeln

1. **Pflichtfelder:** Mit `*` markiert
2. **Fehlertext:** Erscheint UNTER dem Feld in Rot
3. **"Speichern"-Button:** Deaktiviert, solange Pflichtfelder ungültig sind
4. **Echtzeit-Validierung:** Bei Eingabe (nicht erst beim Absenden)
5. **Fokus:** Nach Fehler automatisch auf erstes ungültiges Feld

**Keine Abweichungen erlaubt!**
