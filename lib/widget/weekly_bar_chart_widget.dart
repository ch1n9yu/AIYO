import 'package:aiyo11/widget/constant.dart';
import 'package:aiyo11/widget/size_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyBarChartWidget extends StatefulWidget {
  final List<int> weeklyData;
  final double maximumValueOnAxis;

  WeeklyBarChartWidget({
    required this.weeklyData,
    required this.maximumValueOnAxis,
  });

  @override
  _WeeklyBarChartWidgetState createState() => _WeeklyBarChartWidgetState();
}

class _WeeklyBarChartWidgetState extends State<WeeklyBarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Container(
          //height: SizeConfig.blockSizeVertical * 100,
          child: BarChart(mainBarData()),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: CustomColors.kCyanColor,
          width: 20.0,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            color: CustomColors.kCyanColor.withOpacity(0.2),
            toY: widget.maximumValueOnAxis - 5,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(widget.weeklyData.length, (index) {
      return makeGroupData(index, widget.weeklyData[index].toDouble());
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      maxY: widget.maximumValueOnAxis,
      borderData: FlBorderData(show: false),
      groupsSpace: 27,
      titlesData: _buildAxes(),
      alignment: BarChartAlignment.center,
      barGroups: showingGroups(),
      gridData: FlGridData(show: false), // 禁用虛線
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
      show: true,
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            TextStyle style = const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
            Widget text;
            switch (value.toInt()) {
              case 0:
                text = Text('Mon', style: style);
                break;
              case 1:
                text = Text('Tue', style: style);
                break;
              case 2:
                text = Text('Wed', style: style);
                break;
              case 3:
                text = Text('Thu', style: style);
                break;
              case 4:
                text = Text('Fri', style: style);
                break;
              case 5:
                text = Text('Sat', style: style);
                break;
              case 6:
                text = Text('Sun', style: style);
                break;
              default:
                text = Text('', style: style);
                break;
            }
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: text,
              space: 5,
            );
          },
        ),
      ),
    );
  }
}
