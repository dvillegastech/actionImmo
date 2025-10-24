import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_simulation_button.dart';

class CreditImmobilierScreen extends StatefulWidget {
  const CreditImmobilierScreen({super.key});

  @override
  State<CreditImmobilierScreen> createState() => _CreditImmobilierScreenState();
}

class _CreditImmobilierScreenState extends State<CreditImmobilierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _tauxController = TextEditingController(text: '3.5');
  final _dureeController = TextEditingController(text: '20');
  final _assuranceController = TextEditingController(text: '0.3');

  double? _mensualite;
  double? _coutTotal;
  double? _coutCredit;
  double? _mensualiteAssurance;

  @override
  void dispose() {
    _montantController.dispose();
    _tauxController.dispose();
    _dureeController.dispose();
    _assuranceController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final montant = double.parse(_montantController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final tauxAnnuel = double.parse(_tauxController.text) / 100;
      final dureeAnnees = int.parse(_dureeController.text);
      final tauxAssurance = double.parse(_assuranceController.text) / 100;

      // Calcul mensualité hors assurance
      final tauxMensuel = tauxAnnuel / 12;
      final nbMois = dureeAnnees * 12;

      final mensualiteHorsAssurance = montant *
          (tauxMensuel * pow(1 + tauxMensuel, nbMois)) /
          (pow(1 + tauxMensuel, nbMois) - 1);

      // Assurance mensuelle
      final assuranceMensuelle = (montant * tauxAssurance) / 12;

      setState(() {
        _mensualiteAssurance = assuranceMensuelle;
        _mensualite = mensualiteHorsAssurance + assuranceMensuelle;
        _coutTotal = _mensualite! * nbMois;
        _coutCredit = _coutTotal! - montant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Crédit Immobilier',
      description: 'Calculez vos mensualités de prêt immobilier avec assurance',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Montant emprunté
            InputField(
              controller: _montantController,
              label: 'Montant emprunté',
              hint: 'Ex: 200000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un montant';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Taux d'intérêt
            InputField(
              controller: _tauxController,
              label: 'Taux d\'intérêt annuel',
              hint: 'Ex: 3.5',
              suffix: '%',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un taux';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Durée
            InputField(
              controller: _dureeController,
              label: 'Durée du prêt',
              hint: 'Ex: 20',
              suffix: 'ans',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une durée';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Taux assurance
            InputField(
              controller: _assuranceController,
              label: 'Taux d\'assurance',
              hint: 'Ex: 0.3',
              suffix: '%',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un taux';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Bouton calculer
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculer'),
            ),
            const SizedBox(height: 32),

            // Résultats
            if (_mensualite != null) ...[
              ResultCard(
                title: 'Mensualité totale',
                value: _mensualite!,
                color: AppTheme.primaryBlue,
                isMain: true,
                subtitle: 'dont ${(_mensualiteAssurance!).toStringAsFixed(2)} € d\'assurance',
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Coût total du crédit',
                value: _coutCredit!,
                color: AppTheme.warning,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Montant total remboursé',
                value: _coutTotal!,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(height: 20),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightBlue.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: AppTheme.accentBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Taux actuels en France (2024)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• 10 ans: 3.0% - 3.5%\n'
                      '• 15 ans: 3.2% - 3.7%\n'
                      '• 20 ans: 3.5% - 4.0%\n'
                      '• 25 ans: 3.7% - 4.2%\n\n'
                      'Assurance: 0.25% - 0.40% selon profil',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SaveSimulationButton(
                calculatorName: 'Crédit Immobilier',
                enabled: _mensualite != null,
                inputs: {
                  'Montant': '${_montantController.text} €',
                  'Taux': '${_tauxController.text} %',
                  'Durée': '${_dureeController.text} ans',
                  'Assurance': '${_assuranceController.text} %',
                },
                results: {
                  'Mensualité': '${_mensualite?.toStringAsFixed(2) ?? '0'} €',
                  'Coût total': '${_coutTotal?.toStringAsFixed(0) ?? '0'} €',
                  'Coût crédit': '${_coutCredit?.toStringAsFixed(0) ?? '0'} €',
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
