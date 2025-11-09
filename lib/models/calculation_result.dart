// Datenmodell für Berechnungsergebnisse

class CalculationResult {
  final String type;
  final Map<String, String> input;
  final double result;
  final String unit;
  final DateTime timestamp;
  final String? formula;
  final String? reference;
  
  CalculationResult({
    required this.type,
    required this.input,
    required this.result,
    required this.unit,
    required this.timestamp,
    this.formula,
    this.reference,
  });
  
  String get formattedResult {
    return '${result.toStringAsFixed(3)} $unit';
  }
  
  String get formattedTimestamp {
    return '${timestamp.day}.${timestamp.month}.${timestamp.year} '
           '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'input': input,
      'result': result,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'formula': formula,
      'reference': reference,
    };
  }
  
  factory CalculationResult.fromJson(Map<String, dynamic> json) {
    return CalculationResult(
      type: json['type'] as String,
      input: Map<String, String>.from(json['input'] as Map),
      result: json['result'] as double,
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      formula: json['formula'] as String?,
      reference: json['reference'] as String?,
    );
  }
}
