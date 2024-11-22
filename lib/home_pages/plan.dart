import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aiyo11/widget/constant.dart';
import 'package:aiyo11/widget/size_config.dart';
import 'package:aiyo11/widget/activity_pie_chart_widget.dart';
import 'package:aiyo11/widget/weekly_bar_chart_widget.dart';
import 'dart:async';
import 'package:aiyo11/component/bmi.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aiyo11/widget/bmi_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiyo11/services/account.dart';
import 'package:aiyo11/services/exercise.dart';
import 'package:lottie/lottie.dart';

import '../widget/linechart_page.dart';

class Plan extends StatefulWidget {
  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> with TickerProviderStateMixin {
  AccountServices accountServices = AccountServices();
  DateTime selectedDate = DateTime.now(); // 当前选择的日期
  List<int> weeklyData = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  final exerciseTimeStorage =
      ExerciseTimeStorage(email: AccountServices().email!);
  List<int> exerciseTimes = [];
  bool isFetching = true;
  late final AnimationController _animationController;

  late int id;
  List<BMI> BMIs = [];
  List<double> heights = [];
  List<double> weights = [];
  List<Timestamp> dates = [];
  List<int> ids = [];
  List<FlSpot> flspots = [];
  List<double> bmis = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
    );
    init(DateTime.now());
    updateBMIs();

    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> updateBMIs() async {
    await accountServices.fetchAccounts();
    print('${accountServices.bmiDatas}   bmidatas');
    BMIs = await accountServices.takeBMIs();
    flspots = await accountServices.takeSpot();
    id = accountServices.heights.length;
    print(BMIs[0].height);
    setState(() {});
  }

  Future<void> init(DateTime datetime) async {
    await exerciseTimeStorage.getData();
    exerciseTimes =
        exerciseTimeStorage.fetchExerciseTime(datetime); // 获取当天的运动时间
    weeklyData = exerciseTimeStorage.fetchWeeklyExerciseTime(datetime);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // 初始化 SizeConfig
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: isFetching,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 250),
                        Lottie.asset(
                          'asset/animate/loading.json',
                          height: 250,
                          width: 250,
                          controller: _animationController,
                          onLoaded: (composition) {
                            _animationController.duration =
                                composition.duration;
                            _animationController.forward().then((value) {
                              _animationController.stop();
                              isFetching = false;
                              setState(() {});
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !isFetching,
                  child: Column(
                    children: [
                      _buildMonthSection(),
                      _buildDateSection(),
                      const SizedBox(height: 20),
                      const Text(
                        " EXERCISE TIME",
                        style: TextStyle(
                          color: Color(0xFF6563A5),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: exerciseTimes != [0, 0, 0, 0, 0, 0],
                        child: ActivityPieChart(
                          exerciseTimes: exerciseTimes,
                          //kcal: 150,
                        ),
                      ),
                      Visibility(
                        visible: exerciseTimes == [0, 0, 0, 0, 0, 0],
                        child: const Center(
                          child: Text(
                            'A little bit lazy today, \n no exercise data yet.',
                            style: TextStyle(
                              color: Color(0xFF6563A5),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        " GOAL COMPLIANCE",
                        style: TextStyle(
                          color: Color(0xFF6563A5),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      WeeklyBarChartWidget(
                        weeklyData: weeklyData,
                        maximumValueOnAxis: 65,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "TRACK YOUR BMI",
                        style: TextStyle(
                          color: Color(0xFF6563A5),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 200,
                        width: double.infinity,
                        child: LineChartOfBMI(flspots: flspots),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 400,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: BMIs.length,
                          itemBuilder: (context, index) {
                            return BMIcard(
                              height: BMIs[index].height,
                              heightChanged: (height) => setState(() {
                                BMIs[index].height = height;
                              }),
                              weight: BMIs[index].weight,
                              weightChanged: (weight) => setState(() {
                                BMIs[index].weight = weight;
                              }),
                              id: BMIs[index].id,
                              date: BMIs[index].date,
                              bmi: BMIs[index].calculateBmi(),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              id++;
                              BMIs.add(
                                BMI(
                                  id: id,
                                  date: DateTime.now(),
                                  height: 160,
                                  weight: 55,
                                ),
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.add),
                          ),
                          TextButton(
                              onPressed: () {
                                for (BMI bmi in BMIs) {
                                  heights.add(bmi.height);
                                  weights.add(bmi.weight);
                                  dates.add(Timestamp.fromDate(bmi.date));
                                  bmis.add(bmi.calculateBmi());
                                  ids.add(bmi.id);
                                }
                                print(heights[0]);
                                final data = AccountServices.firestore
                                    .collection('BMIs')
                                    .doc('${AccountServices().email}');
                                data.set({
                                  'heights': heights,
                                  'weights': weights,
                                  'dates': dates,
                                  'ids': ids,
                                });
                              },
                              child: Text('SAVE'))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildMonthSection() {
    String monthName = DateFormat.MMMM().format(selectedDate); // 获取月份名称
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        monthName,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6563A5),
        ),
      ),
    );
  }

  Container _buildDateSection() {
    List<DateTime> weekDates = _getWeekDates(selectedDate);
    return Container(
      height: SizeConfig.blockSizeVertical * 13,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: weekDates.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          DateTime date = weekDates[index];
          int dayValue = date.weekday;
          String dayName = DateFormat.E().format(date); // 获取星期的缩写
          String dayNumber = DateFormat.d().format(date); // 获取日期
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
                init(date);
                if (exerciseTimes.isEmpty) {
                  exerciseTimes = [0, 0, 0, 0, 0, 0];
                }

                // 更新数据逻辑可以在这里实现
                // 例如，根据selectedDate加载相关的数据
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: dayValue == selectedDate.weekday
                          ? CustomColors.kPrimaryColor
                          : selectedDate.weekday < dayValue
                              ? CustomColors.kLightColor
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CircleAvatar(
                    backgroundColor: dayValue == selectedDate.weekday
                        ? CustomColors.kPrimaryColor
                        : Colors.transparent,
                    child: Text(
                      dayNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dayValue >= selectedDate.weekday
                            ? CustomColors.kLightColor
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<DateTime> _getWeekDates(DateTime currentDate) {
    int currentWeekday = currentDate.weekday;
    DateTime firstDayOfWeek =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    return List.generate(
        7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }
}
