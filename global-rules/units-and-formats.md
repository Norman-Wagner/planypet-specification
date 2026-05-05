# Einheiten und Formate

**Status:** GLOBAL GÜLTIG FÜR DAS GESAMTE PROJEKT

---

## 1. Einheitensystem

### 1.1 Interner Speicher (Datenbank)

**AUSSCHLIESSLICH metrisch** – KEINE Ausnahmen!

| Größe | Einheit | Beispiel |
|--------|--------|----------|
| Gewicht | Gramm (g) | 28000 |
| Länge/Distanz | Meter (m), Kilometer (km) | 3200, 5.5 |
| Temperatur | Celsius (°C) | 38.5 |
| Volumen | Liter (L), Milliliter (ml) | 1500 |

**Wichtig:** Gewicht wird IMMER als Integer in Gramm gespeichert (keine Kommazahlen).

### 1.2 Nutzeranzeige (UI)

Der Nutzer wählt im **Onboarding** oder in den **Einstellungen** zwischen:

- **METRISCH** (Standard in Europa)
- **IMPERIAL** (USA, UK)

Die Umrechnung erfolgt **AUSSCHLIESSLICH IN DER UI**. Die Datenbank speichert IMMER metrisch.

### 1.3 Umrechnungsfaktoren

```text
Gewicht:
1 kg = 1000 g
1 lb ≈ 453,592 g
1 oz ≈ 28,3495 g

Länge/Distanz:
1 km = 1000 m
1 mi ≈ 1609,34 m
1 ft ≈ 0,3048 m
1 in ≈ 0,0254 m

Temperatur:
°F = (°C × 9/5) + 32
°C = (°F - 32) × 5/9

Volumen:
1 gal (US) ≈ 3,78541 L
1 fl oz (US) ≈ 29,5735 ml
```

### 1.4 Beispiel-Workflow

1. **Nutzer gibt ein:** "28 kg" (wenn metrisch) oder "61.7 lb" (wenn imperial)
2. **App rechnet um:** 28 kg → 28000 g ODER 61.7 lb → 27988 g
3. **Datenbank speichert:** `weight: 28000` (immer in Gramm)
4. **App zeigt an:** "28 kg" (metrisch) oder "61.7 lb" (imperial)

---

## 2. Datums- und Zeitformate

### 2.1 Interner Speicher (Datenbank)

**IMMER ISO 8601 im UTC-Format:**

```text
2026-04-20T14:30:00Z
```

- **Datum:** YYYY-MM-DD
- **Zeit:** HH:MM:SS
- **Zeitzone:** Z (UTC)

### 2.2 Nutzeranzeige (UI)

**AUSSCHLIESSLICH gemäß den Systemeinstellungen des Geräts.**

- KEIN festes Format vorgeben
- iOS/Android formatiert automatisch korrekt
- Beispiele:
  - Deutschland: 20.04.2026, 14:30 Uhr
  - USA: 04/20/2026, 2:30 PM
  - Japan: 2026年04月20日 14:30

### 2.3 Zeitzonen-Handling

**Erinnerungen** (Fütterung, Medikamente) werden in der **LOKALEN ZEITZONE** des Nutzers gespeichert und ausgelöst.

**Bei Zeitzonenwechsel (Reise):**

1. App erkennt Standortänderung
2. Zeigt Dialog: "Du befindest dich in einer neuen Zeitzone. Möchtest du alle Erinnerungen anpassen?"
3. Optionen:
   - "Ja, an neue Zeitzone anpassen" (Zeiten bleiben logisch gleich, z.B. 18:00 Uhr Ortszeit)
   - "Nein, Original-Zeiten beibehalten" (Zeiten bleiben absolut gleich, z.B. 18:00 Uhr Berlin = 12:00 Uhr New York)

### 2.4 Relative Zeitangaben

In der UI:

- **Heute:** "vor 2 Std.", "in 45 Min."
- **Diese Woche:** "Gestern", "Morgen"
- **Älter:** "15. April 2026"

---

## 3. Währungen (optional, für zukünftige Features)

**Falls Preise angezeigt werden:**

- Intern: Cent/Pence (Integer)
- Anzeige: Währungssymbol gemäß Systemeinstellung
- Beispiel: 1500 (intern) → "15,00 €" (DE) oder "$15.00" (US)

---

## 4. Zusammenfassung der Regeln

| Kategorie | Intern | Anzeige |
|-----------|--------|--------|
| Gewicht | Gramm (g) | kg/lb je nach Einstellung |
| Distanz | Meter (m) | km/mi je nach Einstellung |
| Temperatur | Celsius (°C) | °C/°F je nach Einstellung |
| Datum | ISO 8601 UTC | Systemeinstellung |
| Zeit | HH:MM:SS UTC | Systemeinstellung |
| Zeitzone | UTC | Lokal mit Anpassungsoption |

**Keine Abweichungen erlaubt!**
