# Medizinphysik Berechnungs-App - Flutter Project

## Project Status
- [x] Project Requirements Clarified
- [x] Project Structure Created
- [x] Flutter Project Structure (manual creation)
- [x] Dependencies Configured (pubspec.yaml)
- [x] Core Calculation Modules Implemented
- [x] UI Components Created (5 screens + widgets)
- [x] Unit Tests Written (comprehensive physics tests)
- [x] Documentation Complete (README.md)

## Project Overview
Flutter app for medical physics calculations targeting radiation therapy and linear accelerator operations.

## Features
- Dose calculations (MU, dose rate, depth dose)
- Beam energy conversions
- Quality assurance tools (TG-142, DIN 6847-5)
- Radiation protection formulas
- LINAC parameter calculations
- PDD and TMR tables

## Technical Stack
- Framework: Flutter 3.x
- Language: Dart
- Target Platforms: Android, iOS, Web, Windows, macOS, Linux
- State Management: Provider
- Math Library: dart:math

## Development Guidelines
- Follow Material Design 3 principles
- Implement responsive layouts for all screen sizes
- Use German language for UI (primary target: German medical physicists)
- Include unit tests for all calculation functions
- Document all physics formulas with references (IEC, AAPM, DIN standards)

## Calculation Modules
1. Dose Calculations
2. Monitor Unit Calculations
3. Beam Quality (TPR20,10)
4. Scatter Factors
5. Output Factors
6. Inverse Square Law
7. Tissue-Air Ratio (TAR)
8. Percentage Depth Dose (PDD)

## Safety Notes
- Display disclaimers: "For educational and verification purposes only"
- Not certified for clinical use
- Reference to validated clinical systems required
