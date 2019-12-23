import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'emotion.dart';
import 'list.dart';
import 'chart.dart';

class ParentScaffold extends StatelessWidget {
  const ParentScaffold({Key key}) : super(key: key);

  Future<List<Emotion>> _getEmotions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String store_emotions = prefs.getString('emotions') ?? "";
    List<Emotion> emotions = (jsonDecode(store_emotions) as List).map((json) => Emotion.fromJson(json)).toList();
    return emotions;
  }

  @override 
  Widget build(BuildContext context) {
    // final emotions = ModalRoute.of(context).settings.arguments;
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

  @override
  void initState() {
    setState(() {
      emotions = widget.emotions;
    });
    super.initState();
  }

  void _addEmotion(Emotion emotion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emotions.insert(0, emotion);
    String jsonEmotions = jsonEncode(emotions);
    await prefs.setString('emotions', jsonEmotions);
    setState(() {
      emotions = emotions;
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Inherited(
      emotions: emotions,
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
            onPressed: () {
              showBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext builder) => StampBottomSheet(
                  onPress: (Emotion emotion) => _addEmotion(emotion),
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
      ),
    );
  }
}

class Inherited extends InheritedWidget {
  const Inherited({
    Key key,
    @required this.emotions,
    @required Widget child,
  }) : assert(emotions != null),
       assert(child != null),
       super(key: key, child: child);

  final List<Emotion> emotions;

  static Inherited of(
    BuildContext context, {
    @required bool listen,
  }) {
    return listen
      ? context.dependOnInheritedWidgetOfExactType<Inherited>()
      : context.getElementForInheritedWidgetOfExactType<Inherited>().widget as Inherited;
  }

  @override
  bool updateShouldNotify(Inherited old) => emotions != old.emotions;
}

class StampBottomSheet extends StatelessWidget {
  const StampBottomSheet({
    Key key,
    @required this.onPress
  }) : assert(onPress != null),
       super(key: key);
  final Function onPress;

  @override 
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
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
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(emotion: emotion)
                    );
                    onPress(emotion);
                  },
                  child: Image(image: AssetImage(emotion.assetName), height: 110.0)
                );
              }).toList(),
            ),
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