import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';

class TaxeFonciereScreen extends StatefulWidget {
  const TaxeFonciereScreen({super.key});

  @override
  State<TaxeFonciereScreen> createState() => _TaxeFonciereScreenState();
}

class _TaxeFonciereScreenState extends State<TaxeFonciereScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vlcController = TextEditingController();
  final _surfaceController = TextEditingController();

  String _commune = 'Paris';
  String _typeBien = 'Appartement';
  bool _useVlc = false;
  double? _taxeFonciere;
  double? _tauxCommune;
  double? _vlcCalculee;

  @override
  void dispose() {
    _vlcController.dispose();
    _surfaceController.dispose();
    super.dispose();
  }

  // Taux moyen par commune 2025
  Map<String, double> _getTaux() {
    return {
      'Paris': 0.134, // 13.4%
      'Lyon': 0.372, // 37.2%
      'Marseille': 0.325, // 32.5%
      'Bordeaux': 0.302, // 30.2%
      'Toulouse': 0.334, // 33.4%
      'Lille': 0.401, // 40.1%
      'Nantes': 0.296, // 29.6%
      'Nice': 0.237, // 23.7%
      'Strasbourg': 0.349, // 34.9%
      'Montpellier': 0.293, // 29.3%
      'Autre': 0.280, // 28% (moyenne nationale)
    };
  }

  // Estimation VLC par m² selon commune et type de bien
  double _getVlcParM2(String commune, String typeBien) {
    final vlcMoyenne = {
      'Paris': {'Appartement': 18.0, 'Maison': 22.0},
      'Lyon': {'Appartement': 14.0, 'Maison': 17.0},
      'Marseille': {'Appartement': 11.0, 'Maison': 13.0},
      'Bordeaux': {'Appartement': 13.0, 'Maison': 16.0},
      'Toulouse': {'Appartement': 12.0, 'Maison': 15.0},
      'Lille': {'Appartement': 10.0, 'Maison': 12.0},
      'Nantes': {'Appartement': 11.0, 'Maison': 14.0},
      'Nice': {'Appartement': 15.0, 'Maison': 18.0},
      'Strasbourg': {'Appartement': 11.0, 'Maison': 13.0},
      'Montpellier': {'Appartement': 12.0, 'Maison': 14.0},
      'Autre': {'Appartement': 10.0, 'Maison': 12.0},
    };
    return vlcMoyenne[commune]?[typeBien] ?? 10.0;
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final taux = _getTaux()[_commune]!;
      double vlc;

      if (_useVlc) {
        // Utiliser la VLC saisie directement
        vlc = double.parse(_vlcController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      } else {
        // Estimer la VLC basée sur la surface
        final surface = double.parse(_surfaceController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
        final vlcParM2 = _getVlcParM2(_commune, _typeBien);
        vlc = surface * vlcParM2;
      }

      // Calcul: Taxe Foncière = VLC × Taux communal
      final taxe = vlc * taux;

      setState(() {
        _taxeFonciere = taxe;
        _tauxCommune = taux * 100;
        _vlcCalculee = vlc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Taxe Foncière',
      description: 'Estimez votre taxe foncière (Données 2025)',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode de calcul
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
                    'Mode de calcul',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Estimer', style: TextStyle(fontSize: 14)),
                          value: false,
                          groupValue: _useVlc,
                          onChanged: (value) {
                            setState(() {
                              _useVlc = value!;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('VLC connue', style: TextStyle(fontSize: 14)),
                          value: true,
                          groupValue: _useVlc,
                          onChanged: (value) {
                            setState(() {
                              _useVlc = value!;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Commune
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
                    'Commune',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _commune,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Paris',
                      'Lyon',
                      'Marseille',
                      'Bordeaux',
                      'Toulouse',
                      'Lille',
                      'Nantes',
                      'Nice',
                      'Strasbourg',
                      'Montpellier',
                      'Autre'
                    ].map((ville) {
                      return DropdownMenuItem(value: ville, child: Text(ville));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _commune = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_useVlc) ...[
              // Mode VLC connue
              InputField(
                controller: _vlcController,
                label: 'Valeur Locative Cadastrale (VLC)',
                hint: 'Ex: 8500',
                suffix: '€',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cleaned.isEmpty || double.tryParse(cleaned) == null) return 'Invalide';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'La VLC est indiquée sur votre avis d\'imposition',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Mode estimation
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
                      'Type de bien',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _typeBien,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Appartement', 'Maison'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _typeBien = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _surfaceController,
                label: 'Surface habitable',
                hint: 'Ex: 75',
                suffix: 'm²',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
                  if (cleaned.isEmpty || double.tryParse(cleaned) == null) return 'Invalide';
                  return null;
                },
              ),
            ],

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculer la taxe foncière'),
            ),
            const SizedBox(height: 32),

            if (_taxeFonciere != null) ...[
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
                      'Taxe foncière ${_useVlc ? '' : 'estimée'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_taxeFonciere!.toStringAsFixed(0)} €',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'par an',
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow('Commune', _commune),
                    const SizedBox(height: 8),
                    _InfoRow('Taux communal', '${_tauxCommune!.toStringAsFixed(1)}%'),
                    const SizedBox(height: 8),
                    _InfoRow('VLC', '${_vlcCalculee!.toStringAsFixed(0)} €'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (!_useVlc)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Cette estimation est indicative. Le montant réel peut varier selon '
                          'les caractéristiques précises de votre bien. Consultez votre avis d\'imposition '
                          'pour le montant exact.',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 14,
                          ),
                        ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Informations',
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
                      '• Payée par le propriétaire au 1er janvier\n'
                      '• Construction neuve : 2 ans d\'exonération possible\n'
                      '• Exonérations pour personnes âgées à faibles revenus\n'
                      '• Le taux varie selon les communes (13% à 40%)',
                      style: TextStyle(color: Colors.blue[900], fontSize: 14),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
