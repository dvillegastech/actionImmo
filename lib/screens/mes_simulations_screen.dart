import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/simulation.dart' as models;
import '../services/simulation_service.dart';
import '../theme/app_theme.dart';

final simulationServiceProvider = Provider((ref) => SimulationService());

final simulationsProvider = StreamProvider<List<models.Simulation>>((ref) async* {
  final service = ref.watch(simulationServiceProvider);
  while (true) {
    yield service.getAllSimulations();
    await Future.delayed(const Duration(seconds: 1));
  }
});

class MesSimulationsScreen extends ConsumerWidget {
  const MesSimulationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulationsAsync = ref.watch(simulationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Simulations'),
        actions: [
          simulationsAsync.maybeWhen(
            data: (simulations) => simulations.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () => _showClearAllDialog(context, ref),
                    tooltip: 'Tout supprimer',
                  )
                : const SizedBox(),
            orElse: () => const SizedBox(),
          ),
        ],
      ),
      body: simulationsAsync.when(
        data: (simulations) {
          if (simulations.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildSimulationsList(context, ref, simulations);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune simulation sauvegardée',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Vos calculs sauvegardés apparaîtront ici',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationsList(
    BuildContext context,
    WidgetRef ref,
    List<models.Simulation> simulations,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: simulations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final simulation = simulations[index];
        return _SimulationCard(
          simulation: simulation,
          onDelete: () => _deleteSimulation(ref, simulation.id),
        );
      },
    );
  }

  void _deleteSimulation(WidgetRef ref, String id) {
    final service = ref.read(simulationServiceProvider);
    service.deleteSimulation(id);
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer tout ?'),
        content: const Text(
          'Voulez-vous vraiment supprimer toutes vos simulations ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final service = ref.read(simulationServiceProvider);
              service.clearAll();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _SimulationCard extends StatelessWidget {
  final models.Simulation simulation;
  final VoidCallback onDelete;

  const _SimulationCard({
    required this.simulation,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIcon(simulation.calculatorName),
            color: AppTheme.primaryBlue,
          ),
        ),
        title: Text(
          simulation.calculatorName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          simulation.displayDate,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _showDeleteDialog(context),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inputs
                if (simulation.inputs.isNotEmpty) ...[
                  Text(
                    'Paramètres:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...simulation.inputs.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                ],

                // Results
                Text(
                  'Résultats:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                ),
                const SizedBox(height: 8),
                ...simulation.results.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${entry.value}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String calculatorName) {
    if (calculatorName.contains('Notaire')) return Icons.gavel;
    if (calculatorName.contains('Crédit')) return Icons.account_balance;
    if (calculatorName.contains('Capacité')) return Icons.trending_up;
    if (calculatorName.contains('Rendement')) return Icons.percent;
    if (calculatorName.contains('PTZ')) return Icons.savings;
    if (calculatorName.contains('Taxe')) return Icons.receipt_long;
    if (calculatorName.contains('APL')) return Icons.home_work;
    if (calculatorName.contains('DPE')) return Icons.energy_savings_leaf;
    if (calculatorName.contains('Pinel')) return Icons.business_center;
    return Icons.calculate;
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: const Text('Voulez-vous supprimer cette simulation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
