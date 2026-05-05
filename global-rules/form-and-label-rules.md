# Formular- und Label-Regeln

**Status:** GLOBAL GÜLTIG FÜR ALLE FORMULARE

---

## 1. Label-Positionierung

### 1.1 Grundregel

**JEDES Eingabefeld hat ein Label OBERHALB des Feldes.**

```text
[Label]
[Eingabefeld]
```

**NICHT:**
- Label innerhalb des Feldes (Placeholder darf zusätzlich verwendet werden)
- Label rechts oder links neben dem Feld
- Label unter dem Feld

### 1.2 Beispiel

✅ **Richtig:**
```text
Name *
[________________]
```

❌ **Falsch:**
```text
[Name *__________]  (Label im Feld)
```

❌ **Falsch:**
```text
Name * [________]  (Label neben dem Feld)
```

---

## 2. Pflichtfelder

### 2.1 Kennzeichnung

**Pflichtfelder werden mit einem Sternchen `*` markiert.**

```text
Name *
[________________]
```

**Position des Sternchens:** Direkt nach dem Label-Text (mit Leerzeichen)

### 2.2 Hinweis am Formularbeginn

Am Anfang jedes Formulars steht:

```text
* Pflichtfelder
```

(Kleiner Text, grau, oberhalb des ersten Feldes)

### 2.3 Optionale Felder

Optionale Felder haben **kein** Sternchen. Sie können optional mit "(optional)" gekennzeichnet werden:

```text
Zweitname (optional)
[________________]
```

---

## 3. Fehlerbehandlung

### 3.1 Fehlermeldungen

**Fehlertext erscheint UNTER dem Eingabefeld in Rot.**

```text
E-Mail *
[max@beispiel.de______]
❌ Bitte eine gültige E-Mail-Adresse eingeben
```

### 3.2 Fehler-Styling

- **Fehlertext:** Schriftgröße 14px, Farbe `#EF4444` (Rot)
- **Eingabefeld:** Roter Rahmen (2px) bei Fehler
- **Icon:** Optionales Fehler-Icon (❌ oder exclamationmark.circle)

### 3.3 Echtzeit-Validierung

**Validierung erfolgt bei:**
- **onBlur:** Nutzer verlässt das Feld (primär)
- **onChange:** Echtzeit während Eingabe (sekundär, für bessere UX)

**Nicht validieren:**
- **onFocus:** Beim ersten Betreten des Feldes (Nutzer hat noch nichts eingegeben)

### 3.4 Fokus nach Fehler

Nach Klick auf "Speichern" bei Fehlern:
1. Zeige alle Fehlermeldungen an
2. Scrolle zum **ersten ungültigen Feld**
3. Setze Fokus auf dieses Feld

---

## 4. Placeholder

### 4.1 Verwendung

Placeholder sind **optional** und dienen als Beispiel oder Hinweis.

**Sie ersetzen NICHT das Label!**

✅ **Richtig:**
```text
E-Mail *
[max@beispiel.de______]
(Placeholder: "max@beispiel.de")
```

❌ **Falsch:**
```text
[E-Mail *____________]
(Kein Label, nur Placeholder)
```

### 4.2 Styling

