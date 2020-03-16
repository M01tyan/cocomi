import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'emotion.dart';
import 'list.dart';
import 'chart.dart';

class ParentScaffold extends StatelessWidget {
  const ParentScaffold({Key key}) : super(key: key);

  Future<List<Emotion>> _getEmotions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String storeEmotions = prefs.getString('emotions') ?? "";
      List<Emotion> emotions = (jsonDecode(storeEmotions) as List).map((json) => Emotion.fromJson(json)).toList();
      return emotions;
    } catch(e) {
      return [];
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cocomi'),
        backgroundColor: Colors.amber[700],
        leading: null,
      ),
      body: FutureBuilder(
        future: _getEmotions(),
        builder: (BuildContext context, AsyncSnapshot<List<Emotion>> snapshot) {
          if (snapshot.hasData) {
            return Home(emotions: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({ Key key, this.emotions }) : super(key: key);
  final emotions;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var emotions;
  var detailEmotion;
  String _text = '';
  TextEditingController _textEditingController;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    setState(() {
      emotions = widget.emotions;
    });
    super.initState();
    _textEditingController = new TextEditingController(text: '');
  }

  void _addEmotion(int emotion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emotions.insert(0, new Emotion(emotion: emotion, date: DateTime.now()));
    String jsonEmotions = jsonEncode(emotions);
    await prefs.setString('emotions', jsonEmotions);
    setState(() {
      emotions = emotions;
    });
  }

  void _deleteEmotion(DateTime removeDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emotions.removeWhere((item) => item.date == removeDate);
    String jsonEmotions = jsonEncode(emotions);
    await prefs.setString('emotions', jsonEmotions);
    setState(() {
      emotions = emotions;
    });
  }

  void _showEmotion(Emotion emotion) {
    setState(() {
      detailEmotion = emotion;
    });
  }

  @override 
  Widget build(BuildContext context) {
    // if (focusNode != null && focusNode.hasFocus == true) {
    //   var toolBar = _normalToolBar();
    //   columnWidget.add(toolBar);
    // }
    return Inherited(
      emotions: emotions,
      detailEmotion: detailEmotion,
      deleteEmotion: (DateTime date) => _deleteEmotion(date),
      showEmotion: (Emotion emotion) => _showEmotion(emotion),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
          child: Column(
            children: <Widget>[
              // 上部のチャート
              Expanded(
                flex: 3,
                child: EmotionChart(),
              ),
              // 下部のリスト
              Expanded(
                flex: 7,
                child: EmotionCardList(),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 80.0,
          width: 80.0,
          child: FloatingActionButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext builder) {
                return DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.15,
                maxChildSize: 0.6,
                builder: (BuildContext builder, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 50.0, 
                              height: 5.0,
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [0, 1, 2].map((item) { 
                                final Emotion emotion = new Emotion(emotion: item, date: DateTime.now());
                                return GestureDetector(
                                  onTap: () async  {
                                    Navigator.pop(context);
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomDialog(emotion: emotion)
                                    );
                                    // state.addEmotion(item);
                                  },
                                  child: Image(image: AssetImage(emotion.assetName), height: 110.0)
                                );
                              }).toList(),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 160.0, 20.0, 0.0),
                            child: TextField(
                              controller: _textEditingController,
                              maxLines: 5,
                              style: TextStyle(fontSize: 20.0),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'メモ',
                              ),
                              focusNode: this.focusNode,
                              onChanged: (value) {
                                setState(() {
                                  _text = value;
                                });
                              },
                            )
                          ),
                        ],
                      ),
                    )
                  );
                }
              );}
            ),
            child: const Image(image: AssetImage('assets/normal.png'), height: 80.0),
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
      ),
    );
  }

  Widget _normalToolBar() {
    return Container(
      decoration: BoxDecoration(
          border: BorderDirectional(top: BorderSide(color: Colors.black)),
          color: Colors.grey[200]),
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
            child: Text('完了'),
            onPressed: () {
              focusNode.unfocus(); //unfocus()でフォーカスが外れる
            },
          )
        ],
      ));
  }
}

class Inherited extends InheritedWidget {
  const Inherited({
    Key key,
    this.emotions,
    this.addEmotion,
    this.deleteEmotion,
    this.showEmotion,
    this.detailEmotion,
    @required Widget child,
  }) : assert(child != null),
       super(key: key, child: child);

  final List<Emotion> emotions;
  final Function addEmotion;
  final Function deleteEmotion;
  final Function showEmotion;
  final Emotion detailEmotion;

  static Inherited of(
    BuildContext context, {
    @required bool listen,
  }) {
    return listen
      ? context.dependOnInheritedWidgetOfExactType<Inherited>()
      : context.getElementForInheritedWidgetOfExactType<Inherited>().widget as Inherited;
  }

  @override
  bool updateShouldNotify(Inherited old) => emotions.length > old.emotions.length;
}

class StampBottomSheet extends StatelessWidget {
  const StampBottomSheet({
    Key key,
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final state = Inherited.of(context, listen: true);
    return Container(
      height: 400.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 50.0, 
              height: 5.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [0, 1, 2].map((item) { 
                final Emotion emotion = new Emotion(emotion: item, date: DateTime.now());
                return GestureDetector(
                  onTap: () async  {
                    Navigator.pop(context);
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(emotion: emotion)
                    );
                    state.addEmotion(item);
                  },
                  child: Image(image: AssetImage(emotion.assetName), height: 110.0)
                );
              }).toList(),
            )
          ),
        ]
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key key,
    @required this.emotion
  }) : assert(emotion != null),
       super(key: key);
  final Emotion emotion;
  
  @override 
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.6,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text(
                'あなたの気持ちを記録しました！',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: AnimatedStamp(emotion: emotion),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedStamp extends StatefulWidget {
  const AnimatedStamp({
    Key key,
    @required this.emotion,
  }): assert(emotion != null),
      super(key: key);
  final Emotion emotion;

  @override
  _AnimatedStampState createState() => _AnimatedStampState();
}

class _AnimatedStampState extends State<AnimatedStamp> {
  var _hasPadding = false;

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 100))
      .then((value) => _handleTimeout());
    new Future.delayed(const Duration(milliseconds: 2000))
      .then((_) => _closeDialog());
  }

  @override 
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.all(_hasPadding ? 0 : 100.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
      child: Image(
        image: AssetImage(widget.emotion.assetName)
      )
    );
  }

  void _handleTimeout() {
    setState(() {
      _hasPadding = !_hasPadding;
    });
  }

  void _closeDialog() {
    Navigator.pop(context);
  }
}

class MemoForm extends StatefulWidget {
  MemoForm({Key key}) : super(key: key);

  @override
  _MemoFormState createState() => _MemoFormState();
}

class _MemoFormState extends State<MemoForm> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: TextField(
        controller: _controller,
        onSubmitted: (String value) async {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thanks!'),
                content: Text ('You typed "$value".'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      )
    );
  }
}