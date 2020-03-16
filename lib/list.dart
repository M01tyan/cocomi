import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flip_card/flip_card.dart';
import 'emotion.dart';
import 'home.dart';

// 下部の感情カードリスト
class EmotionCardList extends StatefulWidget {
  const EmotionCardList({Key key}) : super(key: key);

  @override
  _EmotionCardListState createState() => _EmotionCardListState();
}

class _EmotionCardListState extends State<EmotionCardList> {

  @override
  void initState() {
    super.initState();
    // Admob.initialize("ca-app-pub-4060274085696934/2178993822");
  }

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
    return Column(
      children: <Widget>[
        Expanded(
          child: emotions.length != 0
          ? ListView.builder(
              itemCount: emotions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
                  child: FlipCard(
                    direction: FlipDirection.VERTICAL,
                    front: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          begin: FractionalOffset(0.8, 0.7),
                          end: FractionalOffset.bottomRight,
                          colors: [
                            const Color(0xFFFFFFFF),
                            Color(emotions[index].emotionColor),
                          ],
                        ),
                      ),
                      height: 110.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30.0,
                            top: 30.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _createDateTextList(emotions[index]),
                                ),
                                Text(emotions[index].printTime, style: TextStyle(fontSize: 30.0, color: Colors.grey[700], height: 0.85))
                              ],
                            )
                          ),
                          Positioned(
                            right: 70.0,
                            top: 10.0,
                            child: Image.asset(
                              emotions[index].assetName,
                              height: 90.0,
                              fit: BoxFit.fitHeight                              
                            )
                          )
                        ],
                      )
                    ),
                    back: Container(
                      height: 110.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          begin: FractionalOffset(0.8, 0.7),
                          end: FractionalOffset.bottomRight,
                          colors: [
                            const Color(0xFFFFFFFF),
                            Color(emotions[index].emotionColor),
                          ],
                        ),
                      ),
                      child: Text("back")
                    )
                  )
                );
            }
          ) :
          const Center(
            child: const Text(
              'あなたの気持ちを記録してください。',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w800
              ),
            ),
          )
        ),
        // SizedBox(
        //   height: 60,
        //   child: AdmobBanner(
        //     adUnitId: "ca-app-pub-4060274085696934/2178993822",
        //     adSize: AdmobBannerSize.FULL_BANNER,
        //   )
        // )
      ]
    );
  }

  List<Widget> _createDateTextList(Emotion emotion) {
    final List<Widget> dateListWidget = [];
    dateListWidget.add(
      Text("${emotion.date.month}/", style: TextStyle(fontSize: 20.0, color: Colors.grey[700]))
    );
    dateListWidget.add(
      Text("${emotion.date.day}", style: TextStyle(fontSize: 30.0, color: Colors.grey[700], height: 1.0))
    );
    dateListWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _createWeekTextList(emotion),
        )
      )
    );
    return dateListWidget;
  }

  List<Widget> _createWeekTextList(Emotion emotion) {
    final List<Widget> weekListWidget = [];
    final List<String> weekList = emotion.printWeek.split("");
    for (final str in weekList) {
      weekListWidget.add(
        Text(str, style: TextStyle(fontSize: 10.0, color: emotion.weekColor, height: 0.8))
      );
    }
    return weekListWidget;
  }
}