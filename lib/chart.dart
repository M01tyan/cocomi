import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';

import 'emotion.dart';
import 'home.dart';

// 上部のチャートウィジェット
class EmotionChart extends StatelessWidget {
  const EmotionChart({Key key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
    final DateTime oldest_date = emotions[emotions.length-1].date;
    final DateTime fromDate = DateTime(oldest_date.year, oldest_date.month, oldest_date.day);
    final DateTime toDate = emotions[0].date;
    var chart_emotions = new List<DataPoint<DateTime>>.generate(emotions.length, (int index) {
      return DataPoint<DateTime>(value: emotions[index].emotion.toDouble(), xAxis: emotions[index].date);
    });
    return BezierChart(
      fromDate: fromDate,
      toDate: toDate,
      selectedDate: toDate,
      bezierChartScale: BezierChartScale.WEEKLY,
      series: [
        BezierLine(
          data: chart_emotions,
        ),
      ],
      config: BezierChartConfig(
        verticalIndicatorStrokeWidth: 3.0,
        verticalIndicatorColor: Colors.black26,
        showVerticalIndicator: true,
        verticalIndicatorFixedPosition: true,
        backgroundColor: Colors.deepPurple[300],
        footerHeight: 50.0,
      ),
    );
  }
}