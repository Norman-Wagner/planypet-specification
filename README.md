# Planypet Specification

![Planypet Logo](https://via.placeholder.com/200x200/001F3F/FFFFFF?text=Planypet)

**Vollständige Spezifikation der mobilen Planypet-App für KI-basierte Flutter-Code-Generierung**

---

## 📋 Über dieses Repository

Dieses Repository enthält die vollständige, ungekürzte Spezifikation der Planypet-App. Ziel ist es, dass ein KI-Coding-Tool (z.B. **Claude Code**, **Cursor**, **GitHub Copilot**) auf Basis dieser Dokumente den kompletten Flutter-Code generieren kann.

---

## 🗂️ Struktur

```
planypet-specification/
├── README.md                      # Diese Datei
├── MASTER_SPEC.md                 # Zentrale Übersicht
├── architecture/                  # System-Architektur
│   ├── 01-system-overview.md
│   ├── 02-tech-stack.md
│   ├── 03-data-models.md
│   └── 04-offline-sync.md
├── features/                      # Funktionale Module
│   ├── pet-profiles.md
│   ├── feeding.md
│   ├── inventory.md
│   ├── walks.md
│   ├── reminders.md
│   ├── health.md
│   ├── community.md
│   ├── ai-assistant.md
│   ├── registry.md
│   └── checklists.md
├── design/                        # Design System
│   ├── design-system.md
│   ├── navigation.md
│   ├── screens.md
│   └── accessibility.md
└── global-rules/                  # Globale Vorgaben
    ├── units-and-formats.md
    ├── input-validation.md
    ├── no-emoji-policy.md
    └── form-and-label-rules.md
```

---

## 🚀 Verwendung

### Für KI-Coding-Tools

1. **Starte mit `MASTER_SPEC.md`** für einen Überblick
2. **Lies alle Dateien in `global-rules/`** – diese gelten IMMER
3. **Verstehe die Architektur** in `architecture/`
4. **Implementiere das Design System** aus `design/`
5. **Baue Features Schritt für Schritt** aus `features/`

### Für Entwickler

Du kannst diese Spezifikation auch manuell verwenden:

```bash
# Repository klonen
git clone https://github.com/Norman-Wagner/planypet-specification.git

# Dokumentation lesen
cd planypet-specification
cat MASTER_SPEC.md
```

---

## 🎯 Kernprinzipien

- **Offline-First:** Alle Kernfunktionen müssen ohne Internet funktionieren
- **Metrisch intern:** Daten werden IMMER metrisch gespeichert (g, m, °C)
- **DSGVO-konform:** Lokale KI-Analysen, keine unnötigen Cloud-Uploads
- **Barrierefrei:** WCAG AA, Touch-Ziele ≥44x44px, Screenreader
- **Multi-Tier:** Hunde, Katzen, Vögel, Reptilien, Fische, Exoten

---

## 📱 Tech Stack

- **Frontend:** Flutter (iOS & Android)
- **Backend:** Supabase (PostgreSQL + Auth + Storage)
- **Offline-Sync:** PowerSync
- **KI:** TensorFlow Lite (lokal), Claude/GPT API (optional)
- **Maps:** OpenStreetMap
- **Wetter:** WeatherKit (iOS) / Open-Meteo (Android)

---

## 📄 Lizenz

Proprietary – Alle Rechte vorbehalten.  
**Kontakt:** norman.wagner@planypet.com

---

## 🔗 Links

- [MASTER_SPEC.md](MASTER_SPEC.md) – Zentrale Übersicht
- [Design System](design/design-system.md) – Farben, Schriften, Komponenten
- [Datenmodelle](architecture/03-data-models.md) – JSON-Strukturen

---

**Stand:** Mai 2026  
**Version:** 1.0
