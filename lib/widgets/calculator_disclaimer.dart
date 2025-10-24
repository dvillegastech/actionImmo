import 'package:flutter/material.dart';

class CalculatorDisclaimer extends StatelessWidget {
  const CalculatorDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.amber[800], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ces calculs sont fournis à titre informatif et approximatif. '
              'Les résultats peuvent varier selon votre situation personnelle. '
              'Consultez un professionnel pour obtenir des conseils adaptés.',
              style: TextStyle(
                color: Colors.amber[900],
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
