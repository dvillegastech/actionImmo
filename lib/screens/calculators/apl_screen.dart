import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/save_simulation_button.dart';

class AplScreen extends StatefulWidget {
  const AplScreen({super.key});

  @override
  State<AplScreen> createState() => _AplScreenState();
}

class _AplScreenState extends State<AplScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loyerController = TextEditingController();
  final _revenuController = TextEditingController();

  String _zone = 'Zone 1';
  int _personnes = 1;
  String _situation = 'Célibataire';
  double? _montantAPL;
  bool? _eligible;

  @override
  void dispose() {
    _loyerController.dispose();
    _revenuController.dispose();
    super.dispose();
  }

  // Plafonds de loyer APL 2025
  Map<String, List<double>> _getPlafonsLoyer() {
    return {
      'Zone 1': [300, 360, 420, 480, 540, 600, 660, 720],
      'Zone 2': [260, 310, 360, 410, 460, 510, 560, 610],
      'Zone 3': [230, 275, 320, 365, 410, 455, 500, 545],
    };
  }

  // Plafonds de ressources APL 2025 (revenus mensuels)
  Map<String, List<double>> _getPlafonsRessources() {
    return {
      'Célibataire': [1500, 1500, 1500, 1500, 1500, 1500, 1500, 1500],
      'Couple': [2200, 2200, 2200, 2200, 2200, 2200, 2200, 2200],
      'Famille': [2400, 2700, 3000, 3300, 3600, 3900, 4200, 4500],
    };
  }

  // Forfait charges selon nombre de personnes 2025
  double _getForfaitCharges(int personnes) {
    if (personnes == 1) return 57.0;
    if (personnes == 2) return 75.0;
    if (personnes == 3) return 87.0;
    if (personnes == 4) return 99.0;
    if (personnes >= 5) return 99.0 + ((personnes - 4) * 12.0);
    return 57.0;
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final loyer = double.parse(_loyerController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final revenuMensuel = double.parse(_revenuController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      final plafondLoyer = _getPlafonsLoyer()[_zone]![_personnes - 1];
      final plafondRessources = _getPlafonsRessources()[_situation]![_personnes - 1];
      final forfaitCharges = _getForfaitCharges(_personnes);

      // Vérifier éligibilité de base
      if (revenuMensuel > plafondRessources * 1.5) {
        setState(() {
          _eligible = false;
          _montantAPL = 0;
        });
        return;
      }

      // Calcul simplifié APL
      // Loyer pris en compte (plafonné)
      final loyerPrisEnCompte = loyer > plafondLoyer ? plafondLoyer : loyer;

      // Loyer + forfait charges
      final loyerCharges = loyerPrisEnCompte + forfaitCharges;

      // Participation personnelle (environ 30% du loyer + charges)
      final participationPersonnelle = loyerCharges * 0.30;

      // Taux de prise en charge selon revenus
      double tauxPriseEnCharge = 1.0;
      final ratioRevenu = revenuMensuel / plafondRessources;

      if (ratioRevenu < 0.5) {
        tauxPriseEnCharge = 0.95; // Très faibles revenus
      } else if (ratioRevenu < 0.8) {
        tauxPriseEnCharge = 0.85;
      } else if (ratioRevenu < 1.0) {
        tauxPriseEnCharge = 0.70;
      } else if (ratioRevenu < 1.3) {
        tauxPriseEnCharge = 0.50;
      } else {
        tauxPriseEnCharge = 0.30;
      }

      // Montant APL = (Loyer + Charges - Participation) × Taux
      double apl = (loyerCharges - participationPersonnelle) * tauxPriseEnCharge;

      // Arrondir à l'euro près
      apl = apl.roundToDouble();

      // Montant minimum 20€, maximum 400€
      if (apl < 20) apl = 0;
      if (apl > 400) apl = 400;

      setState(() {
        _eligible = apl > 0;
        _montantAPL = apl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'APL / Aide au Logement',
      description: 'Estimez votre aide au logement (Données 2025)',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Situation
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
                    'Situation familiale',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _situation,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: ['Célibataire', 'Couple', 'Famille'].map((sit) {
                      return DropdownMenuItem(value: sit, child: Text(sit));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _situation = value!;
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
                  const SizedBox(height: 4),
                  Text(
                    'Zone 1: Île-de-France, grandes villes\nZone 2: Villes moyennes\nZone 3: Autres communes',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _zone,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: ['Zone 1', 'Zone 2', 'Zone 3'].map((zone) {
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

            InputField(
              controller: _revenuController,
              label: 'Revenus mensuels nets du foyer',
              hint: 'Ex: 1800',
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
              controller: _loyerController,
              label: 'Loyer mensuel (hors charges)',
              hint: 'Ex: 650',
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
              child: const Text('Calculer l\'aide'),
            ),
            const SizedBox(height: 32),

            if (_eligible != null) ...[
              if (_eligible!) ...[
                // Montant estimé
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'APL estimée',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_montantAPL!.toStringAsFixed(0)} €',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'par mois',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vous semblez éligible à l\'APL. Cette estimation est indicative. '
                          'Faites une simulation officielle sur caf.fr pour connaître le montant exact.',
                          style: TextStyle(
                            color: Colors.green[900],
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
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vous ne semblez pas éligible à l\'APL selon ces critères. '
                          'Vérifiez votre éligibilité aux autres aides (ALF, ALS) sur caf.fr.',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                          'Informations importantes',
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
                      '• Cette estimation est basée sur une formule simplifiée\n'
                      '• Le montant réel dépend de nombreux critères\n'
                      '• L\'APL est révisée tous les 3 mois selon vos revenus\n'
                      '• Simulation officielle sur www.caf.fr\n'
                      '• D\'autres aides existent : ALF, ALS',
                      style: TextStyle(color: Colors.blue[900], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SaveSimulationButton(
                calculatorName: 'APL / Aide au Logement',
                enabled: _eligible != null,
                inputs: {
                  'Situation': _situation,
                  'Personnes': '$_personnes',
                  'Zone': _zone,
                  'Revenus': '${_revenuController.text} €',
                  'Loyer': '${_loyerController.text} €',
                },
                results: {
                  'Éligible': _eligible! ? 'Oui' : 'Non',
                  'Montant APL': '${_montantAPL?.toStringAsFixed(0) ?? '0'} €/mois',
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
