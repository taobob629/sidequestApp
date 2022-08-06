import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/config/https_overrides.dart';
import 'package:wy/widget/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpsOverrides();

  await AppConfig.init("default");
  runApp(await AppConfig.createApp());

  ///路由配置
  RouteState.isMove = true;
  RouteState.setOffsetState();
  RouteState.animationTime = 250;
  RouteState.routeAnimationTime = 400;
  RouteState.animationCurve = const Cubic(0.35, 1.0, 0.04, 1.0);
  RouteState.animationReverseCurve = const Cubic(0.65, 0.0, 0.96, 0.0);
}
