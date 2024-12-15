import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_color.dart';
import 'animation_progress_bar.dart';

class WithIconProgressBar extends StatelessWidget {
  Widget icon;
  final double currentValue;
  final double size;
  final Gradient? progressGradient;
  final Color backgroundColor;
  final double outBoxHeight;
  final double outBoxWidth;

  WithIconProgressBar({
    required this.icon,
    required this.currentValue,
    required this.size,
    this.progressGradient,
    required this.backgroundColor,
    required this.outBoxHeight,
    required this.outBoxWidth,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: outBoxHeight,
        child: Stack(
          children: [
            Center(
              child: FAProgressBar(
                size: size,
                currentValue: currentValue,
                progressGradient: progressGradient,
                backgroundColor: backgroundColor,
              ),
            ),
            // 这下面的需要自己一步一步调试的
            Positioned(
              left: (((currentValue * outBoxWidth) / 100) - 20) > 0
                  ? ((currentValue * outBoxWidth) / 100) - 18.w
                  : 0,
              top: 0,
              child: icon,
            )
          ],
        ),
      );
}
