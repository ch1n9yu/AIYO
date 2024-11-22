import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/constant.dart';

class AchievementPage extends StatefulWidget {
  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  Map<DateTime, bool> _attendanceRecords = {}; // 紀錄每一天是否簽到
  int _totalPoints = 0; // 總積分
  int _checkedInDays = 0; // 簽到天數計數
  int _monthlyStreak = 0; // 本月簽到天數
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  // Load all attendance records from SharedPreferences
  Future<void> _loadAttendanceRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalPoints = prefs.getInt('totalPoints') ?? 0;
      _checkedInDays = prefs.getInt('checkedInDays') ?? 0;
      _monthlyStreak = prefs.getInt('monthlyStreak') ?? 0;

      _attendanceRecords = {};

      // Load all attendance records from SharedPreferences by iterating over stored keys
      prefs.getKeys().forEach((key) {
        if (key.startsWith('attendance_')) {
          DateTime day = DateTime.parse(key.replaceFirst('attendance_', ''));
          _attendanceRecords[day] = prefs.getBool(key) ?? false;
        }
      });
    });
  }

// Save all attendance records to SharedPreferences
  Future<void> _saveAttendanceRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalPoints', _totalPoints);
    prefs.setInt('checkedInDays', _checkedInDays);
    prefs.setInt('monthlyStreak', _monthlyStreak);

    _attendanceRecords.forEach((key, value) {
      prefs.setBool('attendance_${key.toString()}', value);
    });
  }

  // 記錄用戶簽到
  void _checkIn() {
    setState(() {
      if (_attendanceRecords[_selectedDay] == null ||
          !_attendanceRecords[_selectedDay]!) {
        _attendanceRecords[_selectedDay] = true;
        _checkedInDays++;
        _totalPoints++;
        if (_isInCurrentMonth(_selectedDay)) {
          _monthlyStreak++;
        } else {
          _monthlyStreak = 1; // 新月開始新的簽到連續天數
        }
        _saveAttendanceRecords();
      }
    });
  }

  // 檢查是否允許簽到
  bool _canCheckIn() {
    return true;
  }

  // 檢查日期是否在當前月份
  bool _isInCurrentMonth(DateTime date) {
    return date.month == _focusedDay.month && date.year == _focusedDay.year;
  }

  // 計算本月成就
  Widget _buildAchievements() {
    List<Widget> achievementIcons = [];
    if (_monthlyStreak >= 10)
      achievementIcons.add(Icon(Icons.star, color: Colors.yellow));
    if (_monthlyStreak >= 20)
      achievementIcons.add(Icon(Icons.star, color: Colors.yellow));
    if (_monthlyStreak >= 30)
      achievementIcons.add(Icon(Icons.star, color: Colors.yellow));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: achievementIcons.isEmpty ? [Text('')] : achievementIcons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Check-In',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF6563A5),
        iconTheme: IconThemeData(
          color: Colors.white, // 改變返回箭頭的顏色為白色
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(
                fontSize: 20,
                color: CustomColors.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon:
                  Icon(Icons.chevron_left, color: CustomColors.kPrimaryColor),
              rightChevronIcon:
                  Icon(Icons.chevron_right, color: CustomColors.kPrimaryColor),
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color(0xFFBDB5DA),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color(0xFFBDB5DA),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: CustomColors.kCyanColor,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            holidayPredicate: (day) {
              return _attendanceRecords[day] ?? false;
            },
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _canCheckIn() ? _checkIn : null,
            child: Text(
              '簽到',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300, 50),
              foregroundColor: Colors.white,
              backgroundColor: CustomColors.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '目前已簽到天數: $_checkedInDays 天',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.kPrimaryColor),
              ),
              SizedBox(height: 10),
            ]),
          ),

          // SizedBox(height: 20), // Add some spacing before the boxes
          // Adding three hollow boxes in separate rows
          Column(
            children: [
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomColors.kPrimaryColor,
                      width: 2), // Border color and width
                  borderRadius:
                      BorderRadius.circular(5), // Optional: Rounded corners
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '       已簽到10天',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _monthlyStreak >= 10
                              ? CustomColors.kCyanColor
                              : Colors.black,
                        ),
                      ),
                      SizedBox(width: 80),
                      if (_monthlyStreak >= 10)
                        Icon(Icons.check,
                            color: CustomColors.kCyanColor), // Star for 10 days
                      // Spacing between the star and text
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between boxes
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: CustomColors.kPrimaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '       已簽到20天',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _monthlyStreak >= 20
                              ? CustomColors.kCyanColor
                              : Colors.black,
                        ),
                      ),
                      SizedBox(width: 80),
                      if (_monthlyStreak >= 20)
                        Icon(Icons.check,
                            color: CustomColors.kCyanColor), // Star for 20 days
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between boxes
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: CustomColors.kPrimaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '       已簽到30天',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _monthlyStreak >= 30
                              ? CustomColors.kCyanColor
                              : Colors.black,
                        ),
                      ),
                      SizedBox(width: 80), // Spacing between the star and text
                      if (_monthlyStreak >= 30)
                        Icon(Icons.check,
                            color: CustomColors.kCyanColor), // Star for 30 days
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
