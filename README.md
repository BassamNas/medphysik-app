# Medizinphysik Berechnungs-App

Eine professionelle Flutter-Anwendung für medizinphysikalische Berechnungen in der Strahlentherapie.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-Educational-green.svg)

## 📱 Features

### Berechnungsmodule

1. **Dosisberechnung**
   - Applizierte Dosis basierend auf Monitor Units
   - Berücksichtigt Dosisleistung, SSD und Tiefe
   - Inverse Square Law und PDD-Korrektur

2. **Monitor Units (MU) Berechnung**
   - Berechnet benötigte MU für verschriebene Dosis
   - Output Factor, TPR und SCP-Korrektur
   - Validierung nach klinischen Standards

3. **PDD-Rechner (Percentage Depth Dose)**
   - Tiefendosisverteilung
   - Verschiedene Strahlenenergien (6, 10, 15, 18 MV)
   - Feldgrößenabhängigkeit

4. **Abstandsquadratgesetz (Inverse Square Law)**
   - Dosisänderung bei verändertem Abstand
   - Wichtig für SSD-Variationen
   - Qualitätssicherung

5. **Berechnungs-Historie**
   - Alle Berechnungen werden gespeichert
   - Nachvollziehbarkeit
   - Export-Funktion (geplant)

## 🛠️ Installation

