class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'E-Mail ist erforderlich';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Ungueltige E-Mail-Adresse';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Passwort ist erforderlich';
    if (value.length < 8) return 'Mindestens 8 Zeichen';
    return null;
  }

  static String? required(String? value, [String fieldName = 'Feld']) {
    if (value == null || value.trim().isEmpty) return '$fieldName ist erforderlich';
    return null;
  }

  static String? petName(String? value) {
    if (value == null || value.isEmpty) return 'Name ist erforderlich';
    if (value.length < 2) return 'Name muss mindestens 2 Zeichen haben';
    if (value.length > 50) return 'Name darf maximal 50 Zeichen haben';
    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.isEmpty) return null;
    final num = double.tryParse(value);
    if (num == null) return 'Ungueltige Zahl';
    if (num <= 0) return 'Gewicht muss positiv sein';
    if (num > 1000) return 'Gewicht zu hoch';
    return null;
  }

  static String? chipNumber(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 15) return 'Chip-Nummer muss 15 Zeichen haben';
    final regex = RegExp(r'^[0-9]{15}$');
    if (!regex.hasMatch(value)) return 'Nur Ziffern erlaubt';
    return null;
  }
}