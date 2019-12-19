import 'package:flutter/material.dart';
import 'Emotion.dart';
import 'dart:math';

import 'home.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // 感情リストをランダムで作成
  final emotions = List<Emotion>.generate(25, (int index) {
    final _random = new Random();
    return Emotion(emotion: _random.nextInt(3), date: DateTime.now().subtract(new Duration(days: index*3)));
  });

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocomi',
      // テーマの設定
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(
            fontSize: 25.0, 
            fontWeight: FontWeight.w700,
          ),
          body2: TextStyle(
            fontSize: 55.0, 
            fontWeight: FontWeight.bold, 
            height: 1, 
            color: Colors.grey[700]
          ),
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('cocomi'),
          backgroundColor: Colors.amber[700],
        ),
        body: Home(emotions: emotions)
      ),
    );
  }
}