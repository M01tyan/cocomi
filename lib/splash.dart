import 'package:flutter/material.dart';

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

  void handleTimeout() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}