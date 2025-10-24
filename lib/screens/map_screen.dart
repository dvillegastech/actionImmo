import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../models/property_type.dart';
import '../models/calculator_type.dart';
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

  // 3 calculadoras principales
  static final List<CalculatorInfo> _mainCalculators = [
    CalculatorInfo.allCalculators[0], // Frais de Notaire
    CalculatorInfo.allCalculators[1], // Crédit Immobilier
    CalculatorInfo.allCalculators[2], // Capacité d'Emprunt
  ];

  // Calculadoras restantes
  static final List<CalculatorInfo> _moreCalculators =
      CalculatorInfo.allCalculators.skip(3).toList();

  void _showMoreCalculators() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MoreCalculatorsSheet(
        calculators: _moreCalculators,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyType = ref.watch(propertyTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACTION IMMOBILIARIA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/mes-simulations'),
            tooltip: 'Mes Simulations',
          ),
          IconButton(
            icon: const Icon(Icons.contact_phone),
            onPressed: () => context.push('/contact-professionals'),
            tooltip: 'Contacter un Professionnel',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Carte OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
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
            ],
          ),

          // Boutons Location/Vente en haut
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildPropertyTypeToggle(propertyType),
          ),

          // Calculadoras en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCalculatorBar(),
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

  Widget _buildCalculatorBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculatrices',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // 3 calculadoras principales
                ..._mainCalculators.map((calc) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _CalculatorButton(calculator: calc),
                      ),
                    )),
                // Botón "Plus"
                Expanded(
                  child: _MoreButton(onTap: _showMoreCalculators),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  final CalculatorInfo calculator;

  const _CalculatorButton({required this.calculator});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(calculator.route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              calculator.icon,
              color: AppTheme.primaryBlue,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              calculator.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.accentBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentBlue.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppTheme.accentBlue,
              size: 28,
            ),
            const SizedBox(height: 8),
            const Text(
              'Plus',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreCalculatorsSheet extends StatelessWidget {
  final List<CalculatorInfo> calculators;

  const _MoreCalculatorsSheet({required this.calculators});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              'Plus de calculatrices',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Lista de calculadoras
            ...calculators.map(
              (calc) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(calc.route);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            calc.icon,
                            color: AppTheme.primaryBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                calc.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                calc.description,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppTheme.mediumGrey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
