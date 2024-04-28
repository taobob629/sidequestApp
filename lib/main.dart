import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sq_hub_app/utils/platform_utils.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';

import 'api/wy_http.dart';
import 'config/app_config.dart';
import 'config/https_overrides.dart';

PackageInfo? packageInfo;
//var deviceInfo;
Future<void> getAppPackageInfo() async {
  packageInfo = await PlatformUtils.getAppPackageInfo();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = HttpsOverrides();

  await getAppPackageInfo();
  await AppConfig.init("default");
  var app = await AppConfig.createApp();

  String env = StorageManager.getEnv();

  ///图片缓存大小
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
  runApp(app);
}
