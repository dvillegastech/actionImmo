import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';

class PtzScreen extends StatelessWidget {
  const PtzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'PTZ - Prêt à Taux Zéro',
      description: 'Informations sur le Prêt à Taux Zéro 2024',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            title: 'Conditions d\'éligibilité',
            icon: Icons.check_circle_outline,
            color: AppTheme.success,
            content: '• Primo-accédant (1ère acquisition)\n'
                '• Résidence principale uniquement\n'
                '• Plafonds de ressources selon zone\n'
                '• Logement neuf ou ancien avec travaux (≥25%)',
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Montants 2024',
            icon: Icons.euro,
            color: AppTheme.primaryBlue,
            content: '• Zone A/A bis: jusqu\'à 40% du coût\n'
                '• Zone B1: jusqu\'à 40% du coût\n'
                '• Zone B2/C: jusqu\'à 20-40% selon revenus\n'
                '• Durée: 20 à 25 ans',
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Plafonds de ressources (couple)',
            icon: Icons.people,
            color: AppTheme.accentBlue,
            content: '• Zone A: 74 000 € (2 personnes)\n'
                '• Zone B1: 60 000 € (2 personnes)\n'
                '• Zone B2: 49 000 € (2 personnes)\n'
                '• Zone C: 49 000 € (2 personnes)',
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'À savoir',
            icon: Icons.lightbulb_outline,
            color: AppTheme.warning,
            content: 'Le PTZ doit être complété par un apport personnel '
                'et/ou un prêt principal. Il ne peut financer la totalité '
                'de l\'acquisition. Renseignez-vous auprès de votre banque.',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const _InfoCard({
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
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
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
