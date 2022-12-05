/*
  Translations
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:ui';

import 'package:get/get.dart';
import 'package:wy/config/lang/zh_CN.dart';

import 'en_US.dart';
var languages=[ const Locale('zh', 'CN'),const Locale('en', 'US')];
class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}
