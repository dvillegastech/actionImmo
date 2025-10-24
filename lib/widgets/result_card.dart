import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final bool isMain;
  final String? subtitle;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.isMain = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00 €', 'fr_FR');
    final formattedValue = formatter.format(value).replaceAll(',', ' ');

    return Container(
      padding: EdgeInsets.all(isMain ? 20 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: isMain ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedValue,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: isMain ? 28 : 24,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.7),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
