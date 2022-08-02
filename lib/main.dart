
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/config/https_overrides.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpsOverrides();

  await AppConfig.init("default");
  runApp(await AppConfig.createApp());
}
