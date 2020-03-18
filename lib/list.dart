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
  var _text = "";
  var textFieldController;
  final ScrollController listViewController = new ScrollController();
  final FocusNode textFieldNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    textFieldNode.addListener(_onFocus);
    // Admob.initialize("ca-app-pub-4060274085696934/2178993822");
  }

  @override 
  void dispose() {
    textFieldController.dispose();
    textFieldNode.dispose();
    super.dispose();
  }

  _onFocus() {
    print(listViewController.offset);

    if (textFieldNode.hasFocus) {
      listViewController.animateTo(110.0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Column(
      children: <Widget>[
        Expanded(
          child: emotions.length != 0
          ? ListView.builder(
              controller: listViewController,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              itemCount: emotions.length,
              itemBuilder: (BuildContext context, int index) {
                textFieldController = new TextEditingController(text: emotions[index].memo);
                return Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
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
                          ),
                          Positioned(
                            top: 8.0,
                            right: 15.0,
                            child: Icon(
                              Icons.flip_to_back,
                              size: 30.0,
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 80.0, 0.0),
                            child: TextField(
                              controller: textFieldController,
                              focusNode: textFieldNode,
                              maxLines: 3,
                              maxLength: 150,
                              maxLengthEnforced: true,
                              textInputAction: TextInputAction.go,
                              style: TextStyle(fontSize: 15.0),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'メモ',
                                counterText: "",
                                hintText: "あなたの今の気持ちをメモしてください。",
                              ),
                              onChanged: (value) {
                                emotions[index].editMemo = value;
                              },
                            )
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.flip_to_front,
                                  size: 30.0,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  iconSize: 45.0,
                                  onPressed: () {

                                  },
                                )
                              ]
                            )
                          )
                        ]
                      )
                    ),
                    onFlip: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
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
        SizedBox(
          height: 60,
          // child: AdmobBanner(
          //   adUnitId: "ca-app-pub-4060274085696934/2178993822",
          //   adSize: AdmobBannerSize.FULL_BANNER,
          // )
        )
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