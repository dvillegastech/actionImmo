import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property_type.dart';

// Provider pour gérer le type de propriété sélectionné (Location/Vente)
final propertyTypeProvider = StateProvider<PropertyType>((ref) {
  return PropertyType.vente; // Par défaut: Vente
});
