import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Item.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final list = new List<Item>.generate(20, (int index) {
    return Item(emotion: Emotion.happy, date: DateTime.now());
  });
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocomi',
      home: Scaffold(
        appBar: AppBar(
          title: Text('cocomi'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black54,
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                children: <Widget>[
                  for (int i=0; i<list.length; i++)
                    ListItem(item: list[i]),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({this.item});
  final Item item;

  @override 
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy年MM月dd日 kk:mm').format(item.date);
    return Card(
      child: SizedBox(
        height: 80.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.access_time,
                size: 80.0
              ),
              SizedBox(width: 18.0),
              Text('$formattedDate')
            ],
          ),
        ),
      ),
    );
  }
}