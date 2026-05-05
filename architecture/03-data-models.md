# Datenmodelle

Alle Modelle werden in Flutter als Dart-Klassen umgesetzt. Interner Speicher immer metrisch (Gramm, Meter, Celsius, Liter). ISO 8601 UTC für Datum/Zeit.

## 1. Pet

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "name": "Luna",
  "species": "Dog",
  "breed": "Labrador",
  "birth_date": "2021-03-15",
  "is_estimated_birth_date": false,
  "weight": 28000,
  "weight_history": [
    {
      "timestamp": "2026-04-20T08:00:00Z",
      "value": 28000
    }
  ],
  "photo_url": "https://...",
  "medical_warnings": "Allergie gegen Penicillin",
  "activity_level": 4,
  "status": "Active",
  "chip_number": "123456789012345",
  "chip_implant_date": "2021-04-01",
  "chip_registrations": [
    {
      "database": "TASSO",
      "status": "confirmed",
      "confirmed_date": "2021-04-05"
    }
  ],
  "species_specific_data": {
    "hip_dysplasia_risk": "Low",
    "grooming_interval_weeks": 8
  }
}
```

## 2. FeedingSchedule

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "pet_id": "uuid",
  "name": "Morgen Fütterung",
  "food_type": "Premium Trockenfutter",
  "portion_size_grams": 300,
  "scheduled_time": "08:00",
  "frequency": "daily",
  "start_date": "2026-01-01",
  "end_date": null,
  "notes": "Mit Nassfutter vermischen",
  "created_at": "2026-01-01T10:30:00Z",
  "updated_at": "2026-04-20T08:00:00Z"
}
```

## 3. InventoryItem

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "item_type": "Food",
  "name": "Premium Trockenfutter - 10kg",
  "quantity": 3,
  "unit": "bag",
  "quantity_grams_per_unit": 10000,
  "brand": "Royal Canin",
  "purchase_date": "2026-04-15",
  "expiry_date": "2027-04-15",
  "storage_location": "Küchenschrank",
  "cost_cents": 5500,
  "supplier": "PetShop Online",
  "notes": "Für Luna geeignet",
  "created_at": "2026-04-15T12:00:00Z",
  "updated_at": "2026-04-20T08:00:00Z"
}
```

## 4. PetPhoto

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "pet_id": "uuid",
  "photo_url": "https://...",
  "thumbnail_url": "https://...",
  "caption": "Luna im Park",
  "taken_date": "2026-04-20",
  "upload_timestamp": "2026-04-20T15:30:00Z",
  "tags": ["park", "spielen"],
  "is_profile_photo": false,
  "created_at": "2026-04-20T15:30:00Z"
}
```

## 5. WalkSession

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "pet_id": "uuid",
  "walker_id": "uuid",
  "start_time": "2026-04-20T09:00:00Z",
  "end_time": "2026-04-20T09:45:00Z",
  "duration_minutes": 45,
  "distance_meters": 3500,
  "pace_meters_per_minute": 77.8,
  "location": "Stadtpark",
  "weather": "sunny",
  "temperature_celsius": 18,
  "notes": "Luna war sehr aktiv",
  "photo_urls": ["https://..."],
  "created_at": "2026-04-20T10:00:00Z",
  "updated_at": "2026-04-20T10:00:00Z"
}
```

## 6. FamilyMember

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "name": "Max Mustermann",
  "email": "max@example.com",
  "phone_number": "+49123456789",
  "role": "owner",
  "permissions": ["read", "write", "manage_pets", "manage_members"],
  "is_active": true,
  "joined_date": "2025-06-01",
  "profile_photo_url": "https://...",
  "created_at": "2025-06-01T10:00:00Z",
  "updated_at": "2026-04-20T08:00:00Z"
}
```

## 7. Task

```json
{
  "id": "uuid",
  "family_id": "uuid",
  "pet_id": "uuid",
  "title": "Tierarztbesuch - Impfung",
  "description": "Jährliche Impfung für Luna durchführen",
  "assigned_to_member_id": "uuid",
  "due_date": "2026-05-15",
  "due_time": "14:30",
  "status": "pending",
  "priority": "high",
  "category": "health",
  "reminder_enabled": true,
  "reminder_minutes_before": 1440,
  "recurrence": "yearly",
  "recurrence_end_date": null,
  "notes": "Beim Dr. Schmidt Termin ausmachen",
  "created_at": "2026-04-20T08:00:00Z",
  "updated_at": "2026-04-20T08:00:00Z"
}
```

## 8. AdvancedSpeciesProfile

```json
{
  "id": "uuid",
  "species": "Dog",
  "breed": "Labrador",
  "typical_weight_range_grams": {
    "min": 25000,
    "max": 36000
  },
  "lifespan_years": {
    "min": 10,
    "max": 12
  },
  "health_considerations": [
    "Hip dysplasia",
    "Elbow dysplasia",
    "Labrador retinopathy",
    "Exercise-induced collapse"
  ],
  "grooming_needs": {
    "brush_frequency_days": 2,
    "bath_frequency_weeks": 8,
    "nail_trim_weeks": 4,
    "ear_clean_weeks": 2
  },
  "dietary_needs": {
    "calories_per_day": 1500,
    "protein_percentage": 25,
    "fat_percentage": 15,
    "recommended_food_types": ["Premium dog food", "Limited ingredient diet"]
  },
  "activity_requirements": {
    "daily_exercise_minutes": 60,
    "activity_level": 4
  },
  "breeding_considerations": {
    "recommended_minimum_age_months": 24,
    "health_screening_required": ["Hip scoring", "Elbow scoring", "Eye examination"]
  },
  "created_at": "2025-01-01T00:00:00Z",
  "updated_at": "2026-04-20T08:00:00Z"
}
```

## Datenmodell-Prinzipien

- **UUIDs**: Alle Entity-IDs sind UUIDs (universally unique identifiers)
- **Metrische Einheiten**: Gewicht in Gramm, Entfernung in Metern, Temperatur in Celsius, Volumen in Litern, Kosten in Cents
- **Zeitformate**: Alle Timestamps verwenden ISO 8601 UTC Format (YYYY-MM-DDTHH:MM:SSZ)
- **Family-Struktur**: Die meisten Entitäten haben eine `family_id` für Multi-User-Haushalte
- **Nachverfolgung**: `created_at` und `updated_at` Timestamps für Audit-Trail
- **Nullbare Felder**: Optionale Felder können `null` sein (z.B. `end_date`, `recurrence_end_date`)
