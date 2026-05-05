class FeedingLogModel {
  const FeedingLogModel({
    required this.id,
    required this.petId,
    required this.familyId,
    required this.fedAt,
    this.foodName,
    this.portionGrams,
    this.notes,
    this.synced = false,
  });

  final String id;
  final String petId;
  final String familyId;
  final DateTime fedAt;
  final String? foodName;
  final int? portionGrams;
  final String? notes;
  final bool synced;

  factory FeedingLogModel.fromJson(Map<String, dynamic> json) => FeedingLogModel(
        id: json['id'] as String,
        petId: json['pet_id'] as String,
        familyId: json['family_id'] as String,
        fedAt: DateTime.parse(json['fed_at'] as String),
        foodName: json['food_name'] as String?,
        portionGrams: json['portion_grams'] as int?,
        notes: json['notes'] as String?,
      );

  factory FeedingLogModel.fromDb(Map<String, dynamic> row) => FeedingLogModel(
        id: row['id'] as String,
        petId: row['pet_id'] as String,
        familyId: row['family_id'] as String,
        fedAt: DateTime.parse(row['fed_at'] as String),
        foodName: row['food_name'] as String?,
        portionGrams: row['portion_grams'] as int?,
        notes: row['notes'] as String?,
        synced: (row['synced'] as int? ?? 0) == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pet_id': petId,
        'family_id': familyId,
        'fed_at': fedAt.toUtc().toIso8601String(),
        if (foodName != null) 'food_name': foodName,
        if (portionGrams != null) 'portion_grams': portionGrams,
        if (notes != null) 'notes': notes,
      };

  Map<String, dynamic> toDb({bool synced = false}) => {
        'id': id,
        'pet_id': petId,
        'family_id': familyId,
        'fed_at': fedAt.toUtc().toIso8601String(),
        'food_name': foodName,
        'portion_grams': portionGrams,
        'notes': notes,
        'synced': synced ? 1 : 0,
      };
}
