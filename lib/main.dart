import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sq_hub_app/utils/platform_utils.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';
import 'package:sq_hub_app/utils/utils.dart';
import 'package:sq_hub_app/widget/route.dart';

import 'api/wy_http.dart';
import 'config/app_config.dart';
import 'config/https_overrides.dart';
import 'firebase_options.dart';

PackageInfo? packageInfo;
//var deviceInfo;
Future<void> getAppPackageInfo() async {
  packageInfo = await PlatformUtils.getAppPackageInfo();
  // deviceInfo = await PlatformUtils.getDeviceInfo();
  // flog(deviceInfo['manufacturer'], 'deviceInfo');
  flog(packageInfo!.appName, 'packageInfo');
  flog(packageInfo!.buildNumber, 'packageInfo');
  flog(packageInfo!.buildSignature, 'packageInfo');
  flog(packageInfo!.packageName, 'packageInfo');
  flog(packageInfo!.version, 'packageInfo');
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = HttpsOverrides();

  await getAppPackageInfo();
  await AppConfig.init("default");
  var app = await AppConfig.createApp();

  String env = StorageManager.getEnv();

  ///图片缓存大小
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
  if (env.contains("dev") || env.contains("test")) {
    PluginManager.instance // 注册插件
      .register(DioInspector(dio: http));
    runApp(UMEWidget(enable: true, child: app));
  } else {
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
