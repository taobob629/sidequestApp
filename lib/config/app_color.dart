import 'package:flutter/material.dart';

class AppColor {
  static Color primary = Color(0xFF1B1A1E);
  static Color accent = Color(0xffe33e45);
  static Color iconColorPrimary = Color(0xFFC5C3C6);
  static Color dividerColor = Color(0xFF2D2E3A);

  static Color navBar = Color(0xff0d2432);
  static Color navBarActive = Color(0xffe23e45);
  static Color navBarInactive = Color(0xff8eb2be);
  static const Color background = Color(0xff1B1A1E);
  static const Color itemBg = Color(0xFF262731);
  static const Color yellow = Color(0xFFFFD20E);
  static const Color greyAF = Color(0xFFAFAFAF);
  static const Color whiteGray = Color(0xFFC5C3C6);
  static const Color textWhiteGrey = Color(0xFFC5C3C6);
  static const Color textC5C5 = Color(0xFFc5c5c5);
  static const Color textSubtitle = Color(0xFF959595);
  static const Color textYellow = Color(0xFFFFCB0D);
  static const Color tabBackGround = Color(0xFF292F3F);

  /// 主色 - 渐变
  static List<Color> get buttonGradientBg {
    return [hexColor("#FFD0A920"), hexColor("#FFED5A24")];
  }
}

Color hexColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
