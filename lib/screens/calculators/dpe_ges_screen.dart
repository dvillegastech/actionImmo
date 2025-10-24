import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calculator_scaffold.dart';
import '../../widgets/input_field.dart';
import '../../widgets/save_simulation_button.dart';

class DpeGesScreen extends StatefulWidget {
  const DpeGesScreen({super.key});

  @override
  State<DpeGesScreen> createState() => _DpeGesScreenState();
}

class _DpeGesScreenState extends State<DpeGesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _consommationController = TextEditingController();
  final _emissionsController = TextEditingController();

  String? _classeDPE;
  String? _classeGES;
  String? _classeFinal;
  bool _interdictionLocation = false;

  @override
  void dispose() {
    _consommationController.dispose();
    _emissionsController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final conso = double.parse(_consommationController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final emissions = double.parse(_emissionsController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      // Déterminer classe DPE (consommation)
      String classeConso;
      if (conso < 70) classeConso = 'A';
      else if (conso < 110) classeConso = 'B';
      else if (conso < 180) classeConso = 'C';
      else if (conso < 250) classeConso = 'D';
      else if (conso < 330) classeConso = 'E';
      else if (conso < 420) classeConso = 'F';
      else classeConso = 'G';

      // Déterminer classe GES (émissions)
      String classeEmissions;
      if (emissions < 6) classeEmissions = 'A';
      else if (emissions < 11) classeEmissions = 'B';
      else if (emissions < 30) classeEmissions = 'C';
      else if (emissions < 50) classeEmissions = 'D';
      else if (emissions < 70) classeEmissions = 'E';
      else if (emissions < 100) classeEmissions = 'F';
      else classeEmissions = 'G';

      // Classe finale = la plus défavorable
      final classes = [classeConso, classeEmissions];
      final classeFinal = classes.contains('G') ? 'G' :
                          classes.contains('F') ? 'F' :
                          classes.contains('E') ? 'E' :
                          classes.contains('D') ? 'D' :
                          classes.contains('C') ? 'C' :
                          classes.contains('B') ? 'B' : 'A';

      // Interdiction de location en 2025
      final interdit = classeFinal == 'G'; // G interdit depuis 2025

      setState(() {
        _classeDPE = classeConso;
        _classeGES = classeEmissions;
        _classeFinal = classeFinal;
        _interdictionLocation = interdit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'DPE / GES',
      description: 'Calculez la classe énergétique de votre logement (Données 2025)',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputField(
              controller: _consommationController,
              label: 'Consommation énergétique',
              hint: 'Ex: 180',
              suffix: 'kWh/m²/an',
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
              controller: _emissionsController,
              label: 'Émissions de GES',
              hint: 'Ex: 35',
              suffix: 'kg CO₂/m²/an',
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
              child: const Text('Calculer la classe DPE'),
            ),
            const SizedBox(height: 32),

            if (_classeFinal != null) ...[
              _DpeBadge(classe: _classeFinal!),
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
                    _InfoRow('Classe énergie', _classeDPE!),
                    const SizedBox(height: 8),
                    _InfoRow('Classe GES', _classeGES!),
                    const SizedBox(height: 8),
                    _InfoRow('Classe finale', _classeFinal!, isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_interdictionLocation)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.block, color: Colors.red[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Logement classé G : Interdit à la location depuis le 1er janvier 2025',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w600,
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
                        Icon(Icons.calendar_today, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Interdictions de location',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Classe G : interdite depuis 2025\n'
                      '• Classe F : interdite en 2028\n'
                      '• Classe E : interdite en 2034',
                      style: TextStyle(color: Colors.blue[900], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SaveSimulationButton(
                calculatorName: 'DPE / GES',
                enabled: _classeFinal != null,
                inputs: {
                  'Consommation': '${_consommationController.text} kWh/m²/an',
                  'Émissions': '${_emissionsController.text} kg CO₂/m²/an',
                },
                results: {
                  'Classe énergie': _classeDPE!,
                  'Classe GES': _classeGES!,
                  'Classe finale': _classeFinal!,
                  'Interdit location': _interdictionLocation ? 'Oui' : 'Non',
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DpeBadge extends StatelessWidget {
  final String classe;

  const _DpeBadge({required this.classe});

  Color _getColor() {
    switch (classe) {
      case 'A': return const Color(0xFF009E5A);
      case 'B': return const Color(0xFF5DB75E);
      case 'C': return const Color(0xFFC2D82E);
      case 'D': return const Color(0xFFFEE500);
      case 'E': return const Color(0xFFFDB813);
      case 'F': return const Color(0xFFF68B1F);
      case 'G': return const Color(0xFFED1C24);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Classe',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                classe,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _getColor(),
                ),
              ),
            ),
          ),
        ],
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
