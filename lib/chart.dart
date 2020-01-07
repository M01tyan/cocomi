import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'dart:ui' as ui;

import 'emotion.dart';
import 'home.dart';

// 上部のチャートウィジェット
class EmotionChart extends StatelessWidget {
  const EmotionChart({Key key}) : super(key: key);
  static ScrollController scrollController;

  @override 
  Widget build(BuildContext context) {
    final List<Emotion> emotions = Inherited.of(context, listen: true).emotions;
    final scrollWidth = max(MediaQuery.of(context).size.width, emotions.length.toDouble() * 80);
    return Container(
      color: Colors.deepPurpleAccent[100],
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: CustomPaint(
          painter: ChartPainter(emotions: emotions.reversed.toList()),
          size: Size(scrollWidth, MediaQuery.of(context).size.height)
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  const ChartPainter({this.emotions});
  final List<Emotion> emotions;

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
      _drawCircle(canvas, endEntryOffset, 6.0, paint);
    }
    _drawCircle(canvas, _getEntryOffset(emotions[0], 40.0), 6.0, paint);
  }

  // 感情ポイントを描写
  void _drawCircle(Canvas canvas, Offset point, double radius, Paint paint) {
    final paint = new Paint()
      ..color = Colors.white;
    canvas.drawCircle(point, radius, paint);
  }

  // それぞれの感情描写のOffset
  Offset _getEntryOffset(Emotion emotion, double beginningOfChart) {
    return new Offset(beginningOfChart, drawingHeight/2 - (_calculateHorizontalOffsetStep*(emotion.emotion - 1)));
  }

  @override 
  bool shouldRepaint(ChartPainter old) => emotions.length != old.emotions.length;
}