import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';

class LoiPinelScreen extends StatefulWidget {
  const LoiPinelScreen({super.key});

  @override
  State<LoiPinelScreen> createState() => _LoiPinelScreenState();
}

class _LoiPinelScreenState extends State<LoiPinelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prixController = TextEditingController();

  int _duree = 6;
  double? _reductionImpot;
  double? _economieAnnuelle;

  @override
  void dispose() {
    _prixController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final prix = double.parse(_prixController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      // Plafond Pinel : 300 000€
      final prixPlafonne = prix > 300000 ? 300000.0 : prix;

      // Taux de réduction selon durée
      double tauxReduction;
      switch (_duree) {
        case 6:
          tauxReduction = 0.105; // 10.5%
          break;
        case 9:
          tauxReduction = 0.15; // 15%
          break;
        case 12:
          tauxReduction = 0.175; // 17.5%
          break;
        default:
          tauxReduction = 0.105;
      }

      final reduction = prixPlafonne * tauxReduction;
      final economieParAn = reduction / _duree;

      setState(() {
        _reductionImpot = reduction;
        _economieAnnuelle = economieParAn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Loi Pinel / LMNP',
      description: 'Dispositifs fiscaux pour investissement locatif',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Alerte fin du dispositif
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[300]!, width: 2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.red[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dispositif Pinel terminé',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Le dispositif Pinel a pris fin le 31 décembre 2024. '
                          'Les informations ci-dessous sont à titre informatif pour les investissements antérieurs.',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Simulateur Pinel (historique)',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            InputField(
              controller: _prixController,
              label: 'Prix d\'acquisition du bien',
              hint: 'Ex: 250000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Requis';
                final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleaned.isEmpty || double.tryParse(cleaned) == null) return 'Invalide';
                return null;
              },
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durée d\'engagement',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _duree,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: 6, child: Text('6 ans (10.5%)')),
                      const DropdownMenuItem(value: 9, child: Text('9 ans (15%)')),
                      const DropdownMenuItem(value: 12, child: Text('12 ans (17.5%)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _duree = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculer la réduction'),
            ),
            const SizedBox(height: 32),

            if (_reductionImpot != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      'Réduction d\'impôt totale',
                      '${_reductionImpot!.toStringAsFixed(0)} €',
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      'Économie annuelle',
                      '${_economieAnnuelle!.toStringAsFixed(0)} €',
                    ),
                    const SizedBox(height: 8),
                    _InfoRow('Durée', '$_duree ans'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Conditions Pinel (historique)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[900],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Plafond : 300 000 € et 5 500 €/m²\n'
                      '• Zones éligibles : A, A bis, B1\n'
                      '• Logement neuf ou rénové\n'
                      '• Location nue en résidence principale\n'
                      '• Respect des plafonds de loyers et ressources',
                      style: TextStyle(color: Colors.blue[900], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
            Divider(color: Colors.grey[400]),
            const SizedBox(height: 16),

            Text(
              'LMNP (Loueur Meublé Non Professionnel)',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avantages LMNP (toujours actif en 2025)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Amortissement du bien et du mobilier\n'
                    '• Déduction des charges et intérêts d\'emprunt\n'
                    '• Revenus faiblement ou non imposés\n'
                    '• Récupération TVA possible (résidences services)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Régimes fiscaux LMNP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Micro-BIC (jusqu\'à 77 700 €)\n'
                    '→ Abattement forfaitaire de 50%\n\n'
                    'Régime Réel (au-delà ou sur option)\n'
                    '→ Déduction charges réelles + amortissement',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                  Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Conseil : Le LMNP reste un dispositif attractif en 2025 pour '
                      'l\'investissement locatif meublé. Consultez un expert-comptable '
                      'ou conseiller en gestion de patrimoine pour optimiser votre stratégie.',
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
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
