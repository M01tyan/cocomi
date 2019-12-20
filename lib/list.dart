import 'package:flutter/material.dart';
import 'emotion.dart';

// 下部の感情カードリスト
class EmotionCardList extends StatelessWidget {
  EmotionCardList({this.emotions});
  final List<Emotion> emotions;
  var _context;
  @override 
  Widget build(BuildContext context) {
    _context = context;
    return GridView.count(
      crossAxisCount: 2,
      children: _createListEmotion(emotions),
    );
  }

  // 感情カードと月カードのリストを作成する関数
  List<Widget> _createListEmotion(List<Emotion> emotions) {
    var pre_date = emotions[emotions.length-1].date;
    final List<Widget> list_print = [];
    for(int i=0; i<emotions.length; i++) {
      if (pre_date.month != emotions[i].date.month) {
        // 月のカードを追加
        pre_date = emotions[i].date;
        list_print.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionMonthCard(emotions[i]),
          )
        );
        i--;
      } else {
        // 感情カードを追加
        list_print.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionDayCard(emotions[i]),
          )
        );
      }
    }
    return list_print;
  }

  // 感情カードウィジェット
  Widget _EmotionDayCard(Emotion emotion) {
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
                    style: Theme.of(_context).textTheme.body1.copyWith(
                      color: emotion.weekColor
                    ),
                  ),
                  Text(
                    emotion.printDate.toString(),
                    style: Theme.of(_context).textTheme.body2,
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
  Widget _EmotionMonthCard(Emotion emotion) {    
    return Card(
      child: SizedBox(
        height: 80.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              emotion.printEnglishMonth,
              style: Theme.of(_context).textTheme.body1.copyWith(
                color: Colors.grey[700],
              ),
            ),
            Text(
              emotion.printJapaneseMonth,
              style: Theme.of(_context).textTheme.body2
            ),
          ],
        ),
      ),
      color: Colors.grey[400]
    );
  }
}