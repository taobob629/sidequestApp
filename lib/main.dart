
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/config/https_overrides.dart';
import 'package:wy/utils/platform_utils.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/route.dart';

import 'api/wy_http.dart';

PackageInfo? packageInfo;
Future<void> getAppPackageInfo() async {
  packageInfo = await PlatformUtils.getAppPackageInfo();
  flog(packageInfo!.appName, 'packageInfo');
  flog(packageInfo!.buildNumber, 'packageInfo');
  flog(packageInfo!.buildSignature, 'packageInfo');
  flog(packageInfo!.packageName, 'packageInfo');
  flog(packageInfo!.version, 'packageInfo');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpsOverrides();

  await getAppPackageInfo();
  await AppConfig.init("default");
  var app = await AppConfig.createApp();

  String env = StorageManager.getEnv();
  if(env.contains("dev") || env.contains("test")) {
    PluginManager.instance // 注册插件
      ..register(DioInspector(dio: http));
    runApp(UMEWidget(child: app, enable: true));
  }else{
    runApp(app);
  }



  ///路由配置
  RouteState.isMove = true;
  RouteState.setOffsetState();
  RouteState.animationTime = 250;
  RouteState.routeAnimationTime = 400;
  RouteState.animationCurve = const Cubic(0.35, 1.0, 0.04, 1.0);
  RouteState.animationReverseCurve = const Cubic(0.65, 0.0, 0.96, 0.0);
}
