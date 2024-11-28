import 'package:flutter/material.dart';

class ExerciseTypeModel with ChangeNotifier {
  int _exerciseType = 0;

  int get exerciseType => _exerciseType;

  void setExerciseType(int newType) {
    _exerciseType = newType;
    notifyListeners();
  }
}
