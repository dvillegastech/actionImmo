import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../models/property_type.dart';
import '../providers/property_type_provider.dart';
import '../theme/app_theme.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  // Centre de la France (Paris)
  static const LatLng _centerFrance = LatLng(48.8566, 2.3522);

  @override
  Widget build(BuildContext context) {
    final propertyType = ref.watch(propertyTypeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Carte OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerFrance,
              initialZoom: 13.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.actionimmo.app',
                maxZoom: 19,
              ),
              // Ici on ajoutera les marqueurs des propriétés plus tard
            ],
          ),

          // Boutons Location/Vente en haut
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: _buildPropertyTypeToggle(propertyType),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeToggle(PropertyType currentType) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              label: 'Location',
              isSelected: currentType == PropertyType.location,
              onTap: () {
                ref.read(propertyTypeProvider.notifier).state =
                    PropertyType.location;
              },
              isLeft: true,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              label: 'Vente',
              isSelected: currentType == PropertyType.vente,
              onTap: () {
                ref.read(propertyTypeProvider.notifier).state =
                    PropertyType.vente;
              },
              isLeft: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(12) : Radius.zero,
            right: !isLeft ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppTheme.darkBlack,
            ),
          ),
        ),
      ),
    );
  }
}
