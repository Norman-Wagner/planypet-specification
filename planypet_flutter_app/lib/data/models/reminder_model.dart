class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.familyId,
    required this.title,
    required this.dueAt,
    this.petId,
    this.completed = false,
    this.completedAt,
  });

  final String id;
  final String? petId;
  final String familyId;
  final String title;
  final DateTime dueAt;
  final bool completed;
  final DateTime? completedAt;

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        id: json['id'] as String,
        petId: json['pet_id'] as String?,
        familyId: json['family_id'] as String,
        title: json['title'] as String,
        dueAt: DateTime.parse(json['due_at'] as String),
        completed: json['completed'] as bool? ?? false,
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String)
            : null,
      );

  factory ReminderModel.fromDb(Map<String, dynamic> row) => ReminderModel(
        id: row['id'] as String,
        petId: row['pet_id'] as String?,
        familyId: row['family_id'] as String,
        title: row['title'] as String,
        dueAt: DateTime.parse(row['due_at'] as String),
        completed: (row['completed'] as int? ?? 0) == 1,
        completedAt: row['completed_at'] != null
            ? DateTime.parse(row['completed_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'family_id': familyId,
        if (petId != null) 'pet_id': petId,
        'title': title,
        'due_at': dueAt.toUtc().toIso8601String(),
        'completed': completed,
        if (completedAt != null) 'completed_at': completedAt!.toUtc().toIso8601String(),
      };

  Map<String, dynamic> toDb({bool synced = false}) => {
        'id': id,
        'pet_id': petId,
        'family_id': familyId,
        'title': title,
        'due_at': dueAt.toUtc().toIso8601String(),
        'completed': completed ? 1 : 0,
        'completed_at': completedAt?.toUtc().toIso8601String(),
        'synced': synced ? 1 : 0,
      };

  ReminderModel copyWith({bool? completed, DateTime? completedAt}) => ReminderModel(
        id: id,
        petId: petId,
        familyId: familyId,
        title: title,
        dueAt: dueAt,
        completed: completed ?? this.completed,
        completedAt: completedAt ?? this.completedAt,
      );
}
