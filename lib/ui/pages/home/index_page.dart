import 'package:flutter/material.dart';
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
    var onesignalId = await OneSignal.User.getOnesignalId();
    if (onesignalId != null) {
      StorageManager.setPushToken(onesignalId);
    }

    OneSignal.User.addObserver((state) {
      StorageManager.setPushToken(state.current.onesignalId);
    });

    OneSignal.Notifications.addClickListener((event) =>
        NavigatorHelper.notificationJump(event.notification.additionalData));
    OneSignal.Notifications.addForegroundWillDisplayListener(
        (event) => flog("收到了消息了，弹出通知"));
    OneSignal.InAppMessages.addClickListener((event) {
      flog("event");
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
  }
}
