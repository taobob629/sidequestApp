import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/firebase_options.dart';
import 'package:wy/service/location_service.dart';
import 'package:wy/service/push_service.dart';
import 'package:wy/ui/common/dialog_pop_ad.dart';
import 'package:wy/ui/common/dialog_upgrade.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/events/events_page.dart';
import 'package:wy/ui/frame/tab_button.dart';
import 'package:wy/ui/im/play_page.dart';
import 'package:wy/ui/index/Index_page.dart';
import 'package:wy/ui/playwith/play_with_page.dart';
import 'package:wy/ui/profile/notification/notification_page.dart';
import 'package:wy/ui/profile/profile_page.dart';
import 'package:wy/ui/shop/shop_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wy/utils/utils.dart';

class MainPage extends GetView<MainPageController> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          controller.controller.jumpToPage(0);
          controller.updateCurrentIndex(0);
        }
        if (controller.lastPopTime == null ||
            DateTime.now().difference(controller.lastPopTime!) >
                Duration(seconds: 2)) {
          controller.lastPopTime = DateTime.now();
          EasyLoading.showInfo("Press again to exit".tr,
              duration: Duration(seconds: 2));
        } else {
          controller.lastPopTime = DateTime.now();
          // 退出app
          // await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          exit(0);
        }
        return false;
      },
      child: AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
              backgroundColor: AppColor.background,
              body: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: padding.bottom + 50,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller.controller,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return IndexPage();
                          case 1:
                            return EventsPage();
                          case 2:
                            return PlayWithPage();
                          case 3:
                            return ShopPage();
                          case 4:
                            return ProfilePage();
                          default:
                            return IndexPage();
                        }
                      },
                    ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: padding.bottom + 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      )),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: padding.bottom,
                      height: 80,
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TabButton(
                                index: 0,
                                currentIndex: controller.currentIndex.value,
                                iconName: "game",
                                title: "Home".tr,
                                colors: [Color(0xffb991ff), Color(0xff1817FF)],
                                onTap: () {
                                  controller.controller.jumpToPage(0);
                                  controller.updateCurrentIndex(0);
                                }),
                            TabButton(
                                index: 1,
                                currentIndex: controller.currentIndex.value,
                                iconName: "events",
                                title: "Activities".tr,
                                colors: [Color(0xffFFD189), Color(0xffFF3617)],
                                onTap: () {
                                  controller.controller.jumpToPage(1);
                                  controller.updateCurrentIndex(1);
                                }),
                            Badge(
                              shape: BadgeShape.circle,
                              badgeColor: Colors.red,
                              position: BadgePosition(top: 3, end: 5),
                              animationType: BadgeAnimationType.fade,
                              animationDuration:
                                  const Duration(microseconds: 500),
                              showBadge:
                                  userController.unreadMsgCount.value > 0,
                              badgeContent: Text(
                                "${userController.unreadMsgCount.value}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              ignorePointer: true,
                              child: TabButton(
                                  index: 2,
                                  currentIndex: controller.currentIndex.value,
                                  iconName: "play",
                                  title: "SideKick".tr,
                                  colors: [
                                    Color(0xffe7e439),
                                    Color(0xff6c6301)
                                  ],
                                  onTap: () {
                                    controller.controller.jumpToPage(2);
                                    controller.updateCurrentIndex(2);
                                  }),
                            ),
                            TabButton(
                                index: 3,
                                currentIndex: controller.currentIndex.value,
                                iconName: "shop",
                                title: "Shop".tr,
                                //colors: [Color(0xff4cd8fa), Color(0xff01819c)],
                                colors: [Color(0xfffa7f85), Color(0xffb6262c)],
                                onTap: () {
                                  controller.controller.jumpToPage(3);
                                  controller.updateCurrentIndex(3);
                                }),
                            TabButton(
                                index: 4,
                                currentIndex: controller.currentIndex.value,
                                iconName: "user",
                                title: "Profile".tr,
                                colors: [Color(0xff99c6fa), Color(0xff727DFF)],
                                onTap: () {
                                  userController.updateInfo();
                                  controller.controller.jumpToPage(4);
                                  controller.updateCurrentIndex(4);
                                }),
                          ],
                        );
                      }))
                ],
              ))),
    );
  }
}

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainPageController>(MainPageController());
  }
}

