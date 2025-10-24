import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CalculatorScaffold extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const CalculatorScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
            ),
            const SizedBox(height: 24),

            // Contenu
            child,
          ],
        ),
      ),
    );
  }
}
