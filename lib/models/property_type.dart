enum PropertyType {
  location, // Location
  vente, // Vente
}

extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.location:
        return 'Location';
      case PropertyType.vente:
        return 'Vente';
    }
  }
}
