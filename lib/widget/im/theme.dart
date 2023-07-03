import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';


enum ThemeType { solemn, brisk, bright, fantasy }

class DefTheme {
  static ThemeType themeTypeFromString(String str) {
    return ThemeType.values
        .firstWhere((e) => e.toString() == str, orElse: () => ThemeType.brisk);
  }

  static final Map<ThemeType, TUITheme> defaultTheme = {
    ThemeType.solemn: const TUITheme(
      primaryColor: Color(0xFF00449E),
      lightPrimaryColor: Color(0xFF3371CD),
    ),
    ThemeType.brisk: const TUITheme(
      primaryColor: Color(0xFF147AFF),
      lightPrimaryColor: Color(0xFFC0E1FF),
    ),
    ThemeType.bright: const TUITheme(
      primaryColor: Color(0xFFF38787),
      lightPrimaryColor: Color(0xFFFAE1B6),
    ),
    ThemeType.fantasy: const TUITheme(
      primaryColor: Color(0xFF8783F0),
      lightPrimaryColor: Color(0xFFAEB6F4),
    ),
  };

  static final Map<ThemeType, String> defaultThemeName = {
    ThemeType.solemn: TIM_t("深沉"),
    ThemeType.brisk: TIM_t("轻快"),
    ThemeType.bright: TIM_t("明媚"),
    ThemeType.fantasy: TIM_t("梦幻")
  };
}

class DefaultThemeData with ChangeNotifier {
  ThemeType _currentThemeType = ThemeType.brisk;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  TUITheme _theme = CommonColor.defaultTheme;

  TUITheme get theme {
    return _theme;
  }

  set theme(TUITheme theme) {
    _theme = theme;
    notifyListeners();
  }

  ThemeType get currentThemeType => _currentThemeType;

  set currentThemeType(ThemeType type) {
    _currentThemeType = type;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((prefs) {
      prefs.setString("themeType", type.toString());
    });
    _coreInstance.setTheme(theme: DefTheme.defaultTheme[type]!);
    theme = DefTheme.defaultTheme[type]!;
    notifyListeners();
  }
}
