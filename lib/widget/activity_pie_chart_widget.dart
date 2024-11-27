import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiyo11/widget/constant.dart';
<<<<<<< HEAD
import 'package:aiyo11/services/exercise.dart';

=======
>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
import 'package:aiyo11/widget/size_config.dart';

class ActivityPieChart extends StatefulWidget {
  final List<int> exerciseTimes;
  //final int kcal;

  const ActivityPieChart({
    super.key,
    required this.exerciseTimes,
    //required this.kcal,
  });

  @override
  _ActivityPieChartState createState() => _ActivityPieChartState();
}

class _ActivityPieChartState extends State<ActivityPieChart> {
  int _touchedIndex = -1;
  late int selectedTimeGoal = 30;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeGoal();
  }

  // Load the saved time goal from SharedPreferences
  void _loadTimeGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTimeGoal =
          prefs.getInt('timeGoal') ?? 30; // Default to 30 if not set
      _isLoading = false;
    });
  }

  // Save the time goal to SharedPreferences
  void _saveTimeGoal(int goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeGoal', goal);
  }

  int totalExerciseTime() {
    return widget.exerciseTimes.fold(0, (sum, time) => sum + time);
  }

  // Calculate total calories burned
  int totalCaloriesBurned() {
    int totalTime = totalExerciseTime(); // Get the total exercise time
    return totalTime * 5; // Each minute burns 5 kcal
  }

  @override
  Widget build(BuildContext context) {
    double totalTime = totalExerciseTime().toDouble();
    double timeSpentPercentage;
    double remainingPercentage;
    if (selectedTimeGoal <= totalTime) {
      timeSpentPercentage = 100;
      remainingPercentage = 0;
    } else {
      timeSpentPercentage = (totalTime / selectedTimeGoal) * 100;
      remainingPercentage = 100 - timeSpentPercentage;
    }

    return Container(
      height: 250,
      width: 400,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 180,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 3,
                    centerSpaceRadius: 60,
                    startDegreeOffset: 270,
                    sections: _generateSections(
                        timeSpentPercentage, remainingPercentage),
                    pieTouchData: PieTouchData(
                      touchCallback:
                          (FlTouchEvent event, PieTouchResponse? response) {
                        setState(() {
                          if (event is FlLongPressEnd ||
                              event is FlPanEndEvent) {
                            _touchedIndex = -1;
                          } else {
                            if (response != null &&
                                response.touchedSection != null) {
                              _touchedIndex =
                                  response.touchedSection!.touchedSectionIndex;
                            } else {
                              _touchedIndex = -1;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${totalTime.toInt()} 分鐘',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.kPrimaryColor,
                      ),
                    ),
                    Text(
                      '今日運動時間',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _infoBox('${totalCaloriesBurned()} 大卡', '消耗熱量'),
                    SizedBox(height: 10),
                    _infoBox(
                      '${selectedTimeGoal} 分鐘',
                      '目標時間',
                      additionalWidget: ElevatedButton(
                        onPressed: () => _showTimePicker(),
                        child: Text('設定目標'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: CustomColors.kPrimaryColor,
                        ),
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

  Widget _infoBox(String title, String subtitle, {Widget? additionalWidget}) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomColors.kPrimaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CustomColors.kPrimaryColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          if (additionalWidget != null) ...[
            SizedBox(height: 5),
            additionalWidget,
          ],
        ],
      ),
    );
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('選擇目標時間'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(60, (index) {
                return ListTile(
                  title: Text('${index + 1} 分鐘'),
                  onTap: () {
                    setState(() {
                      selectedTimeGoal = index + 1;
                    });
                    _saveTimeGoal(
                        selectedTimeGoal); // Save the goal to SharedPreferences
                    Navigator.of(context).pop();
                  },
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _generateSections(
      double timeSpentPercentage, double remainingPercentage) {
    return [
      PieChartSectionData(
        color: CustomColors.kCyanColor,
        value: timeSpentPercentage,
        title: '',
        radius: 35,
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: remainingPercentage,
        title: '',
        radius: 20,
      ),
    ];
  }
}
