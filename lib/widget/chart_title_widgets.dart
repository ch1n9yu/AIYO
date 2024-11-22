import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget chartBottomTitleWidgets(double value, TitleMeta meta) {
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Jan';
      break;
    case 1:
      text = 'Feb';
      break;
    case 2:
      text = 'Mar';
      break;
    case 3:
      text = 'Apr';
      break;
    case 4:
      text = 'May';
      break;
    case 5:
      text = 'Jun';
      break;
    case 6:
      text = 'Jul';
      break;
    case 7:
      text = 'Aug';
      break;
    case 8:
      text = 'Sep';
      break;
    case 9:
      text = 'Oct';
      break;
    case 10:
      text = 'Nov';
      break;
    case 11:
      text = 'Dec';
      break;
    default:
      return Container();
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 10:
      text = '10';
      break;
    case 15:
      text = '15';
      break;
    case 20:
      text = '20';
      break;

    case 25:
      text = '25';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}


FlTitlesData titles = const FlTitlesData(
  leftTitles: AxisTitles(
    axisNameWidget: Text('BMI'),
    sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: leftTitleWidgets,
    ),
  ),
  bottomTitles: AxisTitles(
    axisNameWidget: Text('time'),
    sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: chartBottomTitleWidgets,
    ),
  ),
  topTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: false,
    ),
  ),
  rightTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: false,
    ),
  ),
);