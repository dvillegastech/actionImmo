import 'package:hive/hive.dart';

part 'simulation.g.dart';

@HiveType(typeId: 0)
class Simulation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String calculatorName;

  @HiveField(2)
  final Map<String, dynamic> inputs;

  @HiveField(3)
  final Map<String, dynamic> results;

  @HiveField(4)
  final DateTime date;

  Simulation({
    required this.id,
    required this.calculatorName,
    required this.inputs,
    required this.results,
    required this.date,
  });

  String get displayDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à $hour:$minute';
  }
}
