import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as newimage;  

import 'emotion.dart';
import 'home.dart';

// 上部のチャートウィジェット
class EmotionChart extends StatefulWidget {
  const EmotionChart({Key key}) : super(key: key);

  @override
  _EmotionChartState createState() => _EmotionChartState();
}

class _EmotionChartState extends State<EmotionChart> {
  var _scrollController = ScrollController();
  var scrollWidth;
  ui.Image happyImage;
  ui.Image normalImage;
  ui.Image sadImage;
  bool isImageloaded = false;

  Future<Null> init() async {
    final ByteData happyData = await rootBundle.load('assets/happy_point.png');
    final ByteData normalData = await rootBundle.load('assets/normal_point.png');
    final ByteData sadData = await rootBundle.load('assets/sad_point.png');
    happyImage = await loadImage(new Uint8List.view(happyData.buffer));
    normalImage = await loadImage(new Uint8List.view(normalData.buffer));
    sadImage = await loadImage(new Uint8List.view(sadData.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override 
  void initState() {
    super.initState();
    init();
    new Future.delayed(const Duration(milliseconds: 300))
      .then((value) => _scrollController.animateTo(_scrollController.offset + scrollWidth/1.4,
        curve: Curves.linear, duration: Duration(milliseconds: 150)
      ));
  }

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
    scrollWidth = max(MediaQuery.of(context).size.width, emotions.length.toDouble() * 80);
    return Container(
      color: Colors.deepPurpleAccent[100],
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: isImageloaded
        ? CustomPaint(
          painter: ChartPainter(
            emotions: emotions.reversed.toList(),
            happyImage: happyImage,
            normalImage: normalImage,
            sadImage: sadImage
          ),
          size: Size(scrollWidth, MediaQuery.of(context).size.height)
        )
        : Text('loading...'),
      ),
    );
  }

  @override 
  void didUpdateWidget(EmotionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollController.animateTo(_scrollController.offset + 100,
      curve: Curves.linear, duration: Duration(milliseconds: 200)
    );
  }

  @override 
  void dispose() {
    super.dispose();
  }
}

class ChartPainter extends CustomPainter {
  ChartPainter({
    this.emotions,
    this.happyImage,
    this.normalImage,
    this.sadImage
  });
  final List<Emotion> emotions;
  final ui.Image happyImage;
  final ui.Image normalImage;
  final ui.Image sadImage;
  static double drawingHeight;

  @override
  void paint(Canvas canvas, Size size) {
    drawingHeight = size.height * 0.8;
    Tuple2<int, int> borderLineValues = _getMinAndMaxValues();
    _drawBottomLabels(canvas, size);
    _drawLines(canvas, borderLineValues.item1, borderLineValues.item2);
  }

  // 縦の最大値と最小値をタプルで返す
  Tuple2<int, int> _getMinAndMaxValues() {
    int maxWeight = 2;
    int minWeight = 0;

    return Tuple2(minWeight, maxWeight);
  }

  // 縦の幅を返す
  double get _calculateHorizontalOffsetStep {
    return (drawingHeight - 30) / (3 - 1);
  }

  // 記録日時のラベル描写
  void _drawBottomLabels(Canvas canvas, Size size) {
    for (int i = emotions.length-1; i >= 1; i--) {
      ui.Paragraph paragraph = _buildParagraphForBottomLabel(emotions[i-1].date, emotions[i].date);
      canvas.drawParagraph(
        paragraph,
        new Offset(i*80.0 + 20, 2.0 + drawingHeight),
      );
    }
    canvas.drawParagraph(
      _buildParagraphForBottomLabel(new DateTime(2019, 1, 1), emotions[0].date),
      new Offset(0.0 + 20, 2.0 + drawingHeight),
    );
  }

  // 日時のラベリング
  ui.Paragraph _buildParagraphForBottomLabel(DateTime preDate, DateTime nowDate) {
    final String printFormat = (preDate.year == nowDate.year && preDate.month == preDate.month && preDate.day == nowDate.day) ? '\n' : 'EE dd\n';
    final Color weekColor = preDate.weekday == 7 ? Colors.pink[400] : (preDate.weekday == 6 ? Colors.lightBlue[300] : Colors.white);
    ui.ParagraphBuilder builder = new ui.ParagraphBuilder(
        new ui.ParagraphStyle(fontSize: 12.0, textAlign: TextAlign.center))
      ..pushStyle(ui.TextStyle(color: weekColor))
      ..addText(DateFormat(printFormat).format(nowDate))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(DateFormat('HH:00').format(nowDate));
    final ui.Paragraph paragraph = builder.build()
      ..layout(new ui.ParagraphConstraints(width: 50.0));
    return paragraph;
  }

  // 感情ラインの描写
  void _drawLines(Canvas canvas, int minLineValue, int maxLineValue) {
    final paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    for (int i = 0; i < emotions.length-1; i++) {
      final beginXOffset = i * 80 + 40.0;
      final endXOffset = (i+1) * 80 + 40.0;
      Path path = Path();
      Offset startEntryOffset = _getEntryOffset(emotions[i], beginXOffset);
      Offset endEntryOffset = _getEntryOffset(emotions[i + 1], endXOffset);
      path.moveTo(startEntryOffset.dx, startEntryOffset.dy);
      path.cubicTo((startEntryOffset.dx + startEntryOffset.dx)/2, startEntryOffset.dy, (startEntryOffset.dx + startEntryOffset.dx)/2, startEntryOffset.dy, startEntryOffset.dx, startEntryOffset.dy);
      path.cubicTo((startEntryOffset.dx + endEntryOffset.dx)/2, startEntryOffset.dy, (startEntryOffset.dx + endEntryOffset.dx)/2, endEntryOffset.dy, endEntryOffset.dx, endEntryOffset.dy);
      canvas.drawPath(path, paint);
      final Offset pointEntryOffset = _getEntryPointOffset(emotions[i+1], endXOffset);
      _drawCircle(canvas, pointEntryOffset, emotions[i+1].emotion, paint);
    }
    _drawCircle(canvas, _getEntryPointOffset(emotions[0], 30.0), emotions[0].emotion, paint);
  }

  // 感情ポイントを描写
  void _drawCircle(Canvas canvas, Offset point, int emotion, Paint paint) async {
    var image;
    switch (emotion) {
      case 0: image = sadImage; break;
      case 1: image = normalImage; break;
      case 2: image = happyImage; break;
    }
    canvas.drawImage(image, point, paint);
  }

  // それぞれの感情描写のOffset
  Offset _getEntryOffset(Emotion emotion, double beginningOfChart) {
    return new Offset(beginningOfChart, drawingHeight/2 - (_calculateHorizontalOffsetStep*(emotion.emotion - 1)));
  }

  Offset _getEntryPointOffset(Emotion emotion, double beginningOfChart) {
    return new Offset(beginningOfChart - 10.0, drawingHeight/2.45 - (_calculateHorizontalOffsetStep*(emotion.emotion - 1)));
  }

  @override 
  bool shouldRepaint(ChartPainter old) => emotions.length != old.emotions.length;
}