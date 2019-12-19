import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'Emotion.dart';
import 'dart:math';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final emotions = List<Emotion>.generate(20, (int index) {
    final _random = new Random();
    return Emotion(emotion: _random.nextInt(3)-1, date: DateTime.now().subtract(new Duration(days: index)));
  });

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocomi',
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(
            fontSize: 25.0, 
            fontWeight: FontWeight.w700,
          ),
          body2: TextStyle(
            fontSize: 55.0, 
            fontWeight: FontWeight.bold, 
            height: 1, 
            color: Colors.grey[700]
          ),
        )
      ),
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
              child: EmotionCard(emotions: emotions),
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
  EmotionCard({this.emotions});
  final List<Emotion> emotions;

  @override 
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: emotions.map((emotion) {
        return Padding(
          padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
          child: Card(
            child: SizedBox(
              height: 80.0,
              child: Padding(
                padding: EdgeInsets.only(top: 7.0, bottom: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          emotion.printWeek,
                          style: Theme.of(context).textTheme.body1.copyWith(
                            color: emotion.weekColor
                          ),
                        ),
                        Text(
                          emotion.printDate.toString(),
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ],
                    ),
                    Image(image: AssetImage(emotion.assetName), height: 80.0),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}