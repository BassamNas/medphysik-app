// Inverse Square Law Calculator Screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result_display.dart';

class InverseSquareScreen extends StatefulWidget {
  const InverseSquareScreen({super.key});

  @override
  State<InverseSquareScreen> createState() => _InverseSquareScreenState();
}

class _InverseSquareScreenState extends State<InverseSquareScreen> {
  final _formKey = GlobalKey<FormState>();
  final _initialDoseController = TextEditingController(text: '1.0');
  final _initialDistanceController = TextEditingController(text: '100');
  final _newDistanceController = TextEditingController(text: '80');
  
  @override
  void dispose() {
    _initialDoseController.dispose();
    _initialDistanceController.dispose();
    _newDistanceController.dispose();
    super.dispose();
  }
  
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CalculationProvider>();
      
      provider.calculateInverseSquare(
        initialDose: double.parse(_initialDoseController.text),
        initialDistance: double.parse(_initialDistanceController.text),
        newDistance: double.parse(_newDistanceController.text),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berechnung erfolgreich')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abstandsquadratgesetz'),
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
                          'Berechnet Dosisänderung bei verändertem Abstand',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _initialDoseController,
                decoration: const InputDecoration(
                  labelText: 'Anfangsdosis',
                  hintText: 'z.B. 1.0',
                  suffixText: 'Gy',
                  prefixIcon: Icon(Icons.straighten),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte Wert eingeben';
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) return 'Wert muss > 0 sein';
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _initialDistanceController,
                decoration: const InputDecoration(
                  labelText: 'Anfangsabstand',
                  hintText: 'z.B. 100',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.arrow_downward),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte Wert eingeben';
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) return 'Wert muss > 0 sein';
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _newDistanceController,
                decoration: const InputDecoration(
                  labelText: 'Neuer Abstand',
                  hintText: 'z.B. 80',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.adjust),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte Wert eingeben';
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) return 'Wert muss > 0 sein';
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Berechnen'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Consumer<CalculationProvider>(
                builder: (context, provider, child) {
                  if (provider.currentResult != null &&
                      provider.currentResult!.type == 'Abstandsquadratgesetz') {
                    return ResultDisplay(result: provider.currentResult!);
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Formel & Erklärung'),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Abstandsquadratgesetz (Inverse Square Law):',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('I₂ = I₁ × (d₁ / d₂)²'),
                          SizedBox(height: 16),
                          Text('Wobei:'),
                          Text('• I₁ = Anfangsdosis'),
                          Text('• I₂ = Neue Dosis'),
                          Text('• d₁ = Anfangsabstand'),
                          Text('• d₂ = Neuer Abstand'),
                          SizedBox(height: 16),
                          Text(
                            'Prinzip: Die Dosisleistung nimmt mit dem Quadrat '
                            'des Abstands ab. Bei doppeltem Abstand ist die Dosis '
                            '¼ der ursprünglichen Dosis.',
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
