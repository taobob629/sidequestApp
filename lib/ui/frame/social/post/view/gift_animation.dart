import 'dart:math';

import 'package:flutter/material.dart';

void showHearts(BuildContext context, Offset offset) {
  RenderBox canvas = context.findRenderObject() as RenderBox;
  Offset canvasOffset = canvas.localToGlobal(Offset.zero);
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  double randomX = canvasOffset.dx + offset.dx; //+ Random().nextInt((width ~/ 2).round());
  double randomY = offset.dy; //+ Random().nextInt((height ~/ 2).round());

  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      left: randomX,
      top: randomY,
      width: width,
      height: height,
      child: Heart(),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  Future.delayed(
    Duration(seconds: 2),
    () => overlayEntry.remove(),
  );
}

class Heart extends StatefulWidget {
  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with TickerProviderStateMixin {
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: 30,
      end: 60,
    ).animate(_animationController);

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
                top: -_sizeAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: _sizeAnimation.value,
                        width: _sizeAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "+1",
                        style: TextStyle(color: Colors.red, fontSize: 8),
                      )
                    ],
                  ),
                ));
          },
        ),
      ],
    );
  }
}
