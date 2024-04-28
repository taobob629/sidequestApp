/*
  Translations
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:ui';

import 'package:get/get.dart';
import 'package:sq_hub_app/config/lang/zh_CN.dart';

import 'en_US.dart';

const CHINA = const Locale('zh', 'CN');
const ENGLISH = const Locale('en', 'US');
var languages = [CHINA, ENGLISH];

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}
