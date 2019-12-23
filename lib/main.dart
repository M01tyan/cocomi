import 'package:flutter/material.dart';
import 'dart:math';

import 'home.dart';
import 'splash.dart';
import 'emotion.dart';

main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  // 感情リストをランダムで作成
  final emotions = List<Emotion>.generate(25, (int index) {
    final _random = new Random();
    return Emotion(emotion: _random.nextInt(3), date: DateTime.now().subtract(new Duration(days: index)));
  });

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocomi',
      // ルートの設定
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => Splash(),
        '/home': (context) => ParentScaffold(),
      },
      // onGenerateRoute: (RouteSettings settings) {
      //   var routes = <String, WidgetBuilder> {
      //     "/": (context) => Splash(),
      //     "/home": (context) => ParentScaffold(settings.arguments),
      //   };
      //   WidgetBuilder builder = routes[settings.name];
      //   return MaterialPageRoute(builder: (context) => builder(context));
      // },
      // テーマの設定
      theme: ThemeData(
        textTheme: TextTheme(
          title: const TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.w800
          ),
          body1: const TextStyle(
            fontSize: 25.0, 
            fontWeight: FontWeight.w700,
          ),
          body2: TextStyle(
            fontSize: 55.0, 
            fontWeight: FontWeight.bold, 
            height: 1, 
            color: Colors.grey[700],
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}