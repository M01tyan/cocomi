import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';

import 'Emotion.dart';

class Home extends StatelessWidget {
  Home({@required this.emotions}) : assert(emotions != null);
  final List<Emotion> emotions;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // 上部のチャート
          Expanded(
            flex: 3,
            child: EmotionChart(emotions: emotions),
          ),
          // 下部のリスト
          Expanded(
            flex: 7,
            child: EmotionCardList(emotions: emotions),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              backgroundColor: Colors.white70,
              builder: (context) => Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image(image: AssetImage('assets/sad.png'), height: 110.0),
                    Image(image: AssetImage('assets/normal.png'), height: 110.0),
                    Image(image: AssetImage('assets/happy.png'), height: 110.0)
                  ],
                ),
              ),
              elevation: 8.0
            );
          },
          child: Image(image: AssetImage('assets/normal.png'), height: 80.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber[700],
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}

// 上部のチャートウィジェット
class EmotionChart extends StatelessWidget {
  EmotionChart({@required this.emotions})
    : assert(emotions != null);
  final List<Emotion> emotions;

  @override 
  Widget build(BuildContext context) {
    final DateTime oldest_date = emotions[emotions.length-1].date;
    final DateTime fromDate = DateTime(oldest_date.year, oldest_date.month, oldest_date.day);
    final DateTime toDate = DateTime.now();
    final List<DataPoint<DateTime>> chart_emotions = new List<DataPoint<DateTime>>.generate(emotions.length, (int index) {
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

// 下部の感情カードリスト
class EmotionCardList extends StatelessWidget {
  EmotionCardList({this.emotions});
  final List<Emotion> emotions;

  @override 
  Widget build(BuildContext context) {
    var list_emotions = emotions[0];
    return GridView.count(
      crossAxisCount: 2,
      children: _createListEmotion(context, emotions),
    );
  }

  // 感情カードと月カードのリストを作成する関数
  List<Widget> _createListEmotion(BuildContext context, List<Emotion> emotions) {
    var pre_date = emotions[emotions.length-1].date;
    final List<Widget> list_print = [];
    for(int i=0; i<emotions.length; i++) {
      if (pre_date.month != emotions[i].date.month) {
        // 月のカードを追加
        pre_date = emotions[i].date;
        list_print.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionMonthCard(context, emotions[i]),
          )
        );
        i--;
      } else {
        // 感情カードを追加
        list_print.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionDayCard(context, emotions[i]),
          )
        );
      }
    }
    return list_print;
  }

  // 感情カードウィジェット
  Widget _EmotionDayCard(BuildContext context, Emotion emotion) {
    return Card(
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
    );
  }

  // 月カードウィジェット
  Widget _EmotionMonthCard(BuildContext context, Emotion emotion) {    
    return Card(
      child: SizedBox(
        height: 80.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              emotion.printEnglishMonth,
              style: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.grey[700],
              ),
            ),
            Text(
              emotion.printJapaneseMonth,
              style: Theme.of(context).textTheme.body2
            ),
          ],
        ),
      ),
      color: Colors.grey[400]
    );
  }
}