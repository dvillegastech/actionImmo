import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';

class DpeGesScreen extends StatelessWidget {
  const DpeGesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'DPE / GES',
      description: 'Diagnostic de Performance Énergétique et émissions de Gaz à Effet de Serre',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Classes Énergétiques DPE',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _DpeClass(letter: 'A', range: '≤ 70', color: Color(0xFF00A35C)),
          _DpeClass(letter: 'B', range: '71 - 110', color: Color(0xFF5DB75E)),
          _DpeClass(letter: 'C', range: '111 - 180', color: Color(0xFFC2D82E)),
          _DpeClass(letter: 'D', range: '181 - 250', color: Color(0xFFFEE500)),
          _DpeClass(letter: 'E', range: '251 - 330', color: Color(0xFFFDB813)),
          _DpeClass(letter: 'F', range: '331 - 420', color: Color(0xFFF68B1F)),
          _DpeClass(letter: 'G', range: '> 420', color: Color(0xFFED1C24)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.error.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppTheme.error),
                    const SizedBox(width: 8),
                    Text(
                      'Logements G interdits',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Depuis 2023, les logements classés G (passoires thermiques) '
                  'ne peuvent plus être loués. Les logements F seront interdits '
                  'en 2028, et les E en 2034.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.lightBlue.withOpacity(0.3)),
            ),
            child: Text(
              'Le DPE est obligatoire pour toute vente ou location. '
              'Il est valable 10 ans et doit être réalisé par un diagnostiqueur certifié.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DpeClass extends StatelessWidget {
  final String letter;
  final String range;
  final Color color;

  const _DpeClass({
    required this.letter,
    required this.range,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            letter,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$range kWh/m²/an',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
