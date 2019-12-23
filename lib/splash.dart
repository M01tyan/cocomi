import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'emotion.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 3))
      .then((value) => handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/normal.png'), height: 80.0),
            Text('cocomi', style: Theme.of(context).textTheme.title,),
          ],
        ),
      )
    );
  }

  void handleTimeout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String store_emotions = prefs.getString('emotions') ?? "";
    List<Emotion> emotions = (jsonDecode(store_emotions) as List).map((json) => Emotion.fromJson(json)).toList();
    // print(emotions);
    Navigator.of(context).pushReplacementNamed('/home', arguments: emotions);
  }
}