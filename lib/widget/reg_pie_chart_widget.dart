import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aiyo11/widget/constant.dart';
import 'package:aiyo11/widget/size_config.dart';

class ActivityPieChart extends StatefulWidget {
  final int totalExerciseTime; // Total exercise time (in minutes)
  final int timeGoal; // Time goal (in minutes)
  final int kcal;

  const ActivityPieChart({
    super.key,
    required this.totalExerciseTime,
    required this.timeGoal,
    required this.kcal,
  });

  @override
  _ActivityPieChartState createState() => _ActivityPieChartState();
}

class _ActivityPieChartState extends State<ActivityPieChart> {
  int _touchedIndex = -1;
  late int selectedTimeGoal; // 用於存儲選擇的目標時間

  @override
  void initState() {
    super.initState();
    selectedTimeGoal = widget.timeGoal; // 初始化為默認目標時間
  }

  @override
  Widget build(BuildContext context) {
    double timeSpentPercentage;
    double remainingPercentage;
    if (selectedTimeGoal <= widget.totalExerciseTime) {
      timeSpentPercentage = 100;
      remainingPercentage = 0;
    } else {
      timeSpentPercentage = (widget.totalExerciseTime / selectedTimeGoal) * 100;
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
            alignment: Alignment.center, // Center align text
            children: [
              // Positioned Pie chart to the left
              Positioned(
                left: 0, // Align to left
                top: 0, // Align to the top
                bottom: 0, // Fill the height of the container
                width: 180, // Set a width for the pie chart
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 3,
                    centerSpaceRadius: 60, // Provides space in the center
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
                            // Handle other touch events
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

              // Center text for total exercise time
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.totalExerciseTime} 分鐘',
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

              SizedBox(height: 10), // Add some space
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Kcal box
                    Container(
                      width: 130,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: CustomColors.kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8), // Inner padding
                      child: Column(
                        children: [
                          Text(
                            '${widget.kcal} 大卡',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.kPrimaryColor,
                            ),
                          ),
                          Text(
                            '消耗熱量',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10), // Space between boxes
                    // Goal time box
                    Container(
                      width: 130,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: CustomColors.kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8), // Inner padding
                      child: Column(
                        children: [
                          Text(
                            '${selectedTimeGoal} 分鐘', // 顯示選擇的目標時間
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.kPrimaryColor,
                            ),
                          ),
                          Text(
                            '目標時間',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          // Button to choose time goal
                          ElevatedButton(
                            onPressed: () => _showTimePicker(),
                            child: Text('設定目標'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  CustomColors.kPrimaryColor, // 按鈕文本顏色
                            ),
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
                      selectedTimeGoal = index + 1; // 更新選擇的目標時間
                    });
                    Navigator.of(context).pop(); // 關閉對話框
                  },
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框而不進行任何更改
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _generateSections(
      double timeSpentPercentage, double remainingPercentage) {
    return List.generate(2, (i) {
      final isTouched = i == _touchedIndex;
      final double radius = isTouched ? 30 : 20;
      switch (i) {
        case 0:
          // Section for total exercise time with a thicker radius
          return PieChartSectionData(
            color: CustomColors.kCyanColor, // Color for time spent
            value: timeSpentPercentage,
            title: '', // No title to remove the percentage
            radius: 35, // Thicker section for total time
          );
        case 1:
          // Section for remaining time with a standard radius
          return PieChartSectionData(
            color: Colors.grey, // Color for remaining time
            value: remainingPercentage,
            title: '', // No title to remove the percentage
            radius: 20, // Thinner section for remaining time
          );
        default:
          return PieChartSectionData(
            color: Colors.grey,
            value: 0,
            title: '',
            radius: 0,
          );
      }
    });
  }
}
