// PDD (Percentage Depth Dose) Calculator Screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result_display.dart';

class PDDCalculatorScreen extends StatefulWidget {
  const PDDCalculatorScreen({super.key});

  @override
  State<PDDCalculatorScreen> createState() => _PDDCalculatorScreenState();
}

class _PDDCalculatorScreenState extends State<PDDCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _depthController = TextEditingController(text: '10');
  final _fieldSizeController = TextEditingController(text: '10');
  double _selectedEnergy = 6.0;
  
  final List<double> _energies = [6.0, 10.0, 15.0, 18.0];
  
  @override
  void dispose() {
    _depthController.dispose();
    _fieldSizeController.dispose();
    super.dispose();
  }
  
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CalculationProvider>();
      
      provider.calculatePDD(
        depth: double.parse(_depthController.text),
        fieldSize: double.parse(_fieldSizeController.text),
        energy: _selectedEnergy,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDD berechnet')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDD-Rechner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Berechnet Percentage Depth Dose (PDD)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _depthController,
                decoration: const InputDecoration(
                  labelText: 'Tiefe',
                  hintText: 'z.B. 10',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.vertical_align_bottom),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte Wert eingeben';
                  final number = double.tryParse(value);
                  if (number == null || number < 0) return 'Wert muss >= 0 sein';
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _fieldSizeController,
                decoration: const InputDecoration(
                  labelText: 'Feldgröße (quadratisch)',
                  hintText: 'z.B. 10',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.crop_square),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte Wert eingeben';
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) return 'Wert muss > 0 sein';
                  if (number > 40) return 'Feldgröße max. 40 cm';
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt),
                          const SizedBox(width: 12),
                          Text(
                            'Strahlenergie',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _energies.map((energy) {
                          return ChoiceChip(
                            label: Text('$energy MV'),
                            selected: _selectedEnergy == energy,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedEnergy = energy);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('PDD Berechnen'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Consumer<CalculationProvider>(
                builder: (context, provider, child) {
                  if (provider.currentResult != null &&
                      provider.currentResult!.type == 'PDD (Percentage Depth Dose)') {
                    return ResultDisplay(result: provider.currentResult!);
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Was ist PDD?'),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Percentage Depth Dose (PDD):',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'PDD beschreibt die Dosisverteilung als Funktion der Tiefe. '
                            'Sie gibt den Prozentsatz der maximalen Dosis an einer bestimmten Tiefe an.',
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Abhängig von:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('• Strahlenergie (höhere Energie = tiefere Penetration)'),
                          Text('• Feldgröße (größeres Feld = mehr Streuung)'),
                          Text('• Source-Surface Distance (SSD)'),
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
