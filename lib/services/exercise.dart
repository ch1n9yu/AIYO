import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseTimeStorage {
  ExerciseTimeStorage({required this.email});
  final String email;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic> exerciseTimeData = {};

  Future<void> saveExerciseTime(List<int> exerciseTimes) async {
    //save exerciseTimes to storage
    String date = DateTime.now().toString().substring(0, 10);
    await firestore.collection('exerciseTimes').doc(email).set({
      '$date': exerciseTimes,
    });
  }

  Future<void> getData() async {
    //fetch exerciseTimes from storage
    final exerciseTimeDoc =
        await firestore.collection('exerciseTimes').doc(email).get();
    final data = exerciseTimeDoc.data();
    if (data != null) {
      exerciseTimeData = data;
      print(exerciseTimeData);
    } else {
      throw Exception('null data');
    }
  }

  List<int> fetchExerciseTime(DateTime datetime) {
    String date = datetime.toString().substring(0, 10);
    print(exerciseTimeData[date]);
    print(date);
    if (exerciseTimeData[date] != null) {
      List<int> exerciseTimes = List<int>.from(exerciseTimeData[date]);
      print(exerciseTimes);
      return exerciseTimes;
    } else {
      return [0, 0, 0, 0, 0, 0];
    }
  }

  List<int> fetchWeeklyExerciseTime(DateTime datetime) {
    List<int> weeklyExerciseTimes = [];
    int weekDay = datetime.weekday;
    for (int i = weekDay - 1; i >= 0; i--) {
      DateTime date = datetime.subtract(Duration(days: i));
      String dateString = date.toString().substring(0, 10);
      if (exerciseTimeData[dateString] != null) {
        List<int> exerciseTimes = List<int>.from(exerciseTimeData[dateString]);
        weeklyExerciseTimes
            .add(exerciseTimes.reduce((value, element) => value + element));
      } else {
        weeklyExerciseTimes.add(0);
      }
    }
    for (int i = 1; i < weeklyExerciseTimes.length; i++) {
      weeklyExerciseTimes[i] = (weeklyExerciseTimes[i] / 10).round();
    }
    return weeklyExerciseTimes;
  }
}
