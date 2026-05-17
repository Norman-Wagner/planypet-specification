# Offline-First Synchronisation

- Supabase: PostgreSQL mit Row Level Security (RLS), Auth (E-Mail, Google, Apple), Storage für Fotos/Dokumente
- PowerSync: Lokale SQLite-Datenbank, Sync Streams für alle Tabellen (pets, feeding_schedules, inventory_items, walk_sessions, tasks, health_records)
- Offline-Upload: upload_queue-Tabelle, automatischer Upload bei Wiederverbindung
- Familien-Kontext: Alle Daten einer Family zugeordnet, Nutzer kann Mitglied mehrerer Familien sein
