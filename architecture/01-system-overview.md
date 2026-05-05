# Systemübersicht

Planypet ist ein regelbasiertes System mit zentralen Modulen:
- speciesDefinitions.ts – Arten und ihre Eigenschaften
- speciesReminderTemplates.ts – artspezifische Erinnerungen
- speciesFeedingUnits.ts – Fütterungseinheiten pro Art
- speciesHousingRules.ts – Haltungsbedingungen
- speciesMaterialRules.ts – benötigte Materialien
- registryDefinitions.ts – Registrierungsdatenbanken

Layer-Architektur: UI → Rules/Services → Datenbank (Supabase + PowerSync)

Unterstützte Arten: Hund, Katze, Kaninchen, Meerschweinchen, Hamster, Maus/Ratte, Vogel, Aquarium/Fisch, Reptil, Amphibie, Wirbellose
