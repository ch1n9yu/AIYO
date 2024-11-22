import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aiyo11/widget/chart_title_widgets.dart';

const TextStyle style = TextStyle(
  fontFamily: 'PS',
  fontSize: 28,
);
const TextStyle styles = TextStyle(
  fontFamily: 'PS',
  fontSize: 23,
);

List<Color> colors = [Colors.red, Colors.purple, Colors.blue];

class LineChartOfBMI extends StatelessWidget {
  const LineChartOfBMI({
    super.key,
    required this.flspots,
  });

  final List<FlSpot> flspots;

  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
          titlesData: titles,
          minX: 0,
          maxX: 11,
          minY: 15,
          maxY: 25,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              spots: flspots,
            ),
          ],
        ),
    );
  }
}
