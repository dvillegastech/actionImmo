import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/result_card.dart';

class CapaciteEmpruntScreen extends StatefulWidget {
  const CapaciteEmpruntScreen({super.key});

  @override
  State<CapaciteEmpruntScreen> createState() => _CapaciteEmpruntScreenState();
}

class _CapaciteEmpruntScreenState extends State<CapaciteEmpruntScreen> {
  final _formKey = GlobalKey<FormState>();
  final _revenuController = TextEditingController();
  final _chargesController = TextEditingController(text: '0');
  final _apportController = TextEditingController(text: '0');
  final _tauxController = TextEditingController(text: '3.5');
  final _dureeController = TextEditingController(text: '20');

  double? _capaciteEmprunt;
  double? _budgetTotal;
  double? _mensualiteMax;
  double? _tauxEndettement;

  @override
  void dispose() {
    _revenuController.dispose();
    _chargesController.dispose();
    _apportController.dispose();
    _tauxController.dispose();
    _dureeController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final revenuMensuel =
          double.parse(_revenuController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final chargesMensuelles =
          double.parse(_chargesController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final apport = double.parse(_apportController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final tauxAnnuel = double.parse(_tauxController.text) / 100;
      final dureeAnnees = int.parse(_dureeController.text);

      // Règle des 33% (taux d'endettement maximum)
      final mensualiteMaximale =
          (revenuMensuel * 0.33) - chargesMensuelles;

      if (mensualiteMaximale <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vos charges dépassent 33% de vos revenus'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      // Calcul de la capacité d'emprunt
      final tauxMensuel = tauxAnnuel / 12;
      final nbMois = dureeAnnees * 12;

      final capacite = mensualiteMaximale *
          ((pow(1 + tauxMensuel, nbMois) - 1) /
              (tauxMensuel * pow(1 + tauxMensuel, nbMois)));

      // Taux d'endettement réel
      final tauxEndet = (mensualiteMaximale + chargesMensuelles) / revenuMensuel;

      setState(() {
        _mensualiteMax = mensualiteMaximale;
        _capaciteEmprunt = capacite;
        _budgetTotal = capacite + apport;
        _tauxEndettement = tauxEndet * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Capacité d\'Emprunt',
      description:
          'Déterminez votre budget immobilier selon la règle des 33%',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Revenus mensuels
            InputField(
              controller: _revenuController,
              label: 'Revenus mensuels nets',
              hint: 'Ex: 3500',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer vos revenus';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Charges mensuelles
            InputField(
              controller: _chargesController,
              label: 'Charges mensuelles',
              hint: 'Ex: 200',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) => null,
            ),
            const SizedBox(height: 20),

            // Apport personnel
            InputField(
              controller: _apportController,
              label: 'Apport personnel',
              hint: 'Ex: 30000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) => null,
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
            if (_capaciteEmprunt != null) ...[
              ResultCard(
                title: 'Budget total (avec apport)',
                value: _budgetTotal!,
                color: AppTheme.primaryBlue,
                isMain: true,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Capacité d\'emprunt',
                value: _capaciteEmprunt!,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Mensualité maximale',
                value: _mensualiteMax!,
                color: AppTheme.success,
                subtitle: 'Taux d\'endettement: ${_tauxEndettement!.toStringAsFixed(1)}%',
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
                          'Règle des 33%',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les banques françaises limitent généralement le taux d\'endettement '
                      'à 33% des revenus nets. Ce calcul inclut toutes vos charges de crédit. '
                      'N\'oubliez pas d\'ajouter environ 10% pour les frais de notaire.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
