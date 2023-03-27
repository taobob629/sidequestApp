import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 旋转小球
class RotatingBallWidget extends StatefulWidget {
  int marginX;
  int marginY;
  int seconds;
  String imgSrc;

  RotatingBallWidget({
    required this.marginX,
    required this.marginY,
    required this.seconds,
    required this.imgSrc,
  });

  @override
  State<RotatingBallWidget> createState() => _RotatingBallState();
}

class _RotatingBallState extends State<RotatingBallWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double x = math.sin(_animation.value);
        final double y = math.cos(_animation.value);

        return Transform.translate(
          offset: Offset(x * widget.marginX, y * widget.marginY),
          child: child,
        );
      },
      child: Center(
        child: SizedBox(
          width: 18.w,
          height: 18.w,
          child: Image.asset(
            widget.imgSrc,
          ),
        ),
      ),
    );
  }
}
