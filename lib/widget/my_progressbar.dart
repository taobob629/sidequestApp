import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sq_hub_app/config/app_color.dart';

class MyProgressbar extends StatelessWidget {
  final double width;
  final double height;
  final Axis? direction;
  final double value;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration? outerDecoration;
  final BoxDecoration? innerDecoration;

  const MyProgressbar({
    Key? key,
    required this.value,
    required this.width,
    required this.height,
    this.direction,
    this.padding,
    this.margin,
    this.outerDecoration,
    this.innerDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVertical = (direction ?? Axis.horizontal) == Axis.vertical;
    final sourcePadding = padding ?? EdgeInsets.zero;
    final fnPadding = EdgeInsets.fromLTRB(
      math.max(0, sourcePadding.left),
      math.max(0, sourcePadding.top),
      math.max(0, sourcePadding.right),
      math.max(0, sourcePadding.bottom),
    );
    final normalizedValue = value.isFinite
        ? value.clamp(0.0, 1.0).toDouble()
        : 0.0;
    final availableWidth = math.max(
      0.0,
      width - fnPadding.left - fnPadding.right,
    );
    final availableHeight = math.max(
      0.0,
      height - fnPadding.top - fnPadding.bottom,
    );
    return Container(
      height: height,
      width: width,
      decoration:
          outerDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: hexColor('37393E'),
          ),
      padding: fnPadding,
      margin: margin,
      alignment: isVertical ? Alignment.bottomCenter : Alignment.centerLeft,
      child: Container(
        width: isVertical ? null : normalizedValue * availableWidth,
        height: isVertical ? normalizedValue * availableHeight : null,
        decoration: innerDecoration ?? const BoxDecoration(),
      ),
    );
  }
}
