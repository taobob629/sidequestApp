import 'package:flutter/material.dart';
import 'package:flutter_ume_plus/flutter_ume_plus.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sq_hub_app/utils/dev_network_inspector.dart';
import 'package:sq_hub_app/utils/platform_utils.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';
import 'package:sq_hub_app/utils/utils.dart';
import 'package:sq_hub_app/widget/route.dart';

import 'api/wy_http.dart';
import 'config/app_config.dart';
import 'config/https_overrides.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = HttpsOverrides();

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize("2e18b91f-f1f0-4faa-85fd-13b564ae7ad9");
  OneSignal.initialize("d476c63a-6ddb-440c-868a-4345808db89f");
  OneSignal.Notifications.requestPermission(true);

  await getAppPackageInfo();
  await AppConfig.init("default");
  var app = await AppConfig.createApp();

  String env = StorageManager.getEnv();

  ///图片缓存大小
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
  if (env.contains("dev") || env.contains("test")) {
    // PluginManager.instance // 注册插件
        // .register(DioInspector(dio: http));
    PluginManager.instance.register(DevNetworkInspector(dio: http));
    runApp(UMEWidget(child: app, enable: true));
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
