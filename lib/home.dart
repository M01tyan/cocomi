import 'package:flutter/material.dart';
import 'dart:math';

import 'emotion.dart';
import 'list.dart';
import 'chart.dart';

class ParentScaffold extends StatefulWidget {
  @override
  _ParentScaffoldState createState() => _ParentScaffoldState();
}

class _ParentScaffoldState extends State<ParentScaffold> {
  final emotions = List<Emotion>.generate(25, (int index) {
    final _random = new Random();
    return Emotion(emotion: _random.nextInt(3), date: DateTime.now().subtract(new Duration(days: index)));
  });

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cocomi'),
        backgroundColor: Colors.amber[700],
      ),
      body: Home(emotions: emotions),
    );
  }

  void addEmotion(Emotion emotion) {
    setState(() {
      emotions.add(emotion);
    });
  }
}

class Home extends StatelessWidget {
  Home({
    @required this.emotions
  }) : assert(emotions != null);
  final List<Emotion> emotions;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/home'));
        },
        child: Column(
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
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              backgroundColor: Colors.white70,
              builder: (BuildContext builder) => Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image(image: AssetImage('assets/sad.png'), height: 110.0)
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image(image: AssetImage('assets/normal.png'), height: 110.0)
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image(image: AssetImage('assets/happy.png'), height: 110.0)
                    ),
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