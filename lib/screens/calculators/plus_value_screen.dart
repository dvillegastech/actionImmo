import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/result_card.dart';

class PlusValueScreen extends StatefulWidget {
  const PlusValueScreen({super.key});

  @override
  State<PlusValueScreen> createState() => _PlusValueScreenState();
}

class _PlusValueScreenState extends State<PlusValueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prixAchatController = TextEditingController();
  final _prixVenteController = TextEditingController();
  final _dureeDetentionController = TextEditingController();

  double? _plusValueBrute;
  double? _plusValueImposable;
  double? _impot;
  double? _gainNet;

  @override
  void dispose() {
    _prixAchatController.dispose();
    _prixVenteController.dispose();
    _dureeDetentionController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final prixAchat = double.parse(_prixAchatController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final prixVente = double.parse(_prixVenteController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final dureeAnnees = int.parse(_dureeDetentionController.text);

      final plusValueBrut = prixVente - prixAchat;

      // Abattement pour durée de détention (résidence secondaire)
      // Impôt sur le revenu: 6% par an de la 6ème à la 21ème année, puis 4% la 22ème
      // Prélèvements sociaux: 1.65% de la 6ème à la 21ème, 1.60% la 22ème, puis 9% jusqu'à 30 ans
      double abattementIR = 0;
      double abattementPS = 0;

      if (dureeAnnees > 5 && dureeAnnees <= 21) {
        abattementIR = (dureeAnnees - 5) * 6;
        abattementPS = (dureeAnnees - 5) * 1.65;
      } else if (dureeAnnees == 22) {
        abattementIR = (21 - 5) * 6 + 4;
        abattementPS = (21 - 5) * 1.65 + 1.60;
      } else if (dureeAnnees > 22 && dureeAnnees < 30) {
        abattementIR = 100; // Exonération totale après 22 ans
        abattementPS = (21 - 5) * 1.65 + 1.60 + (dureeAnnees - 22) * 9;
      } else if (dureeAnnees >= 30) {
        abattementIR = 100;
        abattementPS = 100; // Exonération totale
      }

      final plusValueImposableIR = plusValueBrut * (1 - abattementIR / 100);
      final plusValueImposablePS = plusValueBrut * (1 - abattementPS / 100);

      // Impôts: 19% IR + 17.2% prélèvements sociaux
      final impotIR = plusValueImposableIR * 0.19;
      final prelevementsS = plusValueImposablePS * 0.172;
      final impotTotal = impotIR + prelevementsS;

      setState(() {
        _plusValueBrute = plusValueBrut;
        _plusValueImposable = plusValueImposableIR + plusValueImposablePS;
        _impot = impotTotal;
        _gainNet = plusValueBrut - impotTotal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Plus-Value Immobilière',
      description: 'Calculez l\'impôt sur la plus-value de votre bien',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputField(
              controller: _prixAchatController,
              label: 'Prix d\'achat',
              hint: 'Ex: 200000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _prixVenteController,
              label: 'Prix de vente',
              hint: 'Ex: 280000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _dureeDetentionController,
              label: 'Durée de détention',
              hint: 'Ex: 10',
              suffix: 'ans',
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requis' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculer'),
            ),
            const SizedBox(height: 32),
            if (_plusValueBrute != null) ...[
              ResultCard(
                title: 'Plus-value brute',
                value: _plusValueBrute!,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Impôt total',
                value: _impot!,
                color: AppTheme.error,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Gain net après impôts',
                value: _gainNet!,
                color: AppTheme.success,
                isMain: true,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightBlue.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Exonération totale après 30 ans de détention. '
                  'Les résidences principales sont exonérées d\'impôt sur la plus-value.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
