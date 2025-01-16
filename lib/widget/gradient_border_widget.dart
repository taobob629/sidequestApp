import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sq_hub_app/config/app_color.dart';

class GradientBorderWidget extends StatelessWidget {
  final double? borderRadius;
  final Widget child;
  final List<Color>? colors;
  final EdgeInsetsGeometry? padding;

  const GradientBorderWidget({
    Key? key,
    required this.child,
    this.colors,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DiagonalGradientBorderPainter(
        borderRadius: borderRadius,
        colors: colors,
      ),
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
        child: child,
      ),
    );
  }
}

class DiagonalGradientBorderPainter extends CustomPainter {
  final double? borderRadius;
  final List<Color>? colors;

  DiagonalGradientBorderPainter({
    this.borderRadius,
    this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors ?? [hexColor('#FFB20E'), hexColor('#5D61EC')],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = RRect.fromLTRBR(
      0, // 左边
      0, // 上边
      size.width, // 右边
      size.height, // 下边
      Radius.circular(borderRadius ?? 40.r),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
