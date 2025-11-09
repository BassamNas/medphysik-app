// Hauptbildschirm der App
// Zeigt alle verfügbaren Berechnungsmodule

import 'package:flutter/material.dart';
import '../screens/dose_calculation_screen.dart';
import '../screens/monitor_units_screen.dart';
import '../screens/pdd_calculator_screen.dart';
import '../screens/inverse_square_screen.dart';
import '../screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medizinphysik Rechner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Berechnungs-Historie',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Über die App',
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Willkommens-Card
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calculate,
                            size: 32,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Willkommen',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Professionelle Berechnungswerkzeuge für Medizinphysiker in der Strahlentherapie',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Berechnungsmodule
              Text(
                'Berechnungsmodule',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Dosisberechnung
              _CalculationCard(
                title: 'Dosisberechnung',
                description: 'Berechnung der applizierten Dosis',
                icon: Icons.straighten,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoseCalculationScreen(),
                    ),
                  );
                },
              ),
              
              // Monitor Units
              _CalculationCard(
                title: 'Monitor Units (MU)',
                description: 'MU-Berechnung für Behandlungsplan',
                icon: Icons.monitor_weight,
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonitorUnitsScreen(),
                    ),
                  );
                },
              ),
              
              // PDD
              _CalculationCard(
                title: 'PDD-Rechner',
                description: 'Percentage Depth Dose Berechnung',
                icon: Icons.layers,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PDDCalculatorScreen(),
                    ),
                  );
                },
              ),
              
              // Inverse Square Law
              _CalculationCard(
                title: 'Abstandsquadratgesetz',
                description: 'Inverse Square Law Berechnung',
                icon: Icons.adjust,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InverseSquareScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Sicherheitshinweis
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.amber.shade900),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Nur für Bildungs- und Verifikationszwecke. '
                          'Nicht für klinischen Einsatz zertifiziert.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Über die App'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medizinphysik Rechner',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text('Version 1.0.0'),
              const SizedBox(height: 16),
              const Text(
                'Entwickelt für Medizinphysiker in der Strahlentherapie.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• Dosisberechnungen'),
              const Text('• Monitor Units (MU)'),
              const Text('• PDD-Berechnung'),
              const Text('• Inverse Square Law'),
              const Text('• Berechnungs-Historie'),
              const SizedBox(height: 16),
              const Text(
                '⚠️ Wichtig:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Diese App dient ausschließlich zu Bildungs- und Verifikationszwecken. '
                'Sie ist nicht für den klinischen Einsatz zertifiziert.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                'Standards & Referenzen:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• IEC 60601-2-1', style: TextStyle(fontSize: 12)),
              const Text('• AAPM TG-51', style: TextStyle(fontSize: 12)),
              const Text('• DIN 6800-2', style: TextStyle(fontSize: 12)),
              const Text('• IAEA TRS-398', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}

class _CalculationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  const _CalculationCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
