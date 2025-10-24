import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';

class PtzScreen extends StatefulWidget {
  const PtzScreen({super.key});

  @override
  State<PtzScreen> createState() => _PtzScreenState();
}

class _PtzScreenState extends State<PtzScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prixController = TextEditingController();
  final _revenuController = TextEditingController();

  String _zone = 'A bis';
  int _personnes = 2;
  bool? _eligible;
  double? _montantPTZ;
  double? _plafondRevenu;
  double? _quotite;

  @override
  void dispose() {
    _prixController.dispose();
    _revenuController.dispose();
    super.dispose();
  }

  // Plafonds de ressources PTZ 2025 (revenus N-2)
  Map<String, List<double>> _getPlafonds() {
    return {
      'A bis': [49000, 74000, 89000, 104000, 120000, 135000, 150000, 165000],
      'A': [49000, 74000, 89000, 104000, 120000, 135000, 150000, 165000],
      'B1': [40000, 60000, 72000, 84000, 97000, 109000, 121000, 133000],
      'B2': [32500, 49000, 59000, 69000, 79000, 89000, 99000, 109000],
      'C': [32500, 49000, 59000, 69000, 79000, 89000, 99000, 109000],
    };
  }

  // Quotités PTZ 2025
  double _getQuotite(String zone) {
    switch (zone) {
      case 'A bis':
      case 'A':
      case 'B1':
      case 'B2':
        return 0.40; // 40%
      case 'C':
        return 0.20; // 20%
      default:
        return 0.40;
    }
  }

  // Plafonds d'opération PTZ 2025 (prix max du bien)
  Map<String, List<double>> _getPlafondsPrix() {
    return {
      'A bis': [660000, 660000, 792000, 924000, 1056000, 1188000, 1320000, 1452000],
      'A': [330000, 330000, 396000, 462000, 528000, 594000, 660000, 726000],
      'B1': [242000, 242000, 290400, 338800, 387200, 435600, 484000, 532400],
      'B2': [220000, 220000, 264000, 308000, 352000, 396000, 440000, 484000],
      'C': [176000, 176000, 211200, 246400, 281600, 316800, 352000, 387200],
    };
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final prix = double.parse(_prixController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final revenu = double.parse(_revenuController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      final plafonds = _getPlafonds();
      final plafondsPrix = _getPlafondsPrix();
      final plafondRevenu = plafonds[_zone]![_personnes - 1];
      final plafondPrix = plafondsPrix[_zone]![_personnes - 1];
      final quotite = _getQuotite(_zone);

      // Vérifier éligibilité
      final eligibleRevenu = revenu <= plafondRevenu;
      final eligiblePrix = prix <= plafondPrix;
      final eligible = eligibleRevenu && eligiblePrix;

      // Calculer montant PTZ
      final montantTheorique = prix * quotite;
      final montantPTZ = eligible ? montantTheorique : 0.0;

      setState(() {
        _eligible = eligible;
        _montantPTZ = montantPTZ;
        _plafondRevenu = plafondRevenu;
        _quotite = quotite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'PTZ - Prêt à Taux Zéro',
      description: 'Calculez votre éligibilité au PTZ (Données 2025)',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Zone
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
                    'Zone géographique',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _zone,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: ['A bis', 'A', 'B1', 'B2', 'C'].map((zone) {
                      return DropdownMenuItem(value: zone, child: Text(zone));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _zone = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nombre de personnes
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
                    'Nombre de personnes du foyer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _personnes,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(8, (i) => i + 1).map((nb) {
                      return DropdownMenuItem(
                        value: nb,
                        child: Text('$nb personne${nb > 1 ? 's' : ''}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _personnes = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            InputField(
              controller: _revenuController,
              label: 'Revenus annuels du foyer (N-2)',
              hint: 'Ex: 45000',
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

            InputField(
              controller: _prixController,
              label: 'Prix d\'achat du bien',
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
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Vérifier l\'éligibilité'),
            ),
            const SizedBox(height: 32),

            if (_eligible != null) ...[
              // Résultat éligibilité
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _eligible! ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _eligible! ? Colors.green[300]! : Colors.red[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _eligible! ? Icons.check_circle : Icons.cancel,
                      color: _eligible! ? Colors.green[700] : Colors.red[700],
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _eligible!
                            ? 'Vous êtes éligible au PTZ !'
                            : 'Vous n\'êtes pas éligible au PTZ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _eligible! ? Colors.green[900] : Colors.red[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_eligible!) ...[
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
                        'Montant PTZ maximum',
                        '${_montantPTZ!.toStringAsFixed(0)} €',
                        isBold: true,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow('Quotité PTZ', '${(_quotite! * 100).toInt()}%'),
                      const SizedBox(height: 8),
                      _InfoRow(
                        'Plafond de revenus',
                        '${_plafondRevenu!.toStringAsFixed(0)} €',
                      ),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Le PTZ doit être complété par un apport personnel et/ou un prêt bancaire. '
                          'Durée de remboursement : 20 à 25 ans. '
                          'Réservé aux primo-accédants pour résidence principale.',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    'Vos revenus ou le prix du bien dépassent les plafonds autorisés '
                    'pour la zone $_zone avec $_personnes personne${_personnes > 1 ? 's' : ''}.\n\n'
                    'Plafond de revenus : ${_plafondRevenu!.toStringAsFixed(0)} €',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ),
              ],
            ],
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
