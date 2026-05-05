class UnitConverter {
  // Weight: stored in grams
  static double gramsToKg(int grams) => grams / 1000.0;
  static double gramsToLbs(int grams) => grams / 453.592;
  static int kgToGrams(double kg) => (kg * 1000).round();
  static int lbsToGrams(double lbs) => (lbs * 453.592).round();

  static String formatWeight(int grams, {bool metric = true}) {
    if (metric) {
      final kg = gramsToKg(grams);
      return kg >= 1 ? '${kg.toStringAsFixed(1)} kg' : '$grams g';
    } else {
      final lbs = gramsToLbs(grams);
      return '${lbs.toStringAsFixed(1)} lbs';
    }
  }

  // Distance: stored in meters
  static double metersToKm(int meters) => meters / 1000.0;
  static double metersToMiles(int meters) => meters / 1609.344;
  static int kmToMeters(double km) => (km * 1000).round();

  static String formatDistance(int meters, {bool metric = true}) {
    if (metric) {
      final km = metersToKm(meters);
      return km >= 1 ? '${km.toStringAsFixed(2)} km' : '$meters m';
    } else {
      return '${metersToMiles(meters).toStringAsFixed(2)} mi';
    }
  }

  static String formatPortion(int grams) {
    return grams >= 1000
        ? '${gramsToKg(grams).toStringAsFixed(1)} kg'
        : '$grams g';
  }
}
