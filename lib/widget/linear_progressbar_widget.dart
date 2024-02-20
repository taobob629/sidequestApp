/*
  arc_progressbar
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';

class LinearProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double min;
  final double max;
  final double progress;
  final Color? bgColor;
  final Color? progressStartColor;
  final Color? progressEndColor;

  LinearProgressBar({
    Key? key,
    this.width = 180,
    this.height = 50,
    this.min = 0,
    this.max = 100,
    this.progress = 0,
    this.bgColor,
    this.progressStartColor,
    this.progressEndColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: this.progress),
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        builder: (context, double value, widget) {
          return RepaintBoundary(
            child: CustomPaint(
              size: Size(width, height),
              painter: ProgressPaint(
                progress: progress,
                width: width,
                height: height,
                bgColor: bgColor,
                progressStartColor: progressStartColor,
                progressEndColor: progressEndColor,
              ),
            ),
          );
        },
      );
}

class ProgressPaint extends CustomPainter {
  var drawPaint = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;
  var bgPaint = Paint();
  final double progress;
  final double width;
  final double height;
  final Color? bgColor;
  final Color? progressStartColor;
  final Color? progressEndColor;

  ProgressPaint({
    required this.progress,
    required this.width,
    required this.height,
    this.bgColor,
    this.progressStartColor,
    this.progressEndColor,
  }) {
    bgPaint.strokeCap = StrokeCap.round;
    bgPaint.style = PaintingStyle.stroke;
    bgPaint.color = bgColor ?? Color(0xFF313139);
    bgPaint.isAntiAlias = true;
    gradient = LinearGradient(
      colors: [
        progressStartColor ?? Color(0xFFED5A24),
        progressEndColor ?? Color(0xFFCFAB21)
      ],
    );
  }

  var gradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress > 0) {
      drawPaint.shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width / 2, height));
    }
    drawPaint.strokeWidth = height;
    bgPaint.strokeWidth = height;
    canvas.drawLine(Offset(10, height), Offset(width, height), bgPaint);
    var progressVal = (width - 10) * progress / 100;
    canvas.drawLine(Offset(10, height), Offset(progressVal, height), drawPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
