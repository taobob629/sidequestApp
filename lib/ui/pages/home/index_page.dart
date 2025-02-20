import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sq_hub_app/utils/navigator_helper.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/utils.dart';
import 'tab_news_page.dart';

class IndexPage extends StatelessWidget {
  final controller = Get.put(IndexPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return TabNewsPage();
  }
}

class IndexPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();

    Get.put(TabNewsPageController());

    initOneSignal();
  }

  void initOneSignal() async {
    String? subId = OneSignal.User.pushSubscription.id;
    if (subId != null && subId.isNotEmpty) {
      StorageManager.setPushToken(subId);
    }

    OneSignal.User.pushSubscription.addObserver((state) {
      StorageManager.setPushToken(OneSignal.User.pushSubscription.id);
    });

    OneSignal.Notifications.addClickListener((event) {
      NavigatorHelper.notificationJump(event.notification.additionalData);
      OneSignal.Notifications.clearAll();
      FlutterAppBadger.isAppBadgeSupported().then((value) {
        flog(value, 'onTotalUnreadMessageCountChanged');
        FlutterAppBadger.removeBadge();
      });
    });
    OneSignal.Notifications.addForegroundWillDisplayListener(
        (event) => flog("收到了消息了，弹出通知"));
  }
}
