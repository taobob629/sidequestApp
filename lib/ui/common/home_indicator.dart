import 'package:flutter/material.dart';

class HomeIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const HomeIndicator(
      {this.borderSide = const BorderSide(width: 4.0, color: Colors.white),
      this.insets = EdgeInsets.zero,
      this.colors = const []});

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;
  final List<Color> colors;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is HomeIndicator) {
      return HomeIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is HomeIndicator) {
      return HomeIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged, colors);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    double wantWidth = 15;
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
        cw - wantWidth / 2, indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged, this.colors) : super(onChanged);

  final HomeIndicator decoration;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.round;
    if (colors.isNotEmpty) {
      var gradient = LinearGradient(
        colors: colors,
      );
      paint.shader = gradient.createShader(indicator);
    }
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
