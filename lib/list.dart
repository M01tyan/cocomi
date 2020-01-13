import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'emotion.dart';
import 'home.dart';

// 下部の感情カードリスト
class EmotionCardList extends StatelessWidget {
  const EmotionCardList({Key key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final Emotion detailEmotion = Inherited.of(context, listen: true).detailEmotion;
    return detailEmotion != null 
      ? Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat("yyyy年MM月dd日").format(detailEmotion.date),
                  style: TextStyle(
                    fontSize: 25.0
                  )
                ),
                Text(
                  DateFormat("a hh:00").format(detailEmotion.date),
                  style: TextStyle(
                    fontSize: 40.0
                  )
                ),
                Image(image: AssetImage(detailEmotion.assetName), fit: BoxFit.fitHeight, height: 140.0,)
              ]
            )
        )
      )
      // GridView.count(
      //   crossAxisCount: 2,
      //   children: _createListEmotion(emotions),
      // ) 
      : 
      const Center(
        child: const Text(
          'あなたの気持ちを記録してください。',
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w800
          ),
        ),
      );
  }

  // 感情カードと月カードのリストを作成する関数
  List<Widget> _createListEmotion(List<Emotion> emotions) {
    var preDate = emotions[emotions.length-1].date;
    if (preDate.month == emotions[0].date.month)
      preDate = new DateTime(preDate.year, preDate.month-1, 0);
    final List<Widget> listPrint = [];
    for(int i=0; i<emotions.length; i++) {
      if (preDate.month != emotions[i].date.month) {
        // 月のカードを追加
        preDate = emotions[i].date;
        listPrint.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionMonthCard(emotion: emotions[i]),
          )
        );
        i--;
      } else {
        // 感情カードを追加
        listPrint.add(
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
            child: _EmotionDayCard(emotion: emotions[i]),
          )
        );
      }
    }
    return listPrint;
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
    final deleteEmotion = Inherited.of(context, listen: false).deleteEmotion;
    return GestureDetector(
      child: Card(
        child: SizedBox(
          height: 80.0,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            emotion.printAmPm,
                            style: Theme.of(context).textTheme.title.copyWith(
                              fontSize: 35,
                              color: emotion.weekColor
                            ),
                          ),
                          Text(
                            emotion.printHour,
                            style: Theme.of(context).textTheme.body2.copyWith(
                              height: 0.8,
                            ),
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
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        emotion.printWeek,
                        style: TextStyle(
                          height: 0.5,
                          fontSize: 11,
                          color: emotion.weekColor
                        )
                      ),
                      Text(
                        emotion.printDay,
                        style: TextStyle(
                          height: 1,
                          fontSize: 20,
                          color: Colors.grey[700]
                        )
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('このカードを削除しますか？'),
              content: const Text('一度削除すると復元することはできません'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    "CANCEL",
                    style: const TextStyle(color: Colors.blue),
                  ),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: const Text("OK"),
                  isDestructiveAction: true,
                  onPressed: () {
                    deleteEmotion(emotion.date);
                    Navigator.pop(context);
                  }
                ),
              ]
            );
          }
        );
      },
    );
  }
}