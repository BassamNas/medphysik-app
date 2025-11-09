// Dosisberechnungs-Screen
// Berechnet die applizierte Dosis basierend auf MU, Dosisleistung, SSD und Tiefe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result_display.dart';

class DoseCalculationScreen extends StatefulWidget {
  const DoseCalculationScreen({super.key});

  @override
  State<DoseCalculationScreen> createState() => _DoseCalculationScreenState();
}

class _DoseCalculationScreenState extends State<DoseCalculationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _muController = TextEditingController(text: '200');
  final _doseRateController = TextEditingController(text: '400');
  final _ssdController = TextEditingController(text: '100');
  final _depthController = TextEditingController(text: '10');
  
  @override
  void dispose() {
    _muController.dispose();
    _doseRateController.dispose();
    _ssdController.dispose();
    _depthController.dispose();
    super.dispose();
  }
  
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CalculationProvider>();
      
      provider.calculateDose(
        monitorUnits: double.parse(_muController.text),
        doseRate: double.parse(_doseRateController.text),
        ssd: double.parse(_ssdController.text),
        depth: double.parse(_depthController.text),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berechnung erfolgreich'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosisberechnung'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Berechnet die applizierte Dosis im Patienten',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Eingabefelder
              TextFormField(
                controller: _muController,
                decoration: const InputDecoration(
                  labelText: 'Monitor Units (MU)',
                  hintText: 'z.B. 200',
                  suffixText: 'MU',
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Wert eingeben';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Wert muss größer als 0 sein';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _doseRateController,
                decoration: const InputDecoration(
                  labelText: 'Dosisleistung',
                  hintText: 'z.B. 400',
                  suffixText: 'MU/min',
                  prefixIcon: Icon(Icons.trending_up),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Wert eingeben';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Wert muss größer als 0 sein';
                  }
                  if (number > 1400) {
                    return 'Dosisleistung zu hoch (max. 1400 MU/min)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _ssdController,
                decoration: const InputDecoration(
                  labelText: 'SSD (Source-Surface Distance)',
                  hintText: 'z.B. 100',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.straighten),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Wert eingeben';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Wert muss größer als 0 sein';
                  }
                  if (number < 70 || number > 120) {
                    return 'SSD typischerweise zwischen 70-120 cm';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _depthController,
                decoration: const InputDecoration(
                  labelText: 'Tiefe im Patienten',
                  hintText: 'z.B. 10',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.layers),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Wert eingeben';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number < 0) {
                    return 'Wert muss >= 0 sein';
                  }
                  if (number > 30) {
                    return 'Tiefe typischerweise < 30 cm';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Berechnen Button
              FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Berechnen'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Ergebnis-Anzeige
              Consumer<CalculationProvider>(
                builder: (context, provider, child) {
                  if (provider.currentResult != null &&
                      provider.currentResult!.type == 'Dosisberechnung') {
                    return ResultDisplay(result: provider.currentResult!);
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 16),
              
              // Formel-Erklärung
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Formel & Erklärung'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dosisberechnung (vereinfacht):',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('Dose = MU × CF × ISF × PDD'),
                          const SizedBox(height: 16),
                          const Text('Wobei:'),
                          const Text('• MU = Monitor Units'),
                          const Text('• CF = Calibration Factor (1 cGy/MU)'),
                          const Text('• ISF = Inverse Square Factor'),
                          const Text('• PDD = Percentage Depth Dose'),
                          const SizedBox(height: 16),
                          Text(
                            'Hinweis: Dies ist eine vereinfachte Berechnung. '
                            'Klinische Systeme verwenden komplexere Algorithmen.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
