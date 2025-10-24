import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';

class TaxeFonciereScreen extends StatelessWidget {
  const TaxeFonciereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Taxe Foncière',
      description: 'Informations sur la taxe foncière en France',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoSection(
            title: 'Qu\'est-ce que la taxe foncière ?',
            icon: Icons.home,
            color: AppTheme.primaryBlue,
            content: 'La taxe foncière est un impôt local dû par les propriétaires '
                'de biens immobiliers au 1er janvier. Elle est calculée sur la '
                'valeur locative cadastrale du bien.',
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: 'Calcul',
            icon: Icons.calculate,
            color: AppTheme.accentBlue,
            content: 'Taxe = Valeur locative cadastrale × Taux communal\n\n'
                'Le taux varie selon la commune (généralement 15% à 45%). '
                'La valeur locative est déterminée par l\'administration fiscale.',
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: 'Montant moyen en France',
            icon: Icons.euro,
            color: AppTheme.success,
            content: '• Appartement: 500 - 1 200 € / an\n'
                '• Maison: 800 - 2 500 € / an\n'
                '• Variables selon ville et superficie',
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: 'Exonérations possibles',
            icon: Icons.check_circle,
            color: AppTheme.warning,
            content: '• Construction neuve: 2 ans d\'exonération\n'
                '• Personnes âgées à faibles revenus\n'
                '• Certains logements sociaux',
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
              '💡 Pour connaître le montant exact, consultez votre avis d\'imposition '
              'ou contactez le centre des impôts fonciers de votre commune.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.color,
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
