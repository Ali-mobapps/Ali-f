class VitalSignsModel {
  final String? bloodPressure; // e.g. "120/80 mmHg"
  final String? heartRate;     // e.g. "72 bpm"
  final String? temperature;   // e.g. "98.6 °F"
  final String? weight;        // e.g. "70 kg"
  final String? bloodSugar;    // e.g. "95 mg/dL"
  final String? spo2;          // e.g. "98%"

  VitalSignsModel({
    this.bloodPressure,
    this.heartRate,
    this.temperature,
    this.weight,
    this.bloodSugar,
    this.spo2,
  });

  Map<String, dynamic> toMap() {
    return {
      'blood_pressure': bloodPressure,
      'heart_rate': heartRate,
      'temperature': temperature,
      'weight': weight,
      'blood_sugar': bloodSugar,
      'spo2': spo2,
    };
  }

  factory VitalSignsModel.fromMap(Map<String, dynamic> map) {
    return VitalSignsModel(
      bloodPressure: map['blood_pressure'],
      heartRate: map['heart_rate'],
      temperature: map['temperature'],
      weight: map['weight'],
      bloodSugar: map['blood_sugar'],
      spo2: map['spo2'],
    );
  }
}
