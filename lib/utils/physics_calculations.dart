// Medizinphysikalische Berechnungen
// Alle Formeln und Berechnungsmethoden für Dosimetrie und Strahlentherapie

import 'dart:math';

class PhysicsCalculations {
  // Konstanten
  static const double kGy = 1.0; // Gray
  static const double kCGy = 0.01; // centiGray
  
  /// Dosisberechnung
  /// Formel: Dose = MU × Output × ISF × TMR × SCP
  /// 
  /// Parameter:
  /// - monitorUnits: Monitor Units (MU)
  /// - doseRate: Dosisleistung in MU/min
  /// - ssd: Source-to-Surface Distance in cm
  /// - depth: Tiefe in cm
  static double calculateDose({
    required double monitorUnits,
    required double doseRate,
    required double ssd,
    required double depth,
  }) {
    // Vereinfachte Dosisberechnung
    // In der Praxis: Dose = MU × Calibration Factor × Corrections
    
    final sad = 100.0; // Standard: 100 cm für isozentrische Technik
    final calibrationFactor = 1.0; // 1 cGy/MU bei Standard-Bedingungen
    
    // Inverse Square Law Korrektur
    final isfCorrection = pow((sad + depth) / (ssd + depth), 2);
    
    // PDD-Näherung (vereinfacht)
    final pdd = _estimatePDD(depth, 10.0, 6.0) / 100.0;
    
    // Dosis in Gy
    final dose = monitorUnits * calibrationFactor * isfCorrection * pdd / 100.0;
    
    return dose;
  }
  
  /// Monitor Units Berechnung
  /// Formel: MU = PrescribedDose / (OutputFactor × TPR × SCP)
  /// 
  /// Parameter:
  /// - prescribedDose: Verschriebene Dosis in Gy
  /// - outputFactor: Output Factor (dimensionslos)
  /// - tpr: Tissue-Phantom Ratio
  /// - scp: Scatter Correction Factor
  static double calculateMonitorUnits({
    required double prescribedDose,
    required double outputFactor,
    required double tpr,
    required double scp,
  }) {
    // MU = Dose / (Output × TPR × SCP)
    final mu = prescribedDose / (outputFactor * tpr * scp);
    return mu;
  }
  
  /// Abstandsquadratgesetz (Inverse Square Law)
  /// Formel: I₂ = I₁ × (d₁/d₂)²
  /// 
  /// Parameter:
  /// - initialDose: Anfangsdosis
  /// - initialDistance: Anfangsabstand in cm
  /// - newDistance: Neuer Abstand in cm
  static double inverseSquareLaw({
    required double initialDose,
    required double initialDistance,
    required double newDistance,
  }) {
    return initialDose * pow(initialDistance / newDistance, 2);
  }
  
  /// Percentage Depth Dose (PDD) Berechnung
  /// Empirische Näherungsformel
  /// 
  /// Parameter:
  /// - depth: Tiefe in cm
  /// - fieldSize: Feldgröße in cm
  /// - energy: Strahlenergie in MV
  static double calculatePDD({
    required double depth,
    required double fieldSize,
    required double energy,
  }) {
    return _estimatePDD(depth, fieldSize, energy);
  }
  
  /// PDD-Näherungsformel (vereinfacht)
  /// Basiert auf empirischen Daten für 6 MV und 10 MV
  static double _estimatePDD(double depth, double fieldSize, double energy) {
    // dmax: Tiefe des Dosismaximums
    final dmax = _calculateDmax(energy);
    
    if (depth <= 0) return 0.0;
    if (depth <= dmax) {
      // Build-up Region
      return 100.0 * (depth / dmax);
    }
    
    // Beyond dmax: Exponentieller Abfall
    // PDD = 100 × exp(-μ × (d - dmax))
    final mu = 0.04 - (energy * 0.002); // Abschwächungskoeffizient
    final pdd = 100.0 * exp(-mu * (depth - dmax));
    
    // Feldgrößenkorrektur (größeres Feld = mehr Streuung = höhere PDD)
    final fieldCorrection = 1.0 + (fieldSize - 10.0) * 0.005;
    
    return pdd * fieldCorrection;
  }
  
  /// Berechnet Tiefe des Dosismaximums (dmax)
  /// Abhängig von Strahlenergie
  static double _calculateDmax(double energy) {
    // Empirische Formel: dmax ≈ 0.5 × Energy (in cm)
    return 0.5 * energy;
  }
  
  /// Output Factor Berechnung
  /// Verhältnis der Dosis bei gegebener Feldgröße zur Referenz-Feldgröße
  /// 
  /// Parameter:
  /// - fieldSize: Aktuelle Feldgröße in cm
  /// - referenceFieldSize: Referenz-Feldgröße (Standard: 10×10 cm)
  static double calculateOutputFactor({
    required double fieldSize,
    double referenceFieldSize = 10.0,
  }) {
    // Vereinfachte Näherung
    // Kleinere Felder: OF < 1.0
    // Größere Felder: OF > 1.0
    
    if (fieldSize == referenceFieldSize) return 1.0;
    
    // Empirische Formel (vereinfacht)
    final ratio = fieldSize / referenceFieldSize;
    return 0.85 + (0.15 * ratio);
  }
  
