class FeedingScheduleModel {
  final String id;
  final String petId;
  final String mealTime;
  final String mealType;
  final int? portionGrams;
  final bool isActive;
  final String? notes;

  const FeedingScheduleModel({
    required this.id,
    required this.petId,
    required this.mealTime,
    required this.mealType,
    this.portionGrams,
    this.isActive = true,
    this.notes,
  });

  factory FeedingScheduleModel.fromJson(Map<String, dynamic> json) =>
      FeedingScheduleModel(
        id: json['id'],
        petId: json['pet_id'],
        mealTime: json['meal_time'],
        mealType: json['meal_type'],
        portionGrams: json['portion_grams'],
        isActive: json['is_active'] ?? true,
        notes: json['notes'],
      );
}
