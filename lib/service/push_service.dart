/*
  push_service
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:convert';

import 'package:tim_ui_kit_push_plugin/tim_ui_kit_push_plugin.dart';
import 'package:wy/utils/utils.dart';

class ChannelPush {
  static final TimUiKitPushPlugin cPush = TimUiKitPushPlugin(
    isUseGoogleFCM: true,
  );

  static init(PushClickAction pushClickAction) async {
    cPush.init(
      pushClickAction: pushClickAction,
      appInfo: PushConfig.appInfo,
    );

    // create new notification channel
    cPush.createNotificationChannel(
        channelId: "new_message",
        channelName: "chat_message",
        channelDescription:
            "The notification for chat message from Tencent Cloud IM");

    // require the permission for notification
    cPush.requireNotificationPermission();
  }

  static clearAllNotification() {
    return cPush.clearAllNotification();
  }

  static Future<String> getDeviceToken() async {
    return cPush.getDevicePushToken();
  }

  static requestPermission() {
    cPush.requireNotificationPermission();
  }

  static Future<bool> uploadToken(PushAppInfo appInfo) async {
    return cPush.uploadToken(appInfo);
  }
}

class PushConfig {
  //These `Business ID` can be found in the offline push section for each manufacturers,
  // on the main page of console from Tencent Cloud IM.

  // Business ID for HUAWEI
  static const HWPushBuzID = 0;

  // Business ID for XiaoMi
  static const XMPushBuzID = 0;

  // APP Info of XiaoMi
  static const String XMPushAPPID = "";
  static const String XMPushAPPKEY = "";

  // Business ID for Meizu
  static const MZPushBuzID = 0;

  // APP Info of Meizu
  static const String MZPushAPPID = "";
  static const String MZPushAPPKEY = "";

  // Business ID for Vivo
  static const VIVOPushBuzID = 0;

  // Business ID for Google FCM
  static const GOOGLEFCMPushBuzID = 40635894328;

  // Business ID for OPPO
  static const OPPOPushBuzID = 0;

  // APP Info of OPPO
  static const String OPPOPushAPPKEY = "";
  static const String OPPOPushAPPSECRET = "";
  static const String OPPOPushAPPID = "";
  static const String OPPOChannelID = "new_message";

  // Business ID for Apple APNS
  static const ApplePushDevBuzID = 15142;
  static const ApplePushDisBuzID = 15143;

  static final PushAppInfo appInfo = PushAppInfo(
      hw_buz_id: PushConfig.HWPushBuzID,
      mi_app_id: PushConfig.XMPushAPPID,
      mi_app_key: PushConfig.XMPushAPPKEY,
      mi_buz_id: PushConfig.XMPushBuzID,
      mz_app_id: PushConfig.MZPushAPPID,
      mz_app_key: PushConfig.MZPushAPPKEY,
      mz_buz_id: PushConfig.MZPushBuzID,
      vivo_buz_id: PushConfig.VIVOPushBuzID,
      oppo_app_key: PushConfig.OPPOPushAPPKEY,
      oppo_app_secret: PushConfig.OPPOPushAPPSECRET,
      oppo_buz_id: PushConfig.OPPOPushBuzID,
      oppo_app_id: PushConfig.OPPOPushAPPID,
      google_buz_id: PushConfig.GOOGLEFCMPushBuzID,
      apple_buz_id: bool.fromEnvironment("dart.vm.product")
          ? ApplePushDisBuzID
          : ApplePushDevBuzID);
}
