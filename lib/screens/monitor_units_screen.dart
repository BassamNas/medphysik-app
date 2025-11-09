// Monitor Units Berechnungs-Screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result_display.dart';

class MonitorUnitsScreen extends StatefulWidget {
  const MonitorUnitsScreen({super.key});

  @override
  State<MonitorUnitsScreen> createState() => _MonitorUnitsScreenState();
}

class _MonitorUnitsScreenState extends State<MonitorUnitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doseController = TextEditingController(text: '2.0');
  final _outputFactorController = TextEditingController(text: '1.0');
  final _tprController = TextEditingController(text: '0.67');
  final _scpController = TextEditingController(text: '0.98');
  
  @override
  void dispose() {
    _doseController.dispose();
    _outputFactorController.dispose();
    _tprController.dispose();
    _scpController.dispose();
    super.dispose();
  }
  
  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CalculationProvider>();
      
      provider.calculateMonitorUnits(
        prescribedDose: double.parse(_doseController.text),
        outputFactor: double.parse(_outputFactorController.text),
        tpr: double.parse(_tprController.text),
        scp: double.parse(_scpController.text),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MU berechnet')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Units (MU)'),
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
                          'Berechnet benötigte Monitor Units für verschriebene Dosis',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: 'Verschriebene Dosis',
                  hintText: 'z.B. 2.0',
                  suffixText: 'Gy',
                  prefixIcon: Icon(Icons.medical_services),
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
                controller: _outputFactorController,
                decoration: const InputDecoration(
                  labelText: 'Output Factor',
                  hintText: 'z.B. 1.0',
                  prefixIcon: Icon(Icons.tune),
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
                controller: _tprController,
                decoration: const InputDecoration(
                  labelText: 'TPR (Tissue-Phantom Ratio)',
                  hintText: 'z.B. 0.67',
                  prefixIcon: Icon(Icons.layers),
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
                controller: _scpController,
                decoration: const InputDecoration(
                  labelText: 'SCP (Scatter Correction)',
                  hintText: 'z.B. 0.98',
                  prefixIcon: Icon(Icons.scatter_plot),
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
                label: const Text('MU Berechnen'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Consumer<CalculationProvider>(
                builder: (context, provider, child) {
                  if (provider.currentResult != null &&
                      provider.currentResult!.type == 'Monitor Units') {
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
                            'MU-Berechnung:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('MU = Dosis / (OF × TPR × SCP)'),
                          SizedBox(height: 16),
                          Text('Wobei:'),
                          Text('• OF = Output Factor'),
                          Text('• TPR = Tissue-Phantom Ratio'),
                          Text('• SCP = Scatter Correction Factor'),
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
