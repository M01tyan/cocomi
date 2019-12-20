import 'package:flutter/material.dart';
import 'dart:math';

import 'emotion.dart';
import 'list.dart';
import 'chart.dart';

class ParentScaffold extends StatelessWidget {
  const ParentScaffold({Key key}) : super(key: key);
  // final emotions = List<Emotion>.generate(25, (int index) {
  //   final _random = new Random();
  //   return Emotion(emotion: _random.nextInt(3), date: DateTime.now().subtract(new Duration(days: index)));
  // });

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cocomi'),
        backgroundColor: Colors.amber[700],
        leading: null,
      ),
      body: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var emotions;

  @override
  void initState() {
    super.initState();
    setState(() {
      emotions = List<Emotion>.generate(25, (int index) {
        final _random = new Random();
        return Emotion(emotion: _random.nextInt(3), date: DateTime.now().subtract(new Duration(days: index+1)));
      });
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
                builder: (BuildContext builder) => Container(
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
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  emotions.insert(0, new Emotion(emotion: 0, date: DateTime.now()));
                                });
                                Navigator.pop(context);
                              },
                              child: Image(image: AssetImage('assets/sad.png'), height: 110.0)
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  emotions.insert(0, new Emotion(emotion: 1, date: DateTime.now()));
                                });
                                Navigator.pop(context);
                              },
                              child: Image(image: AssetImage('assets/normal.png'), height: 110.0)
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  emotions.insert(0, new Emotion(emotion: 2, date: DateTime.now()));
                                });
                                Navigator.pop(context);
                              },
                              child: Image(image: AssetImage('assets/happy.png'), height: 110.0)
                            ),
                          ],
                        ),
                      ),
                    ]
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
      ),
    );
  }
}

class Inherited extends InheritedWidget {
  const Inherited({
    Key key,
    @required this.emotions,
    @required Widget child,
  }) : super(key: key, child: child);

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