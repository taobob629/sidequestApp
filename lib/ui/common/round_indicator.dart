
import 'package:flutter/material.dart';

class RoundIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const RoundIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.radius = 10,
    this.color = Colors.white
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  final double radius;

  final Color color;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is RoundIndicator) {
      return RoundIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is RoundIndicator) {
      return RoundIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([ VoidCallback? onChanged ]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    double wantWidth = 15;
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(cw - wantWidth / 2,
      indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  final RoundIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    Rect rect = offset & configuration.size!;
    //rect = Rect.fromLTWH(rect.left-15, rect.top-10, rect.width+30, rect.height+16);
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration._indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius));
    final Paint paint = Paint() ..style = PaintingStyle.fill ..color = decoration.color;
    canvas.drawRRect(rRect, paint);
  }
}