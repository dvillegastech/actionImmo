import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/result_card.dart';
import '../../widgets/save_simulation_button.dart';

class RendementLocatifScreen extends StatefulWidget {
  const RendementLocatifScreen({super.key});

  @override
  State<RendementLocatifScreen> createState() => _RendementLocatifScreenState();
}

class _RendementLocatifScreenState extends State<RendementLocatifScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prixAchatController = TextEditingController();
  final _fraisAchatController = TextEditingController();
  final _loyerController = TextEditingController();
  final _chargesController = TextEditingController(text: '0');
  final _taxeFonciereController = TextEditingController(text: '0');

  double? _rendementBrut;
  double? _rendementNet;
  double? _cashflowAnnuel;

  @override
  void dispose() {
    _prixAchatController.dispose();
    _fraisAchatController.dispose();
    _loyerController.dispose();
    _chargesController.dispose();
    _taxeFonciereController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final prixAchat =
          double.parse(_prixAchatController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final fraisAchat =
          double.parse(_fraisAchatController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final loyerMensuel =
          double.parse(_loyerController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final chargesMensuelles =
          double.parse(_chargesController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final taxeFonciere =
          double.parse(_taxeFonciereController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      final investissementTotal = prixAchat + fraisAchat;
      final loyerAnnuel = loyerMensuel * 12;
      final chargesAnnuelles = (chargesMensuelles * 12) + taxeFonciere;

      // Rendement brut = (Loyer annuel / Investissement total) * 100
      final rendBrut = (loyerAnnuel / investissementTotal) * 100;

      // Rendement net = ((Loyer annuel - Charges) / Investissement total) * 100
      final rendNet = ((loyerAnnuel - chargesAnnuelles) / investissementTotal) * 100;

      // Cashflow annuel
      final cashflow = loyerAnnuel - chargesAnnuelles;

      setState(() {
        _rendementBrut = rendBrut;
        _rendementNet = rendNet;
        _cashflowAnnuel = cashflow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Rendement Locatif',
      description: 'Calculez la rentabilité brute et nette de votre investissement',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prix d'achat
            InputField(
              controller: _prixAchatController,
              label: 'Prix d\'achat du bien',
              hint: 'Ex: 150000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le prix';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Frais d'achat
            InputField(
              controller: _fraisAchatController,
              label: 'Frais d\'achat (notaire, travaux)',
              hint: 'Ex: 15000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer les frais';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Loyer mensuel
            InputField(
              controller: _loyerController,
              label: 'Loyer mensuel',
              hint: 'Ex: 850',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le loyer';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Charges mensuelles
            InputField(
              controller: _chargesController,
              label: 'Charges mensuelles',
              hint: 'Ex: 100',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) => null,
            ),
            const SizedBox(height: 20),

            // Taxe foncière
            InputField(
              controller: _taxeFonciereController,
              label: 'Taxe foncière annuelle',
              hint: 'Ex: 800',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) => null,
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
            if (_rendementBrut != null) ...[
              // Rendement brut
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.success.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendement brut',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_rendementBrut!.toStringAsFixed(2)} %',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sans déduction des charges',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.success.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Rendement net
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendement net',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_rendementNet!.toStringAsFixed(2)} %',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Après déduction des charges',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryBlue.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              ResultCard(
                title: 'Cashflow annuel',
                value: _cashflowAnnuel!,
                color: AppTheme.accentBlue,
                subtitle: '${(_cashflowAnnuel! / 12).toStringAsFixed(2)} € par mois',
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
                          'Repères de rendement',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Rendement brut < 5% : Faible\n'
                      '• Rendement brut 5-8% : Moyen\n'
                      '• Rendement brut > 8% : Excellent\n\n'
                      'Le rendement net est plus représentatif de la rentabilité réelle. '
                      'N\'oubliez pas les impôts fonciers et sur les revenus locatifs.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SaveSimulationButton(
                calculatorName: 'Rendement Locatif',
                enabled: _rendementBrut != null,
                inputs: {
                  'Prix achat': '${_prixAchatController.text} €',
                  'Frais achat': '${_fraisAchatController.text} €',
                  'Loyer': '${_loyerController.text} €',
                  'Charges': '${_chargesController.text} €',
                  'Taxe foncière': '${_taxeFonciereController.text} €',
                },
                results: {
                  'Rendement brut': '${_rendementBrut?.toStringAsFixed(2) ?? '0'} %',
                  'Rendement net': '${_rendementNet?.toStringAsFixed(2) ?? '0'} %',
                  'Cashflow annuel': '${_cashflowAnnuel?.toStringAsFixed(0) ?? '0'} €',
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
