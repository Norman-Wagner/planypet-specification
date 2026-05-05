class AppConstants {
  static const String appName = 'PlanyPet';
  static const String appVersion = '1.0.0';

  // Supabase Tables
  static const String profilesTable = 'profiles';
  static const String familiesTable = 'families';
  static const String petsTable = 'pets';
  static const String feedingSchedulesTable = 'feeding_schedules';
  static const String feedingLogTable = 'feeding_log';
  static const String weightHistoryTable = 'weight_history';
  static const String healthRecordsTable = 'health_records';
  static const String remindersTable = 'reminders';
  static const String walkSessionsTable = 'walk_sessions';
  static const String inventoryItemsTable = 'inventory_items';

  // Storage Buckets
  static const String petPhotosBucket = 'pet-photos';
  static const String avatarsBucket = 'avatars';
  static const String healthDocsBucket = 'health-documents';

  // Navigation Routes
  static const String dashboardRoute = '/';
  static const String petsRoute = '/pets';
  static const String communityRoute = '/community';
  static const String profileRoute = '/profile';
  static const String addPetRoute = '/pets/add';
  static const String petDetailRoute = '/pets/:id';
}
