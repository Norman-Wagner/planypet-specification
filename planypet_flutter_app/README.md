# PlanyPet Flutter App

Smart Pet Management App — Flutter Frontend

## Tech Stack
- **Flutter** 3.x
- **Supabase** — Backend & Auth
- **Riverpod** — State Management
- **GoRouter** — Navigation
- **Hive** — Offline Storage

## Setup

1. Copy `.env.example` to `.env` and fill in your Supabase credentials
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Run `flutter run`

## Structure

```
lib/
├── core/           # Constants, Theme, Router, Utils
├── data/           # Models, Repositories, DataSources
├── domain/         # Entities, Use Cases
├── presentation/   # Screens & Widgets per feature
└── providers/      # Riverpod Providers
```

## Features
- 🐾 Pet profiles with photos
- 🍽️ Feeding schedules & logging
- 🏥 Health records & vaccinations
- 🚶 Walk tracking with GPS
- 📦 Inventory management
- ⏰ Reminders & notifications
- 👨‍👩‍👧 Family sharing
- 🤖 AI Assistant (DeepSeek)

## Supabase
Project URL: https://yarhzmfriwwkctzbcypp.supabase.co
