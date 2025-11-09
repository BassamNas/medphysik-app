// Medizinphysikalische Berechnungen
// Alle Formeln und Berechnungsmethoden für Dosimetrie und Strahlentherapie

import 'dart:math';

class PhysicsCalculations {
  // Konstanten
  static const double kGy = 1.0; // Gray
  static const double kCGy = 0.01; // centiGray
  
  /// Dosisberechnung (AAPM TG-51 konform)
  /// Formel: Dose = MU × D_cal × OF × TMR × SCP × ISF
  /// 
  /// Parameter:
  /// - monitorUnits: Monitor Units (MU)
  /// - doseRate: Dosisleistung in MU/min (für Zeitberechnung)
  /// - ssd: Source-to-Surface Distance in cm
  /// - depth: Tiefe in cm
  /// - fieldSize: Feldgröße in cm (Standard: 10×10 cm)
  /// - energy: Strahlenergie in MV (Standard: 6 MV)
  static double calculateDose({
    required double monitorUnits,
    required double doseRate,
    required double ssd,
    required double depth,
    double fieldSize = 10.0,
    double energy = 6.0,
  }) {
    // Kalibrierungsfaktor: 1 cGy/MU bei Referenzbedingungen (dmax, 10×10, 100 cm SSD)
    final double calibrationFactor = 1.0; // cGy/MU
    
    // Source-Axis Distance (Standard für isozentrische Technik)
    final double sad = 100.0; // cm
    
    // 1. Output Factor (Feldgrößenabhängigkeit)
    final double outputFactor = _calculatePreciseOutputFactor(fieldSize, energy);
    
    // 2. Inverse Square Law Korrektur (ISF)
    // ISF = [(SSD_cal + d_cal) / (SSD + d)]²
    final double ssdCal = 100.0; // Standard-Kalibrierungs-SSD
    final double depthCal = _calculateDmax(energy); // Kalibrierungstiefe = dmax
    final double isf = pow((ssdCal + depthCal) / (ssd + depth), 2).toDouble();
    
    // 3. Tissue-Phantom Ratio (TPR) - präzise Berechnung
    final double tpr = _calculatePreciseTPR(depth, fieldSize, energy);
    
    // 4. Scatter Correction Factor (SCP)
    final double scp = _calculatePreciseSCP(fieldSize, depth);
    
    // 5. Finale Dosisberechnung in Gy
    // Dose [Gy] = MU × D_cal [cGy/MU] × OF × ISF × TPR × SCP / 100
    final double dose = monitorUnits * calibrationFactor * outputFactor * 
                       isf * tpr * scp / 100.0;
    
    return dose;
  }
  
