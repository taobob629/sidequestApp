import 'dart:ui';

import 'package:flutter/material.dart';

/// 矩形高斯模糊效果
class BlurRectWidget extends StatefulWidget {
  final Widget child;

  /// 模糊值
  final double sigmaX;
  final double sigmaY;

  /// 透明度
  final double opacity;

  /// 外边距
  final EdgeInsetsGeometry blurMargin;

  /// 圆角
  final BorderRadius borderRadius;

  const BlurRectWidget(
    this.child,
    this.sigmaX,
    this.sigmaY,
    this.opacity,
    this.blurMargin,
    this.borderRadius,
  );

  @override
  _BlurRectWidgetState createState() => _BlurRectWidgetState();
}

class _BlurRectWidgetState extends State<BlurRectWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.blurMargin,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: this.widget.sigmaX,
            sigmaY: this.widget.sigmaY,
          ),
          child: Container(
            child: Opacity(
              opacity: widget.opacity,
              child: this.widget.child,
            ),
          ),
        ),
      ),
    );
  }
}