- **Farbe:** Hellgrau (#94A3B8 im dunklen Theme, #64748B im hellen Theme)
- **Schriftgröße:** Gleich wie Eingabetext (16px)
- **Verschwinden:** Sobald Nutzer zu tippen beginnt

---

## 5. Hilfstexte

### 5.1 Positionierung

**Hilfstexte erscheinen UNTER dem Label, OBERHALB des Eingabefeldes.**

```text
Passwort *
Mindestens 8 Zeichen, Groß- und Kleinbuchstaben
[________________]
```

### 5.2 Styling

- **Schriftgröße:** 14px (bodySmall)
- **Farbe:** Hellgrau (#64748B)
- **Icon:** Optionales Info-Icon (info.circle)

---

## 6. Buttons

### 6.1 Primärer Button ("Speichern", "Weiter")

- **Position:** Unten im Formular, volle Breite (minus Padding)
- **Höhe:** 48px (Touch-Ziel ≥44px)
- **Farbe:** Primary-Farbe (z.B. #3B82F6)
- **Text:** Weiß, 16px, bold
- **Zustand:**
  - **Aktiv:** Farbig, anklickbar
  - **Deaktiviert:** Grau (#9CA3AF), nicht anklickbar
  - **Ladend:** Spinner + "Wird gespeichert..."

### 6.2 Sekundärer Button ("Abbrechen", "Zurück")

- **Position:** Links neben Primärbutton oder darüber
- **Höhe:** 48px
- **Farbe:** Transparent mit Rahmen (1px, #475569)
- **Text:** #475569, 16px

### 6.3 Destruktiver Button ("Löschen", "Entfernen")

- **Farbe:** Rot (#EF4444)
- **Text:** Weiß
- **Bestätigungsdialog:** IMMER vor Ausführung anzeigen

---

## 7. Formularstruktur

### 7.1 Aufbau

```text
[Titel des Formulars]
[Kurze Beschreibung]

* Pflichtfelder

[Label 1] *
[Eingabefeld 1]

[Label 2]
[Eingabefeld 2]

...

[Primärer Button]
[Sekundärer Button]
```

### 7.2 Abstände (8px-Basis)

- **Zwischen Feldern:** 16px (md)
- **Label zu Feld:** 8px (sm)
- **Fehlertext zu nächstem Feld:** 16px (md)
- **Vor Buttons:** 24px (lg)
- **Zwischen Buttons:** 8px (sm)

---

## 8. Spezielle Eingabetypen

### 8.1 Dropdown/Select

```text
Rasse *
[Labrador ▼]
```

- **Icon:** Pfeil nach unten (▼ oder chevron.down)
- **Touch-Ziel:** Gesamte Breite des Feldes
- **Suchfunktion:** Bei >10 Optionen empfohlen

### 8.2 Radio Buttons

```text
Einheitensystem *
◯ Metrisch (kg, m, °C)
◉ Imperial (lb, ft, °F)
```

- **Abstand zwischen Optionen:** 12px
- **Touch-Ziel:** Gesamte Zeile (nicht nur Kreis)
- **Standard:** Erste Option ist vorab ausgewählt

### 8.3 Checkboxen

```text
☐ Ich akzeptiere die Datenschutzerklärung *
```

- **Touch-Ziel:** Gesamte Zeile (nicht nur Box)
- **Gruppierung:** Bei mehreren Checkboxen mit Zwischenüberschrift

### 8.4 Toggle/Switch

```text
Benachrichtigungen
[  ◯  |      ]  (aus)
[      | ●  ]  (an)
```

- **Label:** Links neben dem Switch
- **Zustand:** Farbwechsel (Grau → Blau)
- **Haptisches Feedback:** Bei Umschalten

### 8.5 Slider

```text
Aktivitätslevel *
1 [====●========] 5
```

- **Beschriftung:** Anfangs- und Endwert unter dem Slider
- **Aktueller Wert:** Über dem Knopf anzeigen

---

## 9. Tastatur-Typen

**Die App wählt automatisch die passende Tastatur:**

| Feld | Tastaturtyp |
|------|-------------|
| E-Mail | `email` |
| Telefon | `phone` |
| URL | `url` |
| Zahl | `number` |
| Text | `text` |
| Passwort | `text` (verdeckt) |

---

## 10. Barrierefreiheit

### 10.1 Accessibility-Labels

**Jedes Formular-Element muss ein `accessibilityLabel` haben:**

```dart
TextField(
  decoration: InputDecoration(labelText: "Name"),
  accessibilityLabel: "Name eingeben, Pflichtfeld",
)
```

### 10.2 Fehlermeldungen vorlesen

Bei Fehler muss der Screenreader sagen:

```text
"E-Mail, Pflichtfeld, Fehler: Bitte eine gültige E-Mail-Adresse eingeben"
```

### 10.3 Fokusreihenfolge

Die Tab-Reihenfolge muss logisch sein (von oben nach unten).

---

## 11. Zusammenfassung

| Regel | Beschreibung |
|-------|-------------|
| Label | IMMER oberhalb des Feldes |
| Pflichtfelder | Mit `*` markiert |
| Fehlertext | UNTER dem Feld in Rot |
| Placeholder | Optional, ersetzt NICHT das Label |
| Hilfstext | UNTER dem Label, OBERHALB des Feldes |
| Button-Höhe | 48px |
| Echtzeit-Validierung | Bei onBlur und onChange |
| Fokus | Nach Fehler auf erstes ungültiges Feld |
| Tastaturtyp | Automatisch passend |
| Accessibility | Labels für alle Elemente |

**Keine Abweichungen erlaubt!**
