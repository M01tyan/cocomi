import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'Emotion.dart';
import 'dart:math';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final emotions = List<Emotion>.generate(20, (int index) {
    return Emotion(emotion: 2, date: DateTime.now().subtract(new Duration(days: index)));
  });

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocomi',
      home: Scaffold(
        appBar: AppBar(
          title: Text('cocomi'),
          backgroundColor: Colors.amber[700],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                child: EmotionChart(emotions: emotions)
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                children: <Widget>[
                  for (int i=0; i<emotions.length; i++)
                    EmotionCard(emotion: emotions[i]),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

class EmotionChart extends StatelessWidget {
  EmotionChart({@required this.emotions})
    : assert(emotions != null);
  final emotions;

  @override 
  Widget build(BuildContext context) {
    final oldest_date = emotions[emotions.length-1].date;
    final fromDate = DateTime(oldest_date.year, oldest_date.month, oldest_date.day);
    final toDate = DateTime.now();
    final chart_emotions = new List<DataPoint<DateTime>>.generate(emotions.length, (int index) {
      return DataPoint<DateTime>(value: emotions[index].emotion.toDouble(), xAxis: emotions[index].date);
    });
    return BezierChart(
            fromDate: fromDate,
            toDate: toDate,
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
              verticalIndicatorFixedPosition: false,
              backgroundColor: Colors.deepPurple[300],
              footerHeight: 50.0,
            ),
          );
  }
}

class EmotionCard extends StatelessWidget {
  EmotionCard({this.emotion});
  final Emotion emotion;

  @override 
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy年MM月dd日').format(emotion.date);
    return Card(
      child: SizedBox(
        height: 80.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Text('$formattedDate', style: TextStyle(fontSize: 30.0)),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Image(image: AssetImage('assets/happy.png'), height: 60.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}