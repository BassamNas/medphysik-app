// Provider für Berechnungen und State Management
// Verwaltet den Zustand aller Berechnungen in der App

import 'package:flutter/foundation.dart';
import '../models/calculation_result.dart';
import '../utils/physics_calculations.dart';

class CalculationProvider with ChangeNotifier {
  // Berechnungshistorie
  final List<CalculationResult> _history = [];
  
  // Aktuelles Ergebnis
  CalculationResult? _currentResult;
  
  // Getters
  List<CalculationResult> get history => List.unmodifiable(_history);
  CalculationResult? get currentResult => _currentResult;
  
  // Dosisberechnung
  void calculateDose({
    required double monitorUnits,
    required double doseRate,
    required double ssd,
    required double depth,
  }) {
    try {
      final dose = PhysicsCalculations.calculateDose(
        monitorUnits: monitorUnits,
        doseRate: doseRate,
        ssd: ssd,
        depth: depth,
      );
      
      _currentResult = CalculationResult(
        type: 'Dosisberechnung',
        input: {
          'Monitor Units': '$monitorUnits MU',
          'Dosisleistung': '$doseRate MU/min',
          'SSD': '$ssd cm',
          'Tiefe': '$depth cm',
        },
        result: dose,
        unit: 'Gy',
        timestamp: DateTime.now(),
      );
      
      _history.insert(0, _currentResult!);
      notifyListeners();
    } catch (e) {
      debugPrint('Fehler bei Dosisberechnung: $e');
    }
  }
  
  // Monitor Units Berechnung
  void calculateMonitorUnits({
    required double prescribedDose,
    required double outputFactor,
    required double tpr,
    required double scp,
  }) {
    try {
      final mu = PhysicsCalculations.calculateMonitorUnits(
        prescribedDose: prescribedDose,
        outputFactor: outputFactor,
        tpr: tpr,
        scp: scp,
      );
      
      _currentResult = CalculationResult(
        type: 'Monitor Units',
        input: {
          'Verschriebene Dosis': '$prescribedDose Gy',
          'Output Factor': outputFactor.toStringAsFixed(3),
          'TPR': tpr.toStringAsFixed(3),
          'SCP': scp.toStringAsFixed(3),
        },
        result: mu,
        unit: 'MU',
        timestamp: DateTime.now(),
      );
      
      _history.insert(0, _currentResult!);
      notifyListeners();
    } catch (e) {
      debugPrint('Fehler bei MU-Berechnung: $e');
    }
  }
  
  // Inverse Square Law (Abstandsquadratgesetz)
  void calculateInverseSquare({
    required double initialDose,
    required double initialDistance,
    required double newDistance,
  }) {
    try {
      final newDose = PhysicsCalculations.inverseSquareLaw(
        initialDose: initialDose,
        initialDistance: initialDistance,
        newDistance: newDistance,
      );
      
      _currentResult = CalculationResult(
        type: 'Abstandsquadratgesetz',
        input: {
          'Anfangsdosis': '$initialDose Gy',
          'Anfangsabstand': '$initialDistance cm',
          'Neuer Abstand': '$newDistance cm',
        },
        result: newDose,
        unit: 'Gy',
        timestamp: DateTime.now(),
      );
      
      _history.insert(0, _currentResult!);
      notifyListeners();
    } catch (e) {
      debugPrint('Fehler bei Inverse Square Law: $e');
    }
  }
  
  // PDD Berechnung (Percentage Depth Dose)
  void calculatePDD({
    required double depth,
    required double fieldSize,
    required double energy,
  }) {
    try {
      final pdd = PhysicsCalculations.calculatePDD(
        depth: depth,
        fieldSize: fieldSize,
        energy: energy,
      );
      
      _currentResult = CalculationResult(
        type: 'PDD (Percentage Depth Dose)',
        input: {
          'Tiefe': '$depth cm',
          'Feldgröße': '${fieldSize}x$fieldSize cm²',
          'Energie': '$energy MV',
        },
        result: pdd,
        unit: '%',
        timestamp: DateTime.now(),
      );
      
      _history.insert(0, _currentResult!);
      notifyListeners();
    } catch (e) {
      debugPrint('Fehler bei PDD-Berechnung: $e');
    }
  }
  
  // Beam Quality (TPR20,10)
  void calculateBeamQuality({
    required double tpr20,
    required double tpr10,
  }) {
    try {
      final quality = tpr20 / tpr10;
      
      _currentResult = CalculationResult(
        type: 'Strahlqualität (TPR₂₀,₁₀)',
        input: {
          'TPR bei 20 cm': tpr20.toStringAsFixed(3),
          'TPR bei 10 cm': tpr10.toStringAsFixed(3),
        },
        result: quality,
        unit: '',
        timestamp: DateTime.now(),
        formula: 'TPR₂₀,₁₀ = TPR₂₀ / TPR₁₀',
      );
      
      _history.insert(0, _currentResult!);
      notifyListeners();
    } catch (e) {
      debugPrint('Fehler bei Beam Quality: $e');
    }
  }
  
  // Historie löschen
  void clearHistory() {
    _history.clear();
    _currentResult = null;
    notifyListeners();
  }
  
  // Einzelnes Ergebnis löschen
  void removeFromHistory(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      notifyListeners();
    }
  }
}
