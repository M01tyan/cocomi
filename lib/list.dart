import 'package:flutter/material.dart';
import 'emotion.dart';
import 'home.dart';

// 下部の感情カードリスト
class EmotionCardList extends StatelessWidget {
  const EmotionCardList({Key key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
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
            child: _EmotionMonthCard(emotion: emotions[i]),
          )
        );
        i--;
      } else {
        // 感情カードを追加
        list_print.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionDayCard(emotion: emotions[i]),
          )
        );
      }
    }
    return list_print;
  }
}

//月のカードウィジェット
class _EmotionMonthCard extends StatelessWidget {
  const _EmotionMonthCard({Key key, @required this.emotion}) : super(key: key);
  final Emotion emotion;

  @override 
  Widget build(BuildContext context) {
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

// 1日のカードウィジェット
class _EmotionDayCard extends StatelessWidget {
  const _EmotionDayCard({Key key, @required this.emotion}) : super(key: key);
  final Emotion emotion;

  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80.0,
        child: Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Expanded(
                child: Image(image: AssetImage(emotion.assetName), fit: BoxFit.fitHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}