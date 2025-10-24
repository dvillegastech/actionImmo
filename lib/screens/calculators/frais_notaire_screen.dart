import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/result_card.dart';

class FraisNotaireScreen extends StatefulWidget {
  const FraisNotaireScreen({super.key});

  @override
  State<FraisNotaireScreen> createState() => _FraisNotaireScreenState();
}

class _FraisNotaireScreenState extends State<FraisNotaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prixController = TextEditingController();

  bool _isAncien = true;
  double? _fraisNotaire;
  double? _totalAPayer;

  @override
  void dispose() {
    _prixController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final prix = double.parse(_prixController.text.replaceAll(' ', ''));

      // Taux de frais de notaire
      // Ancien: 7-8% (on prend 7.5% en moyenne)
      // Neuf: 2-3% (on prend 2.5% en moyenne)
      final tauxFrais = _isAncien ? 0.075 : 0.025;

      setState(() {
        _fraisNotaire = prix * tauxFrais;
        _totalAPayer = prix + _fraisNotaire!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Frais de Notaire',
      description: 'Estimez les frais de notaire pour votre achat immobilier',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prix du bien
            InputField(
              controller: _prixController,
              label: 'Prix du bien',
              hint: 'Ex: 250000',
              suffix: '€',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prix';
                }
                if (double.tryParse(value.replaceAll(' ', '')) == null) {
                  return 'Prix invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Type de bien
            Text(
              'Type de bien',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Ancien',
                    sublabel: '7-8%',
                    isSelected: _isAncien,
                    onTap: () => setState(() => _isAncien = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeButton(
                    label: 'Neuf',
                    sublabel: '2-3%',
                    isSelected: !_isAncien,
                    onTap: () => setState(() => _isAncien = false),
                  ),
                ),
              ],
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
            if (_fraisNotaire != null) ...[
              ResultCard(
                title: 'Frais de notaire',
                value: _fraisNotaire!,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(height: 12),
              ResultCard(
                title: 'Total à payer',
                value: _totalAPayer!,
                color: AppTheme.primaryBlue,
                isMain: true,
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
                          'À savoir',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les frais de notaire comprennent: les droits de mutation (taxes), '
                      'les émoluments du notaire, et les frais administratifs. '
                      'Pour un bien ancien, comptez environ 7-8% du prix. '
                      'Pour un bien neuf, ces frais sont réduits à 2-3%.',
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

class _TypeButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withOpacity(0.1)
              : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.darkBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mediumGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
