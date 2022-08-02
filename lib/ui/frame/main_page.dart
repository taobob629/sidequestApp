import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/firebase_options.dart';
import 'package:wy/ui/common/dialog_pop_ad.dart';
import 'package:wy/ui/common/dialog_upgrade.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/events/events_page.dart';
import 'package:wy/ui/frame/tab_button.dart';
import 'package:wy/ui/index/Index_page.dart';
import 'package:wy/ui/profile/notification/notification_page.dart';
import 'package:wy/ui/profile/profile_page.dart';
import 'package:wy/ui/shop/shop_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MainPage extends GetView<MainPageController> {

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery
      .of(context)
      .padding;
    return WillPopScope(
      onWillPop: ()async{
        if(controller.currentIndex.value != 0){
          controller.controller.jumpToPage(0);
          controller.updateCurrentIndex(0);
        }
        if(controller.lastPopTime == null || DateTime.now().difference(controller.lastPopTime!) > Duration(seconds: 2)){
          controller.lastPopTime = DateTime.now();
          EasyLoading.showInfo("Press again to exit", duration: Duration(seconds: 2));
        }else{
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
                child: PreloadPageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.controller,
                  itemCount: 4,
                  preloadPagesCount: 4,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return IndexPage();
                      case 1:
                        return EventsPage();
                      case 2:
                        return ShopPage();
                      case 3:
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
                )
              ),
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
                        title: "Home",
                        colors: [Color(0xffb991ff), Color(0xff1817FF)],
                        onTap: () {
                          controller.controller.jumpToPage(0);
                          controller.updateCurrentIndex(0);
                        }
                      ),
                      TabButton(
                        index: 1,
                        currentIndex: controller.currentIndex.value,
                        iconName: "events",
                        title: "Activities",
                        colors: [Color(0xffFFD189), Color(0xffFF3617)],
                        onTap: () {
                          controller.controller.jumpToPage(1);
                          controller.updateCurrentIndex(1);
                        }
                      ),
                      TabButton(
                        index: 2,
                        currentIndex: controller.currentIndex.value,
                        iconName: "shop",
                        title: "Shop",
                        //colors: [Color(0xff4cd8fa), Color(0xff01819c)],
                        colors: [Color(0xffff747b), Color(0xff99272c)],
                        onTap: () {
                          controller.controller.jumpToPage(2);
                          controller.updateCurrentIndex(2);
                        }
                      ),
                      TabButton(
                        index: 3,
                        currentIndex: controller.currentIndex.value,
                        iconName: "user",
                        title: "Profile",
                        colors: [Color(0xff99c6fa), Color(0xff727DFF)],
                        onTap: () {
                          userController.updateInfo();
                          controller.controller.jumpToPage(3);
                          controller.updateCurrentIndex(3);
                        }
                      ),
                    ],
                  );
                })
              )
            ],
          )
        )
      ),
    );
  }
}

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainPageController>(MainPageController());
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

class MainPageController extends FullLifeCycleController with FullLifeCycleMixin{
  late PreloadPageController controller;
  var currentIndex = 0.obs;

  bool checking = false;

  DateTime? lastPopTime;

  late Timer _timer;

  @override
  void onInit() async{
    super.onInit();
    controller = PreloadPageController();

    var initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_push'
    );
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await AppConfig.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification
    );

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.instance.getToken().then((value) => StorageManager.setPushToken(value));
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print('Got a message whilst in the foreground!');
      showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On Remote Message Opened App');
      Get.to(()=>NotificationPage());
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      print('Restart app get remote message');
      Get.to(()=>NotificationPage());
    }

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await AppConfig.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if(notificationAppLaunchDetails != null && notificationAppLaunchDetails.didNotificationLaunchApp){
      print('Restart app get local message::${notificationAppLaunchDetails.didNotificationLaunchApp}');
      Get.to(()=>NotificationPage());
    }
  }

  @override
  void onReady() {
    super.onReady();
    if(Get.context != null) {
      checkVersion(Get.context!);
    }

    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      IndexApi.checkVersion().then((value) {
        if (value.upgrade && value.force) {
          UpgradeDialog.show(Get.context!, value, cancelable: !value.force);
          _timer.cancel();
        }
      });
    });
  }

  @override
  void onResumed() {
    UserController userController = Get.find<UserController>();
    userController.login(checkLastLoginTime: true);
  }

  @override
  void onDetached() {
  }

  @override
  void onInactive() {
  }

  @override
  void onPaused() {
  }


  void checkVersion(BuildContext context){
    if(checking == false) {
      checking = true;
      IndexApi.checkVersion().then((value) {
        if (value.upgrade) {
          UpgradeDialog.show(context, value, cancelable: !value.force).whenComplete(() => checkAd(context));
        } else {
          checkAd(context);
        }
      });
    }
  }

  void checkAd(BuildContext context){
    IndexApi.getAD().then((value) async{
      if(value != null && value.image.isNotEmpty) {
        var file = await DefaultCacheManager().getSingleFile(value.image);
        PopAdDialog.show(context, value, file,cancelable: false);
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

  void showLocalNotification(RemoteMessage message)async{
    if (message.notification != null) {
      RemoteNotification? notification = message.notification;
      FilePathAndroidBitmap? largeIcon;
      BigPictureStyleInformation? bigPictureStyleInformation;
      if(notification?.android?.imageUrl != null){
        var file = await DefaultCacheManager().getSingleFile(notification!.android!.imageUrl!);
        largeIcon = FilePathAndroidBitmap(file.path);
        bigPictureStyleInformation =
          BigPictureStyleInformation(
            FilePathAndroidBitmap(file.path),
            hideExpandedLargeIcon: true,);
      }

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'system',
        'System Notification',
        channelDescription: 'system notification',
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: largeIcon,
        styleInformation: bigPictureStyleInformation,
        ticker: 'ticker'
      );
      IOSNotificationDetails iosPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        threadIdentifier: 'system'
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics
      );
      await AppConfig.flutterLocalNotificationsPlugin.show(
        0, '${notification?.title}', '${notification?.body}', platformChannelSpecifics,
        payload: '');
    }
  }

  Future selectNotification(String? payload) async {
    print('On Local Message Opened App');
    Get.to(()=>NotificationPage());
  }

  Future onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
    print('onDidReceiveLocalNotification: $title');
  }

}