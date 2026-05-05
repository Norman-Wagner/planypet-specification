# Planypet - Master Specification

**Version:** 1.0  
**Zieldatum:** Mai 2026  
**Zielplattformen:** iOS & Android (Flutter)  
**Backend:** Supabase + PowerSync (Offline-First)  

---

## Überblick

Planypet ist eine mobile App für die umfassende Verwaltung von Haustieren aller Art (Hunde, Katzen, Vögel, Reptilien, Fische, Exoten). Die App bietet:

- **Multi-Tier-Management** mit artenspezifischen Profilen
- **Offline-First-Architektur** (volle Funktionalität ohne Internet)
- **Familien-Sharing** mit Rollen und Aufgaben
- **KI-gestützte Features** (Gassi-Planung, Fotoanalyse, Wissensaktualisierung)
- **Gesundheitsverwaltung** (Dokumente, Impfungen, Laborwerte, Notfall-Hilfe)
- **Community-Features** (Betreuungsmarktplatz, Giftköder-Warnungen, Lost-Pet-Modus)

---

## Dokumentationsstruktur

Diese Spezifikation ist modular aufgebaut. Alle folgenden Dokumente müssen von einem KI-Coding-Tool (z.B. Claude Code) berücksichtigt werden:

### 1. Globale Regeln (IMMER GÜLTIG)
- [Einheiten und Formate](global-rules/units-and-formats.md)
- [Eingabevalidierung](global-rules/input-validation.md)
- [No-Emoji-Policy](global-rules/no-emoji-policy.md)
- [Formular- und Label-Regeln](global-rules/form-and-label-rules.md)

### 2. Architektur
- [System-Übersicht](architecture/01-system-overview.md)
- [Tech Stack](architecture/02-tech-stack.md)
- [Datenmodelle](architecture/03-data-models.md)
- [Offline-Synchronisation](architecture/04-offline-sync.md)

### 3. Design
- [Design System](design/design-system.md)
- [Navigation](design/navigation.md)
- [Screens](design/screens.md)
- [Accessibility](design/accessibility.md)

### 4. Features
- [Tier-Profile](features/pet-profiles.md)
- [Fütterung](features/feeding.md)
- [Vorratsverwaltung](features/inventory.md)
- [Gassi/Walks](features/walks.md)
- [Erinnerungen](features/reminders.md)
- [Gesundheit](features/health.md)
- [Community](features/community.md)
- [KI-Assistent](features/ai-assistant.md)
- [Chip-Registrierung](features/registry.md)
- [Checklisten](features/checklists.md)

---

## Wichtigste Prinzipien

1. **Exakte Umsetzung:** Alle Anforderungen sind verbindlich. Keine Abweichungen, keine Interpretationen.
2. **Offline-First:** Kernfunktionen müssen lokal funktionieren und später synchronisieren.
3. **Metrisch intern:** Alle Daten werden intern metrisch gespeichert. Umrechnung erfolgt nur in der UI.
4. **Barrierefreiheit:** WCAG AA, Touch-Ziele ≥44x44px, Screenreader-Unterstützung.
5. **DSGVO-konform:** Lokale KI-Analysen, verschlüsselte Daten, Datenlöschung jederzeit möglich.

---

## Testplan (nach Implementierung)

1. **Erster Start:** Onboarding, leeres Dashboard, Theme-Wechsel
2. **Tier hinzufügen:** Validierung, Speicherung, Avatar-Switcher
3. **Fütterung protokollieren:** Vorrat reduziert, Eintrag in Feed
4. **Offline-Modus:** Lokale Speicherung, automatische Sync
5. **Barrierefreiheit:** Screenreader, Touch-Ziele, Kontraste
6. **Wissensaktualisierung:** Cron-Job, Admin-Review, Nutzer-Push

---

**Lizenz:** Proprietary  
**Kontakt:** norman.wagner@planypet.com  
