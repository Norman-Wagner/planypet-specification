# No-Emoji-Policy

**Status:** GLOBAL GÜLTIG FÜR DAS GESAMTE PROJEKT

---

## 1. Grundregel

**KEINE Emojis in UI-Texten, Labels oder Buttons.**

Emojis dürfen **NUR** in nutzergenierten Inhalten verwendet werden (z.B. Notizen, Beschreibungen, Familiennachrichten).

---

## 2. Warum?

### 2.1 Barrierefreiheit

- **Screenreader:** Emojis werden oft falsch oder gar nicht vorgelesen (z.B. 🐶 = "dog face" statt "Hund")
- **Nutzer mit Sehbehinderung:** Emojis sind schwer erkennbar bei geringer Größe oder schlechtem Kontrast

### 2.2 Plattformabhängigkeit

- Emojis sehen auf iOS, Android und verschiedenen OS-Versionen unterschiedlich aus
- Missverständnisse durch abweichende Darstellung möglich

### 2.3 Professionelles Erscheinungsbild

- Planypet ist ein Tool für die Haustierverwaltung, keine Chat-App
- Klare, textbasierte Labels sind eindeutiger

---

## 3. Erlaubte Verwendungen

### 3.1 Nutzer-generierte Inhalte

- **Notizen:** "Luna liebt 🥩"
- **Familiennachrichten:** "Gassi war toll! 🐾"
- **Fotoalbum-Beschreibungen:** "Spielplatz 🌳"

### 3.2 Avatar-Auswahl (optional)

- Nutzer kann **optional** ein Emoji als Tier-Avatar wählen (z.B. 🐶 statt Foto)
- Speicherung: `avatar_type: "emoji"`, `avatar_value: "U+1F436"`
- **Aber:** Immer mit Textlabel kombinieren ("Luna 🐶" oder nur "Luna")

---

## 4. Verbotene Verwendungen

### 4.1 Buttons

❌ **Falsch:**
```text
[💾 Speichern]
```

✅ **Richtig:**
```text
[Speichern]
```

### 4.2 Labels

❌ **Falsch:**
```text
📅 Geburtsdatum
```

✅ **Richtig:**
```text
Geburtsdatum
```

### 4.3 Navigation

❌ **Falsch:**
```text
🏠 🐾 👥 👤
(Nur Emojis, kein Text)
```

✅ **Richtig:**
```text
Home | Haustiere | Community | Profil
(Nur Text, oder Text + Icon)
```

### 4.4 Status-Indikatoren

❌ **Falsch:**
```text
✅ Aktiv
❌ Inaktiv
```

✅ **Richtig:**
```text
● Aktiv (grüner Punkt)
○ Inaktiv (grauer Punkt)
```

---

## 5. Alternative: Icons statt Emojis

**Verwende System-Icons (SF Symbols / Material Icons):**

| Zweck | Emoji (Verboten) | Icon (Erlaubt) |
|-------|-----------------|---------------|
| Home | 🏠 | house.fill |
| Haustiere | 🐾 | pawprint.fill |
| Community | 👥 | person.2.fill |
| Profil | 👤 | person.crop.circle |
| Fütterung | 🍖 | fork.knife |
| Gassi | 🚶 | figure.walk |
| Gesundheit | ❤️ | heart.fill |
| Kamera | 📸 | camera.fill |

**Icons sind:**
- Plattformspezifisch gestaltet (iOS/Android)
- Barrierefrei (haben accessibility-Labels)
- Konsistent in Größe und Stil

---

## 6. Spezialfall: App-Icon

**Das App-Icon selbst** darf visuelle Elemente enthalten, die Emoji-ähnlich wirken (z.B. eine stilisierte Pfote).

**Aber:** Es ist kein echtes Emoji-Zeichen (U+1F43E), sondern eine Vektorgrafik.

---

## 7. Zusammenfassung

| Verwendung | Erlaubt? | Beispiel |
|------------|---------|----------|
| Buttons | ❌ Nein | "Speichern" (kein 💾) |
| Labels | ❌ Nein | "Geburtsdatum" (kein 📅) |
| Navigation | ❌ Nein | "Home" + Icon (kein 🏠) |
| Status | ❌ Nein | "● Aktiv" (kein ✅) |
| Nutzernotizen | ✅ Ja | "Luna liebt 🥩" |
| Avatar (optional) | ✅ Ja | "🐶" als Tier-Avatar |
| Icons | ✅ Ja | SF Symbols / Material Icons |

**Keine Abweichungen erlaubt!**
