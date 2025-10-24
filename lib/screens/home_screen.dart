import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/calculator_type.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Immobiliaria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.push('/map'),
            tooltip: 'Voir la carte',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Text(
            'Calculatrices Immobilières',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Outils professionnels pour le marché français',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.mediumGrey,
                ),
          ),
          const SizedBox(height: 24),

          // Grid de calculatrices
          ...CalculatorInfo.allCalculators.map(
            (calc) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CalculatorCard(calculator: calc),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final CalculatorInfo calculator;

  const _CalculatorCard({required this.calculator});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push(calculator.route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  calculator.icon,
                  color: AppTheme.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calculator.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      calculator.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Flèche
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.mediumGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
