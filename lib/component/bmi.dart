import 'dart:math';
class BMI {
  int id;
  DateTime date;
  double height;
  double weight;
  double? bmi;

  double calculateBmi() {
    bmi = weight / pow(height/100, 2);
    return bmi!;
  }

  BMI({
    required this.date,
    required this.id,
    required this.height,
    required this.weight,
  });
}