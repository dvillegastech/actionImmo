import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/simulation.dart' as models;
import '../services/simulation_service.dart';

class SaveSimulationButton extends StatelessWidget {
  final String calculatorName;
  final Map<String, String> inputs;
  final Map<String, String> results;
  final bool enabled;

  const SaveSimulationButton({
    super.key,
    required this.calculatorName,
    required this.inputs,
    required this.results,
    this.enabled = true,
  });

  Future<void> _saveSimulation(BuildContext context) async {
    if (!enabled) return;

    final simulation = models.Simulation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      calculatorName: calculatorName,
      inputs: inputs,
      results: results,
      date: DateTime.now(),
    );

    await SimulationService().saveSimulation(simulation);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Simulation sauvegardée !'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: enabled ? () => _saveSimulation(context) : null,
      icon: const Icon(Icons.bookmark_outline_rounded),
      label: const Text('Sauvegarder'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        side: BorderSide(
          color: enabled ? AppTheme.primaryBlue : Colors.grey,
          width: 2,
        ),
        foregroundColor: enabled ? AppTheme.primaryBlue : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