class MainPageController extends FullLifeCycleController
    with FullLifeCycleMixin {
  late PageController controller;
  var currentIndex = 2.obs;

  bool checking = false;

  DateTime? lastPopTime;

  late Timer _timer;

  initOfflinePush() async {
    await ChannelPush.init(handleClickNotification);
    uploadOfflinePushInfoToken();
  }

  uploadOfflinePushInfoToken() async {
    if (!kIsWeb) {
      ChannelPush.requestPermission();
      Future.delayed(const Duration(seconds: 5), () async {
        final bool isUploadSuccess =
            await ChannelPush.uploadToken(PushConfig.appInfo);
        // ignore: avoid_print
        print("Push token upload result: $isUploadSuccess");
      });
    }
  }

  ///处理推送点击事件
  void handleClickNotification(Map<String, dynamic> msg) async {
    String ext = msg['ext'] ?? "";
    Map<String, dynamic> extMsp = jsonDecode(ext);
    String convId = extMsp["conversationID"] ?? "";

    // 【TUIKit】若当前的会话与要跳转至的会话一致，则不跳转。
    // final currentConvID = _timuiKitChatController.getCurrentConversation();
    // if(currentConvID == convId.split("_")[1]){
    //   return;
    // }
    //  final targetConversationRes = await TencentImSDKPlugin.v2TIMManager
    //     .getConversationManager()
    //     .getConversation(conversationID: convId);
    //  V2TimConversation? targetConversation = targetConversationRes.data;
    //  if(targetConversation != null){
    //   ChannelPush.cPush.clearAllNotification();
    //   Navigator.push(
    //       _cachedContext ?? context,
    //       MaterialPageRoute(
    //         builder: (context) => Chat(
    //           selectedConversation: targetConversation,
    //         ),
    //       ));
    // }
  }

  @override
  void onInit() async {
    super.onInit();
    LocationService().init();
    initOfflinePush();
    controller = PageController(initialPage: 2);
    // controller.addListener(() {
    //   var curpage = controller.page;
    //   if (curpage == 2.0) userController.checkLogin(() => null);
    // });
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_push');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await AppConfig.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.instance
        .getToken()
        .then((value) => StorageManager.setPushToken(value));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On Remote Message Opened App');
      Get.to(() => NotificationPage());
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('Restart app get remote message');
      Get.to(() => NotificationPage());
    }

    NotificationAppLaunchDetails? notificationAppLaunchDetails = await AppConfig
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      print(
          'Restart app get local message::${notificationAppLaunchDetails.didNotificationLaunchApp}');
      Get.to(() => NotificationPage());
    }
  }

  @override
  void onReady() {
    super.onReady();
    checkVersion();
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      IndexApi.checkVersion().then((value) {
        if (value.upgrade && value.force) {
          UpgradeDialog.show(Get.context!, value, cancelable: !value.force);
          _timer.cancel();
        }
      });
    });
  }

  UserController userController = Get.find<UserController>();

  @override
  void onResumed() {
    userController.login(checkLastLoginTime: true);
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  void checkVersion() {
    if (checking == false) {
      checking = true;
      IndexApi.checkVersion().then((value) {
        final profilePageController = ProfilePageController.instance();
        if (Platform.isIOS) {
          StorageManager.setOnline(value.status);
        } else {
          StorageManager.setOnline(true);
        }
        profilePageController.online.value = StorageManager.getOnline();
        if (value.upgrade) {
          if (Get.context != null) {
            UpgradeDialog.show(Get.context!, value, cancelable: !value.force)
                .whenComplete(() => checkAd(Get.context!));
          }
        } else {
          if (Get.context != null) {
            checkAd(Get.context!);
          }
        }
      });
    }
  }

  void checkAd(BuildContext context) {
    IndexApi.getAD().then((value) async {
      if (value != null && value.image.isNotEmpty) {
        var file = await DefaultCacheManager().getSingleFile(value.image);
        PopAdDialog.show(context, value, file, cancelable: false);
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    _timer.cancel();
    super.onClose();
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void showLocalNotification(RemoteMessage message) async {
    if (message.notification != null) {
      RemoteNotification? notification = message.notification;
      FilePathAndroidBitmap? largeIcon;
      BigPictureStyleInformation? bigPictureStyleInformation;
      if (notification?.android?.imageUrl != null) {
        var file = await DefaultCacheManager()
            .getSingleFile(notification!.android!.imageUrl!);
        largeIcon = FilePathAndroidBitmap(file.path);
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(file.path),
          hideExpandedLargeIcon: true,
        );
      }

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('system'.tr, 'System Notification'.tr,
              channelDescription: 'system notification'.tr,
              importance: Importance.max,
              priority: Priority.high,
              largeIcon: largeIcon,
              styleInformation: bigPictureStyleInformation,
              ticker: 'ticker'.tr);
      IOSNotificationDetails iosPlatformChannelSpecifics =
          IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 1,
              threadIdentifier: 'system');
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics);
      await AppConfig.flutterLocalNotificationsPlugin.show(
          0,
          '${notification?.title}',
          '${notification?.body}',
          platformChannelSpecifics,
          payload: '');
    }
  }

  Future selectNotification(String? payload) async {
    print('On Local Message Opened App');
    Get.to(() => NotificationPage());
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print('onDidReceiveLocalNotification: $title');
  }
}
