import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';

class AplScreen extends StatelessWidget {
  const AplScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'APL / Aides au Logement',
      description: 'Informations sur les aides de la CAF',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AideCard(
            title: 'APL (Aide Personnalisée au Logement)',
            color: AppTheme.primaryBlue,
            conditions: '• Locataire ou propriétaire remboursant un prêt\n'
                '• Logement conventionné\n'
                '• Sous plafond de ressources',
            montant: 'Variable selon revenus, composition familiale et loyer\n'
                'Moyenne: 100 - 300 € / mois',
          ),
          const SizedBox(height: 16),
          _AideCard(
            title: 'ALF (Allocation de Logement Familiale)',
            color: AppTheme.accentBlue,
            conditions: '• Personne avec enfants ou personnes à charge\n'
                '• Non éligible à l\'APL\n'
                '• Sous plafond de ressources',
            montant: 'Montant variable selon situation familiale',
          ),
          const SizedBox(height: 16),
          _AideCard(
            title: 'ALS (Allocation de Logement Sociale)',
            color: AppTheme.success,
            conditions: '• Toute personne non éligible APL ou ALF\n'
                '• Étudiant, jeune actif, senior\n'
                '• Sous plafond de ressources',
            montant: 'Montant variable selon revenus et loyer',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calculate, color: AppTheme.warning),
                    const SizedBox(width: 8),
                    Text(
                      'Simulation officielle',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.warning,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Pour connaître le montant exact de votre aide, utilisez '
                  'le simulateur officiel de la CAF:\n\n'
                  '🌐 www.caf.fr > Mes services en ligne > Simuler vos droits',
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
              '💡 Les aides sont calculées sur les 12 derniers mois de revenus. '
              'Elles sont versées directement par la CAF et révisées tous les 3 mois.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _AideCard extends StatelessWidget {
  final String title;
  final Color color;
  final String conditions;
  final String montant;

  const _AideCard({
    required this.title,
    required this.color,
    required this.conditions,
    required this.montant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Conditions:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(conditions, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(
            'Montant:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(montant, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