  /// Tissue-Phantom Ratio (TPR) Berechnung
  /// TPR(d,r) = Dose(d,r) / Dose(d_ref,r)
  /// 
  /// Parameter:
  /// - depth: Tiefe in cm
  /// - fieldSize: Feldgröße in cm
  /// - energy: Strahlenergie in MV
  static double calculateTPR({
    required double depth,
    required double fieldSize,
    required double energy,
  }) {
    // TPR ist ähnlich zu PDD, aber unabhängig von SSD
    final referenceDepth = 10.0; // Standard: 10 cm
    
    final pddAtDepth = _estimatePDD(depth, fieldSize, energy);
    final pddAtReference = _estimatePDD(referenceDepth, fieldSize, energy);
    
    return pddAtDepth / pddAtReference;
  }
  
  /// Scatter Correction Factor (SCP)
  /// Berücksichtigt Streuung im Patienten
  /// 
  /// Parameter:
  /// - fieldSize: Feldgröße in cm²
  static double calculateSCP(double fieldSize) {
    // Vereinfachte Formel
    // Größere Felder = mehr Streuung = höherer SCP
    return 0.95 + (fieldSize / 400.0) * 0.05;
  }
  
  /// Beam Quality Index (TPR₂₀,₁₀)
  /// Maß für Strahlqualität bei Photonenstrahlung
  /// 
  /// Parameter:
  /// - energy: Nominale Strahlenergie in MV
  static double calculateTPR2010(double energy) {
    // Empirische Korrelation zwischen Energy und TPR₂₀,₁₀
    // Für 6 MV: ~0.670
    // Für 10 MV: ~0.737
    // Für 15 MV: ~0.769
    
    return 0.600 + (energy * 0.012);
  }
  
  /// Effektive Tiefe (Effective Depth)
  /// Bei schräger Inzidenz
  /// 
  /// Parameter:
  /// - depth: Geometrische Tiefe in cm
  /// - angle: Einfallswinkel in Grad
  static double calculateEffectiveDepth({
    required double depth,
    required double angle,
  }) {
    final angleRad = angle * pi / 180.0;
    return depth / cos(angleRad);
  }
  
  /// Gamma-Index Berechnung (für QA)
  /// Vergleicht gemessene mit berechneter Dosis
  /// 
  /// Parameter:
  /// - measuredDose: Gemessene Dosis
  /// - calculatedDose: Berechnete Dosis
  /// - doseThreshold: Dosis-Differenz-Kriterium in %
  /// - distanceThreshold: Distanz-Kriterium in mm
  static double calculateGammaIndex({
    required double measuredDose,
    required double calculatedDose,
    double doseThreshold = 3.0, // Standard: 3%
    double distanceThreshold = 3.0, // Standard: 3 mm
  }) {
    // Vereinfachte 1D Gamma-Index-Berechnung
    final doseDiff = ((measuredDose - calculatedDose) / calculatedDose).abs() * 100.0;
    final gamma = doseDiff / doseThreshold;
    
    return gamma;
  }
  
  /// Biologisch Effektive Dosis (BED)
  /// Formel: BED = nd × (1 + d/(α/β))
  /// 
  /// Parameter:
  /// - totalDose: Gesamtdosis in Gy
  /// - fractions: Anzahl Fraktionen
  /// - alphaOverBeta: α/β-Verhältnis (Gewebetyp-spezifisch)
  static double calculateBED({
    required double totalDose,
    required int fractions,
    required double alphaOverBeta,
  }) {
    final dosePerFraction = totalDose / fractions;
    final bed = totalDose * (1 + dosePerFraction / alphaOverBeta);
    return bed;
  }
  
  /// Equivalent Dose in 2 Gy Fractions (EQD2)
  /// Normalisierung auf 2 Gy Fraktionen
  /// 
  /// Parameter:
  /// - totalDose: Gesamtdosis in Gy
  /// - fractions: Anzahl Fraktionen
  /// - alphaOverBeta: α/β-Verhältnis
  static double calculateEQD2({
    required double totalDose,
    required int fractions,
    required double alphaOverBeta,
  }) {
    final dosePerFraction = totalDose / fractions;
    final eqd2 = totalDose * 
        ((dosePerFraction + alphaOverBeta) / (2.0 + alphaOverBeta));
    return eqd2;
  }
  
  /// Mayneord F-Factor
  /// SSD-Korrektur bei verändertem Fokus-Haut-Abstand
  /// 
  /// Parameter:
  /// - ssd1: Ursprünglicher SSD in cm
  /// - ssd2: Neuer SSD in cm
  /// - depth: Tiefe in cm
  static double calculateMayneordFFactor({
    required double ssd1,
    required double ssd2,
    required double depth,
  }) {
    final sad = 100.0; // Standard Source-Axis Distance
    
    final factor = pow((ssd2 + sad) / (ssd1 + sad), 2) *
                   pow((ssd1 + depth) / (ssd2 + depth), 2);
    
    return factor.toDouble();
  }
}
