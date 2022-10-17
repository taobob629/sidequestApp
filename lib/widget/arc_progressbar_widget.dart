/*
  arc_progressbar
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:math' as Math;
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:wy/utils/utils.dart';

class ArcProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double min;
  final double max;
  final double progress;

  ArcProgressBar({
    Key? key,
    this.width = 180,
    this.height = 180,
    this.min = 0,
    this.max = 100,
    this.progress = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder(
    tween: Tween(begin: 0.0, end: this.progress),
    duration: const Duration(seconds: 1),
      curve:Curves.fastOutSlowIn,
    builder: (context,double value,widget){
    return AspectRatio(
        aspectRatio: 1,
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size(width, height),
            painter: _ArcProgressBarPainter(10, value, min: min, max: max),
          ),
        ));
  },);
}

class _ArcProgressBarPainter extends CustomPainter {
  Paint _paint = Paint();

  late double _strokeSize;

  double get _margin => _strokeSize / 2;

  late double progress = 0;

  late double min;

  late double max;
  final double endRadius = 290;
  final double startRadius = 125;

  _ArcProgressBarPainter(double strokeSize, this.progress,
      {this.min = 0, this.max = 100}) {
    this._strokeSize = strokeSize;
    if (progress < min) progress = 0;
    if (progress > max) progress = max;
    if (min <= 0) min = 0;
    if (max <= min) max = 100;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double cx = radius;
    double cy = radius;
    _drawProgressArc(canvas, size);
    _drawArcProgressPoint(canvas, cx, cy, radius);
  }

  void _drawProgressArc(Canvas canvas, Size size) {
    _paint
      ..isAntiAlias = true
      ..color = Color.fromRGBO(82, 80, 96, 1)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeSize;
    canvas.drawArc(
        Rect.fromLTWH(_margin, _margin, size.width - _strokeSize,
            size.width - _strokeSize),
        _toRadius(startRadius),
        _toRadius(endRadius),
        false,
        _paint);
    if (progress == 0) {
      return;
    }
    _paint..strokeWidth = _strokeSize - 1;
    var gradient = LinearGradient(
      colors: [
        Color.fromRGBO(255, 132, 96, 1),
        Color.fromRGBO(255, 183, 59, 1)
      ],
    );
    if (progress > 0) {
      _paint.shader = gradient
          .createShader(Rect.fromLTWH(0, 0, size.width / 2, size.width / 2));
      canvas.drawArc(
          Rect.fromLTWH(_margin, _margin, size.width - _strokeSize,
              size.width - _strokeSize),
          _toRadius(startRadius),
          progress * _toRadius(endRadius / (max - min)),
          false,
          _paint);
    }
  }

  void _drawArcProgressPoint(
      Canvas canvas, double cx, double cy, double radius) {
    _paint.strokeWidth = 1;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(startRadius));
    canvas.translate(-cx, -cy);
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(-startRadius));
    canvas.translate(-cx, -cy);
    canvas.restore();
  }

  void _drawArcPointLine(
      UI.Canvas canvas, double cx, double cy, double radius) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(startRadius));
    canvas.translate(-cx, -cy);
    _paint
      ..color = Colors.amber
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;
    double degree = _toRadius(endRadius / (max - min)) * progress;
    double x = cx + radius * 3 / 5 * Math.cos(degree);
    double y = cy + radius * 3 / 5 * Math.sin(degree);
    canvas.drawLine(Offset(cx, cy), Offset(x, y), _paint);
    _paint.color = Colors.amber;
    canvas.drawCircle(Offset(cx, cy), 12, _paint);
    canvas.restore();
  }

  double _toRadius(double degree) => degree * Math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
