import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';

class LoiPinelScreen extends StatelessWidget {
  const LoiPinelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Loi Pinel / LMNP',
      description: 'Avantages fiscaux pour investissement locatif',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Loi Pinel',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          _DispositionCard(
            title: 'Réduction d\'impôt Pinel',
            color: AppTheme.primaryBlue,
            icon: Icons.discount,
            content: '• 6 ans: 10.5% de réduction\n'
                '• 9 ans: 15% de réduction\n'
                '• 12 ans: 17.5% de réduction\n\n'
                'Plafond: 300 000 € et 5 500 €/m²\n'
                'Location nue (vide) en résidence principale',
          ),
          const SizedBox(height: 16),
          _DispositionCard(
            title: 'Conditions Pinel',
            color: AppTheme.accentBlue,
            icon: Icons.rule,
            content: '• Logement neuf ou rénové\n'
                '• Zones éligibles (A, A bis, B1)\n'
                '• Respect des plafonds de loyers\n'
                '• Respect des plafonds de ressources locataire\n'
                '• Engagement de location 6, 9 ou 12 ans',
          ),
          const SizedBox(height: 24),
          Text(
            'LMNP (Loueur Meublé Non Professionnel)',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          _DispositionCard(
            title: 'Avantages LMNP',
            color: AppTheme.success,
            icon: Icons.apartment,
            content: '• Amortissement du bien et mobilier\n'
                '• Déduction des charges et intérêts d\'emprunt\n'
                '• Possibilité de récupérer la TVA (résidences services)\n'
                '• Revenus faiblement imposés voire non imposés',
          ),
          const SizedBox(height: 16),
          _DispositionCard(
            title: 'Régimes fiscaux LMNP',
            color: AppTheme.warning,
            icon: Icons.account_balance,
            content: '• Micro-BIC: jusqu\'à 77 700 € de revenus\n'
                '  → Abattement forfaitaire de 50%\n\n'
                '• Réel: au-delà ou sur option\n'
                '  → Déduction charges réelles + amortissement',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.lightBlue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppTheme.accentBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Conseil',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.accentBlue,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Le choix entre Pinel et LMNP dépend de votre situation fiscale, '
                  'du type de bien et de votre stratégie d\'investissement. '
                  'Consultez un expert-comptable ou conseiller en gestion de patrimoine.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DispositionCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String content;

  const _DispositionCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.content,
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
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
