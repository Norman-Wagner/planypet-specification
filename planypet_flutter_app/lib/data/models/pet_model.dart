class PetModel {
  final String id;
  final String familyId;
  final String name;
  final String species;
  final String? breed;
  final String? gender;
  final DateTime? dateOfBirth;
  final int? weight;
  final String? color;
  final String? distinctiveFeatures;
  final String? avatarUrl;
  final String status;
  final String? chipNumber;
  final bool chipRegistered;
  final String? insuranceNumber;
  final String? insuranceProvider;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PetModel({
    required this.id,
    required this.familyId,
    required this.name,
    required this.species,
    this.breed,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.color,
    this.distinctiveFeatures,
    this.avatarUrl,
    this.status = 'Active',
    this.chipNumber,
    this.chipRegistered = false,
    this.insuranceNumber,
    this.insuranceProvider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    id: json['id'],
    familyId: json['family_id'],
    name: json['name'],
    species: json['species'],
    breed: json['breed'],
    gender: json['gender'],
    dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
    weight: json['weight'],
    color: json['color'],
    distinctiveFeatures: json['distinctive_features'],
    avatarUrl: json['avatar_url'],
    status: json['status'] ?? 'Active',
    chipNumber: json['chip_number'],
    chipRegistered: json['chip_registered'] ?? false,
    insuranceNumber: json['insurance_number'],
    insuranceProvider: json['insurance_provider'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'family_id': familyId,
    'name': name,
    'species': species,
    if (breed != null) 'breed': breed,
    if (gender != null) 'gender': gender,
    if (dateOfBirth != null) 'date_of_birth': dateOfBirth!.toIso8601String(),
    if (weight != null) 'weight': weight,
    if (color != null) 'color': color,
    if (distinctiveFeatures != null) 'distinctive_features': distinctiveFeatures,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
    'status': status,
    if (chipNumber != null) 'chip_number': chipNumber,
    'chip_registered': chipRegistered,
    if (insuranceNumber != null) 'insurance_number': insuranceNumber,
    if (insuranceProvider != null) 'insurance_provider': insuranceProvider,
  };
}
