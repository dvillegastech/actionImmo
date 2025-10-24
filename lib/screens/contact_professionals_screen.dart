import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ContactProfessionalsScreen extends StatelessWidget {
  const ContactProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacter un Professionnel'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Besoin d\'accompagnement ?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlack,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nos partenaires experts sont à votre disposition pour vous accompagner dans votre projet immobilier.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Notaire
          _ProfessionalCard(
            icon: Icons.gavel,
            title: 'Notaire',
            description: 'Conseil juridique, rédaction d\'actes, sécurisation de votre transaction',
            color: AppTheme.primaryBlue,
            onContact: () => _showContactDialog(
              context,
              'Notaire',
              'Un notaire vous recontactera sous 48h pour discuter de votre projet.',
            ),
          ),
          const SizedBox(height: 16),

          // Courtier en Crédit
          _ProfessionalCard(
            icon: Icons.account_balance,
            title: 'Courtier en Crédit',
            description: 'Comparaison des offres, négociation des taux, montage de dossier',
            color: AppTheme.accentBlue,
            onContact: () => _showContactDialog(
              context,
              'Courtier en Crédit',
              'Un courtier vous recontactera sous 24h pour optimiser votre financement.',
            ),
          ),
          const SizedBox(height: 16),

          // Conseiller en Gestion de Patrimoine
          _ProfessionalCard(
            icon: Icons.business_center,
            title: 'Conseiller en Gestion de Patrimoine',
            description: 'Stratégie d\'investissement, optimisation fiscale, diversification',
            color: AppTheme.primaryBlue,
            onContact: () => _showContactDialog(
              context,
              'Conseiller en Gestion de Patrimoine',
              'Un conseiller vous recontactera sous 48h pour une étude personnalisée.',
            ),
          ),
          const SizedBox(height: 16),

          // Expert Immobilier
          _ProfessionalCard(
            icon: Icons.home,
            title: 'Agent Immobilier',
            description: 'Recherche de biens, estimation, accompagnement achat/vente',
            color: AppTheme.accentBlue,
            onContact: () => _showContactDialog(
              context,
              'Agent Immobilier',
              'Un agent vous recontactera sous 24h pour définir vos critères de recherche.',
            ),
          ),
          const SizedBox(height: 16),

          // Diagnostiqueur
          _ProfessionalCard(
            icon: Icons.verified_user,
            title: 'Diagnostiqueur Immobilier',
            description: 'DPE, amiante, plomb, électricité, gaz, termites',
            color: AppTheme.primaryBlue,
            onContact: () => _showContactDialog(
              context,
              'Diagnostiqueur Immobilier',
              'Un diagnostiqueur vous recontactera sous 48h pour planifier les diagnostics.',
            ),
          ),
          const SizedBox(height: 32),

          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Service gratuit et sans engagement. Nos partenaires sont sélectionnés pour leur expertise et leur sérieux.',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(
    BuildContext context,
    String professional,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contacter un $professional'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            const Text(
              'Souhaitez-vous être recontacté ?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar(context, professional);
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String professional) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande envoyée ! Un $professional vous recontactera prochainement.'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onContact;

  const _ProfessionalCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onContact,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
