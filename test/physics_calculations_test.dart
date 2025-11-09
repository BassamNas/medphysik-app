import 'package:flutter_test/flutter_test.dart';
import 'package:medphysik_app/utils/physics_calculations.dart';
import 'dart:math';

void main() {
  group('Dosisberechnungen', () {
    test('Dosisberechnung mit Standardwerten', () {
      final dose = PhysicsCalculations.calculateDose(
        monitorUnits: 200.0,
        doseRate: 400.0,
        ssd: 100.0,
        depth: 10.0,
      );
      
      expect(dose, greaterThan(0));
      expect(dose, lessThan(10)); // Realistische Grenzen
    });
    
    test('Dosisberechnung mit verschiedenen Tiefen', () {
      final dose1 = PhysicsCalculations.calculateDose(
        monitorUnits: 200.0,
        doseRate: 400.0,
        ssd: 100.0,
        depth: 5.0,
      );
      
      final dose2 = PhysicsCalculations.calculateDose(
        monitorUnits: 200.0,
        doseRate: 400.0,
        ssd: 100.0,
        depth: 20.0,
      );
      
      // Dosis sollte mit Tiefe abnehmen
      expect(dose1, greaterThan(dose2));
    });
  });
  
  group('Monitor Units', () {
    test('MU-Berechnung mit Standardwerten', () {
      final mu = PhysicsCalculations.calculateMonitorUnits(
        prescribedDose: 2.0,
        outputFactor: 1.0,
        tpr: 0.67,
        scp: 0.98,
      );
      
      expect(mu, greaterThan(0));
      expect(mu, closeTo(3.044, 0.1)); // 2.0 / (1.0 × 0.67 × 0.98) ≈ 3.044
    });
    
    test('MU steigt mit höherer verschriebener Dosis', () {
      final mu1 = PhysicsCalculations.calculateMonitorUnits(
        prescribedDose: 2.0,
        outputFactor: 1.0,
        tpr: 0.67,
        scp: 0.98,
      );
      
      final mu2 = PhysicsCalculations.calculateMonitorUnits(
        prescribedDose: 4.0,
        outputFactor: 1.0,
        tpr: 0.67,
        scp: 0.98,
      );
      
      expect(mu2, closeTo(mu1 * 2, 0.01));
    });
  });
  
  group('Inverse Square Law', () {
    test('Inverse Square Law - doppelter Abstand = 1/4 Dosis', () {
      final initialDose = 1.0;
      final dose = PhysicsCalculations.inverseSquareLaw(
        initialDose: initialDose,
        initialDistance: 100.0,
        newDistance: 200.0,
      );
      
      expect(dose, closeTo(0.25, 0.01));
    });
    
    test('Inverse Square Law - halber Abstand = 4x Dosis', () {
      final initialDose = 1.0;
      final dose = PhysicsCalculations.inverseSquareLaw(
        initialDose: initialDose,
        initialDistance: 100.0,
        newDistance: 50.0,
      );
      
      expect(dose, closeTo(4.0, 0.01));
    });
    
    test('Inverse Square Law - gleicher Abstand = gleiche Dosis', () {
      final initialDose = 1.0;
      final dose = PhysicsCalculations.inverseSquareLaw(
        initialDose: initialDose,
        initialDistance: 100.0,
        newDistance: 100.0,
      );
      
      expect(dose, closeTo(1.0, 0.01));
    });
  });
  
  group('PDD-Berechnungen', () {
    test('PDD bei dmax sollte 100% sein', () {
      final pdd = PhysicsCalculations.calculatePDD(
        depth: 3.0, // dmax für 6 MV
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      expect(pdd, closeTo(100.0, 5.0));
    });
    
    test('PDD nimmt mit Tiefe ab (nach dmax)', () {
      final pdd1 = PhysicsCalculations.calculatePDD(
        depth: 5.0,
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      final pdd2 = PhysicsCalculations.calculatePDD(
        depth: 15.0,
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      expect(pdd1, greaterThan(pdd2));
    });
    
    test('Höhere Energie = tiefere Penetration', () {
      final depth = 10.0;
      
      final pdd6mv = PhysicsCalculations.calculatePDD(
        depth: depth,
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      final pdd15mv = PhysicsCalculations.calculatePDD(
        depth: depth,
        fieldSize: 10.0,
        energy: 15.0,
      );
      
      expect(pdd15mv, greaterThan(pdd6mv));
    });
  });
  
  group('Output Factor', () {
    test('Output Factor für Referenzfeld sollte 1.0 sein', () {
      final of = PhysicsCalculations.calculateOutputFactor(
        fieldSize: 10.0,
        referenceFieldSize: 10.0,
      );
      
      expect(of, equals(1.0));
    });
    
    test('Kleineres Feld = kleinerer Output Factor', () {
      final of = PhysicsCalculations.calculateOutputFactor(
        fieldSize: 5.0,
        referenceFieldSize: 10.0,
      );
      
      expect(of, lessThan(1.0));
    });
    
    test('Größeres Feld = größerer Output Factor', () {
      final of = PhysicsCalculations.calculateOutputFactor(
        fieldSize: 20.0,
        referenceFieldSize: 10.0,
      );
      
      expect(of, greaterThan(1.0));
    });
  });
  
  group('TPR-Berechnungen', () {
    test('TPR sollte zwischen 0 und 1 liegen', () {
      final tpr = PhysicsCalculations.calculateTPR(
        depth: 10.0,
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      expect(tpr, greaterThanOrEqualTo(0.0));
      expect(tpr, lessThanOrEqualTo(1.0));
    });
    
    test('TPR nimmt mit Tiefe ab', () {
      final tpr1 = PhysicsCalculations.calculateTPR(
        depth: 5.0,
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      final tpr2 = PhysicsCalculations.calculateTPR(
        depth: 15.0,
        fieldSize: 10.0,
        energy: 6.0,
      );
      
      expect(tpr1, greaterThan(tpr2));
    });
  });
  
  group('Beam Quality (TPR20,10)', () {
    test('TPR20,10 für 6 MV sollte ca. 0.67 sein', () {
      final tpr2010 = PhysicsCalculations.calculateTPR2010(6.0);
      
      expect(tpr2010, closeTo(0.67, 0.05));
    });
    
    test('TPR20,10 für 10 MV sollte ca. 0.74 sein', () {
      final tpr2010 = PhysicsCalculations.calculateTPR2010(10.0);
      
      expect(tpr2010, closeTo(0.74, 0.05));
    });
    
    test('TPR20,10 steigt mit Energie', () {
      final tpr6 = PhysicsCalculations.calculateTPR2010(6.0);
      final tpr10 = PhysicsCalculations.calculateTPR2010(10.0);
      
      expect(tpr10, greaterThan(tpr6));
    });
  });
  
  group('BED und EQD2', () {
    test('BED Berechnung', () {
      final bed = PhysicsCalculations.calculateBED(
        totalDose: 60.0,
        fractions: 30,
        alphaOverBeta: 10.0,
      );
      
      expect(bed, greaterThan(60.0)); // BED sollte größer sein als physikalische Dosis
      expect(bed, closeTo(72.0, 5.0)); // 60 × (1 + 2/10) = 72
    });
    
    test('EQD2 Berechnung', () {
      final eqd2 = PhysicsCalculations.calculateEQD2(
        totalDose: 60.0,
        fractions: 30,
        alphaOverBeta: 10.0,
      );
      
      expect(eqd2, closeTo(60.0, 5.0)); // Bei 2 Gy/Fraktion sollte EQD2 ≈ Totaldosis
    });
  });
  
  group('Mayneord F-Factor', () {
    test('F-Factor bei gleichem SSD sollte 1.0 sein', () {
      final factor = PhysicsCalculations.calculateMayneordFFactor(
        ssd1: 100.0,
        ssd2: 100.0,
        depth: 10.0,
      );
      
      expect(factor, closeTo(1.0, 0.01));
    });
    
    test('F-Factor ändert sich mit SSD', () {
      final factor = PhysicsCalculations.calculateMayneordFFactor(
        ssd1: 100.0,
        ssd2: 90.0,
        depth: 10.0,
      );
      
      expect(factor, isNot(equals(1.0)));
    });
  });
  
  group('Effektive Tiefe', () {
    test('Effektive Tiefe bei 0° sollte gleich geometrischer Tiefe sein', () {
      final effDepth = PhysicsCalculations.calculateEffectiveDepth(
        depth: 10.0,
        angle: 0.0,
      );
      
      expect(effDepth, closeTo(10.0, 0.01));
    });
    
    test('Effektive Tiefe steigt mit Winkel', () {
      final effDepth = PhysicsCalculations.calculateEffectiveDepth(
        depth: 10.0,
        angle: 45.0,
      );
      
      expect(effDepth, greaterThan(10.0));
      expect(effDepth, closeTo(10.0 * sqrt2, 0.1));
    });
  });
  
  group('Gamma-Index', () {
    test('Gamma-Index bei gleicher Dosis sollte 0 sein', () {
      final gamma = PhysicsCalculations.calculateGammaIndex(
        measuredDose: 2.0,
        calculatedDose: 2.0,
      );
      
      expect(gamma, equals(0.0));
    });
    
    test('Gamma-Index bei 3% Differenz sollte 1.0 sein (3%/3mm Kriterium)', () {
      final gamma = PhysicsCalculations.calculateGammaIndex(
        measuredDose: 2.06,
        calculatedDose: 2.0,
        doseThreshold: 3.0,
      );
      
      expect(gamma, closeTo(1.0, 0.1));
    });
  });
}
