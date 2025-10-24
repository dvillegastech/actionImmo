import 'package:hive_flutter/hive_flutter.dart';
import '../models/simulation.dart';

class SimulationService {
  static const String _boxName = 'simulations';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SimulationAdapter());
    await Hive.openBox<Simulation>(_boxName);
  }

  Box<Simulation> get _box => Hive.box<Simulation>(_boxName);

  Future<void> saveSimulation(Simulation simulation) async {
    await _box.put(simulation.id, simulation);
  }

  List<Simulation> getAllSimulations() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Plus récent d'abord
  }

  List<Simulation> getSimulationsByCalculator(String calculatorName) {
    return _box.values
        .where((s) => s.calculatorName == calculatorName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> deleteSimulation(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  int get count => _box.length;
}
