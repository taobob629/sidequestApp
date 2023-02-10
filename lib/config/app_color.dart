import 'package:flutter/material.dart';

class AppColor {
  static Color primary = Color(0xff171525);
  static Color accent = Color(0xffe33e45);

  static Color navBar = Color(0xff0d2432);
  static Color navBarActive = Color(0xffe23e45);
  static Color navBarInactive = Color(0xff8eb2be);
  static const Color background = Color(0xff1B1A1E);
  static const Color itemBg = Color(0xff282640);
  static const Color yellow = Color(0xFFFFD20E);
  static const Color greyAF = Color(0xFFAFAFAF);
  static const Color whiteGray = Color(0xFFC5C3C6);
  static const Color textWhiteGrey = Color(0xFFC5C3C6);

  /// 主色 - 渐变
  static List<Color> get buttonGradientBg {
    return [hexColor("#4596FE"), hexColor("#78ADFF")];
  }
}

Color hexColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