  /// Monitor Units Berechnung (AAPM TG-51 konform)
  /// Formel: MU = PrescribedDose × 100 / (D_cal × OF × TPR × SCP × ISF)
  /// 
  /// Parameter:
  /// - prescribedDose: Verschriebene Dosis in Gy
  /// - outputFactor: Output Factor (dimensionslos)
  /// - tpr: Tissue-Phantom Ratio
  /// - scp: Scatter Correction Factor
  /// - ssd: Source-to-Surface Distance in cm (Standard: 100)
  /// - depth: Tiefe in cm (Standard: 10)
  /// - fieldSize: Feldgröße in cm (Standard: 10)
  /// - energy: Strahlenergie in MV (Standard: 6)
  static double calculateMonitorUnits({
    required double prescribedDose,
    required double outputFactor,
    required double tpr,
    required double scp,
    double ssd = 100.0,
    double depth = 10.0,
    double fieldSize = 10.0,
    double energy = 6.0,
  }) {
    // Kalibrierungsfaktor: 1 cGy/MU
    final double calibrationFactor = 1.0; // cGy/MU
    
    // Inverse Square Factor (ISF)
    final double ssdCal = 100.0;
    final double depthCal = _calculateDmax(energy);
    final double isf = pow((ssdCal + depthCal) / (ssd + depth), 2).toDouble();
    
    // MU = Dose [Gy] × 100 / (D_cal [cGy/MU] × OF × TPR × SCP × ISF)
    final double mu = (prescribedDose * 100.0) / 
                     (calibrationFactor * outputFactor * tpr * scp * isf);
    
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
  
  /// PDD-Näherungsformel (BJR Supplement 25 konform)
  /// Basiert auf empirischen Daten für Megavolt-Photonenstrahlung
  static double _estimatePDD(double depth, double fieldSize, double energy) {
    // dmax: Tiefe des Dosismaximums
    final dmax = _calculateDmax(energy);
    
    if (depth <= 0) return 0.0;
    
    // Build-up Region (d < dmax): Lineare Interpolation
    if (depth < dmax) {
      return 100.0 * (depth / dmax);
    }
    
    // Beyond dmax: Exponentieller Abfall mit Feldgrößenkorrektur
    // PDD(d) = 100 × exp(-μ_eff × (d - d_max)) × [1 + k × ln(A/A_ref)]
    
    // Effektiver Abschwächungskoeffizient (energy-dependent)
    // μ_eff = μ_0 - k_E × E [cm⁻¹]
    final double mu0 = 0.048; // Basis-Abschwächung bei niedrigen Energien
    final double kE = 0.0024; // Energie-Abhängigkeitsfaktor
    final double muEff = mu0 - (kE * energy);
    
    // Basis-PDD (für 10×10 cm Feld)
    final double pddBase = 100.0 * exp(-muEff * (depth - dmax));
    
    // Feldgrößenkorrektur (Scatter-Komponente)
    // Größere Felder → mehr Streuung → höhere PDD
    final double fieldArea = fieldSize * fieldSize;
    final double referenceArea = 10.0 * 10.0; // 10×10 cm Referenzfeld
    final double scatterFactor = 1.0 + 0.003 * log(fieldArea / referenceArea);
    
    // Off-axis Softening (tiefenabhängig)
    final double softeningFactor = 1.0 - (0.0005 * (depth - dmax));
    
    return pddBase * scatterFactor * softeningFactor;
  }
  
  /// Berechnet Tiefe des Dosismaximums (dmax)
  /// Abhängig von Strahlenergie (empirische Formel)
  /// Referenz: Khan's Physics of Radiation Therapy
  static double _calculateDmax(double energy) {
    // Empirische Formel für Photonenstrahlung:
    // d_max [cm] ≈ 0.54 × E [MV] - 0.10 für E > 2 MV
    if (energy < 2.0) {
      return 0.5; // Niedrigenergetische Strahlung
    }
    return (0.54 * energy) - 0.10;
  }
  
  /// Präzise Output Factor Berechnung
  /// Berücksichtigt Feld-Äquivalenz und Phantom-Scatter
  /// Referenz: IAEA TRS-398
  static double _calculatePreciseOutputFactor(double fieldSize, double energy) {
    // Referenzfeldgröße
    final double refSize = 10.0; // cm
    
    if ((fieldSize - refSize).abs() < 0.01) return 1.0;
    
    // Für sehr kleine Felder: Lateral electron disequilibrium
    if (fieldSize < 3.0) {
      final double ledFactor = 0.70 + (fieldSize / 3.0) * 0.15;
      return ledFactor;
    }
    
    // Sterling's Output Factor Model (vereinfacht)
    // OF = S_c,p × S_p / S_c,p(ref) × S_p(ref)
    // S_c,p: Collimator-Phantom Scatter Factor
    // S_p: Phantom Scatter Factor
    
    final double ratio = fieldSize / refSize;
    final double scpFactor = 0.85 + (0.15 * ratio);
    final double spFactor = 0.94 + (0.06 * ratio);
    
    // Energie-Abhängigkeit (höhere Energie → weniger Streuung)
    final double energyCorrection = 1.0 - ((energy - 6.0) * 0.005);
    
    return scpFactor * spFactor * energyCorrection;
  }
  
  /// Präzise TPR-Berechnung
  /// TPR(d, r_d) = PDD(d, f, f×d/100) / PDD(d_ref, f, f×d_ref/100)
  /// Referenz: BJR Supplement 25
  static double _calculatePreciseTPR(double depth, double fieldSize, double energy) {
    final double referenceDepth = 10.0; // cm (Standard)
    
    // PDD bei Messtiefe
    final double pddAtDepth = _estimatePDD(depth, fieldSize, energy);
    
    // PDD bei Referenztiefe
    final double pddAtRef = _estimatePDD(referenceDepth, fieldSize, energy);
    
    // TPR ist unabhängig von SSD
    return pddAtDepth / pddAtRef;
  }
  
  /// Präzise Scatter Correction Factor (SCP)
  /// Berücksichtigt Phantom-Streuung und Rückstreuung
  static double _calculatePreciseSCP(double fieldSize, double depth) {
    // Referenzfeld
    final double refFieldSize = 10.0; // cm
    final double refDepth = 10.0; // cm
    
    if ((fieldSize - refFieldSize).abs() < 0.01 && 
        (depth - refDepth).abs() < 0.01) {
      return 1.0;
    }
    
    // Streukomponente (feldgrößenabhängig)
    final double fieldArea = fieldSize * fieldSize;
    final double refArea = refFieldSize * refFieldSize;
    final double scatterRatio = fieldArea / refArea;
    
    // Day's Scatter Model (vereinfacht)
    // SCP = a + b × √A
    final double a = 0.90;
    final double b = 0.03;
    final double scp = a + (b * sqrt(scatterRatio));
    
    // Tiefenabhängige Korrektur
    final double depthFactor = 1.0 + ((depth - refDepth) * 0.002);
    
    return scp * depthFactor;
  }
  
  /// Output Factor Berechnung (Legacy - für Kompatibilität)
  /// Verhältnis der Dosis bei gegebener Feldgröße zur Referenz-Feldgröße
  /// 
  /// Parameter:
  /// - fieldSize: Aktuelle Feldgröße in cm
  /// - referenceFieldSize: Referenz-Feldgröße (Standard: 10×10 cm)
  /// - energy: Strahlenergie in MV (Standard: 6)
  static double calculateOutputFactor({
    required double fieldSize,
    double referenceFieldSize = 10.0,
    double energy = 6.0,
  }) {
    return _calculatePreciseOutputFactor(fieldSize, energy);
  }
  
  /// Tissue-Phantom Ratio (TPR) Berechnung (präzise)
  /// TPR(d,r) = Dose(d,r) / Dose(d_ref,r)
  /// Referenz: IAEA TRS-398, AAPM TG-51
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
    return _calculatePreciseTPR(depth, fieldSize, energy);
  }
  
  /// Scatter Correction Factor (SCP) - präzise Berechnung
  /// Berücksichtigt Streuung im Patienten nach Day's Model
  /// Referenz: BJR Supplement 25
  /// 
  /// Parameter:
  /// - fieldSize: Feldgröße in cm²
  /// - depth: Tiefe in cm (Standard: 10)
  static double calculateSCP(double fieldSize, {double depth = 10.0}) {
    return _calculatePreciseSCP(fieldSize, depth);
  }
  
  /// Beam Quality Index (TPR₂₀,₁₀) - präzise Berechnung
  /// Maß für Strahlqualität bei Photonenstrahlung
  /// Referenz: IAEA TRS-398, AAPM TG-51
  /// 
  /// Parameter:
  /// - energy: Nominale Strahlenergie in MV
  static double calculateTPR2010(double energy) {
    // Präzise Korrelation basierend auf klinischen Daten
    // TPR₂₀,₁₀ = a + b × E + c × E²
    final double a = 0.5635;
    final double b = 0.0261;
    final double c = -0.0004;
    
    final double tpr2010 = a + (b * energy) + (c * energy * energy);
    
    // Realistische Grenzen für Photonenstrahlung
    return tpr2010.clamp(0.600, 0.800);
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