### Voraussetzungen

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (≥ 3.0.0)
- [Dart SDK](https://dart.dev/get-dart) (≥ 3.0.0)
- Android Studio / VS Code mit Flutter Extension
- Git

### Schritt-für-Schritt Installation

```bash
# 1. Repository klonen
git clone https://github.com/yourusername/medphysik_app.git
cd medphysik_app

# 2. Dependencies installieren
flutter pub get

# 3. App starten (Desktop)
flutter run -d windows
# oder
flutter run -d linux
# oder
flutter run -d macos

# 4. App starten (Mobile)
flutter run -d android
# oder
flutter run -d ios
```

## 📖 Verwendung

### Dosisberechnung

```dart
1. Öffne "Dosisberechnung"
2. Eingabe:
   - Monitor Units (z.B. 200 MU)
   - Dosisleistung (z.B. 400 MU/min)
   - SSD (z.B. 100 cm)
   - Tiefe (z.B. 10 cm)
3. Klick "Berechnen"
4. Ergebnis wird angezeigt
```

### Monitor Units

```dart
1. Öffne "Monitor Units (MU)"
2. Eingabe:
   - Verschriebene Dosis (z.B. 2.0 Gy)
   - Output Factor (z.B. 1.0)
   - TPR (z.B. 0.67)
   - SCP (z.B. 0.98)
3. Klick "MU Berechnen"
```

## 🔬 Physikalische Grundlagen

### Formeln

#### Dosisberechnung
```
Dose = MU × CF × ISF × PDD
```
- MU: Monitor Units
- CF: Calibration Factor (1 cGy/MU)
- ISF: Inverse Square Factor
- PDD: Percentage Depth Dose

#### Monitor Units
```
MU = PrescribedDose / (OF × TPR × SCP)
```
- OF: Output Factor
- TPR: Tissue-Phantom Ratio
- SCP: Scatter Correction Factor

#### Inverse Square Law
```
I₂ = I₁ × (d₁/d₂)²
```

#### PDD (Vereinfachte Näherung)
```
PDD(d) = 100 × exp(-μ × (d - dmax))
```

## 📚 Standards & Referenzen

Diese App basiert auf folgenden internationalen Standards:

- **IEC 60601-2-1**: Medizinische elektrische Geräte - Elektronenbeschleuniger
- **AAPM TG-51**: Protocol for clinical reference dosimetry
- **DIN 6800-2**: Dosismessverfahren nach der Sondenmethode
- **IAEA TRS-398**: Absorbed Dose Determination in External Beam Radiotherapy

### Literatur

1. Khan, F.M. (2014): *The Physics of Radiation Therapy*, 5th Edition
2. Podgorsak, E.B. (2005): *Radiation Oncology Physics: A Handbook for Teachers and Students*
3. AAPM Task Group 142 (2009): *Quality assurance of medical accelerators*

## ⚠️ Wichtiger Hinweis

```
╔═══════════════════════════════════════════════════════╗
║  DIESE APP IST NUR FÜR BILDUNGSZWECKE BESTIMMT!      ║
║                                                       ║
║  - NICHT für klinischen Einsatz zertifiziert         ║
║  - NICHT als alleinige Berechnungsgrundlage          ║
║  - NUR zur Verifikation und Ausbildung               ║
║  - Ergebnisse müssen IMMER mit zertifizierten        ║
║    Treatment Planning Systemen verglichen werden     ║
║                                                       ║
║  Klinischer Einsatz erfordert:                       ║
║  - Medizinprodukte-Zulassung                         ║
║  - Umfassende Validierung                            ║
║  - Qualitätssicherung nach DIN/IEC                   ║
╚═══════════════════════════════════════════════════════╝
```

## 🏗️ Projektstruktur

```
medphysik_app/
├── lib/
│   ├── main.dart                    # App-Einstiegspunkt
│   ├── models/
│   │   └── calculation_result.dart  # Datenmodell für Ergebnisse
│   ├── providers/
│   │   └── calculation_provider.dart # State Management
│   ├── screens/
│   │   ├── home_screen.dart         # Hauptbildschirm
│   │   ├── dose_calculation_screen.dart
│   │   ├── monitor_units_screen.dart
│   │   ├── pdd_calculator_screen.dart
│   │   ├── inverse_square_screen.dart
│   │   └── history_screen.dart
│   ├── utils/
│   │   └── physics_calculations.dart # Alle Berechnungsformeln
│   └── widgets/
│       └── result_display.dart      # Ergebnis-Widget
├── pubspec.yaml                     # Dependencies
└── README.md                        # Diese Datei
```

## 🎨 Screenshots

### Hauptbildschirm
```
┌─────────────────────────────────────┐
│  Medizinphysik Rechner              │
├─────────────────────────────────────┤
│  📊 Willkommen                       │
│  Professionelle Berechnungswerkzeuge│
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📏 Dosisberechnung          │   │
│  │ Berechnung der applizierten │   │
│  │ Dosis                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚖️  Monitor Units (MU)      │   │
│  │ MU-Berechnung für Plan      │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

## 🧪 Testing

```bash
# Unit Tests ausführen
flutter test

# Alle Tests mit Coverage
flutter test --coverage

# Widget Tests
flutter test test/widget_test.dart

# Integration Tests
flutter drive --target=test_driver/app.dart
```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

### Windows Desktop
```bash
flutter build windows --release
```

### Web
```bash
flutter build web --release
```

## 🔧 Entwicklung

### Code-Stil

Das Projekt folgt den offiziellen [Dart Style Guidelines](https://dart.dev/guides/language/effective-dart/style).

```bash
# Code formatieren
flutter format .

# Lint-Checks
flutter analyze
```

### Dependencies

- `flutter`: SDK
- `provider`: State Management (^6.1.1)
- `math_expressions`: Mathematische Ausdrücke (^2.4.0)
- `intl`: Internationalisierung (^0.18.1)

## 🤝 Beitragen

Contributions sind willkommen! Bitte beachte:

1. Fork das Repository
2. Erstelle einen Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## 📄 Lizenz

Dieses Projekt ist nur für **Bildungszwecke** bestimmt. Keine Verwendung für klinische Zwecke ohne entsprechende Zertifizierung.

## 👨‍💻 Autor

**Bassam Al-Dubai**
- Medizinphysiker (M.Sc.)
- Email: bassam.aldubai@email.de
- Standort: Berlin, Deutschland

## 🙏 Danksagungen

- Flutter Team für das großartige Framework
- Medizinphysik-Community für fachliche Unterstützung
- AAPM und IEC für Standards und Guidelines

---

**Erstellt mit ❤️ für die Medizinphysik-Community**

*Version 1.0.0 | Letzte Aktualisierung: November 2024*
