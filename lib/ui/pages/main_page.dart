import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_notifications_for_us/local_notifications_for_us.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/home/tab_hubs_page.dart';
import 'package:sq_hub_app/ui/pages/profile/my_profile/my_profile_page.dart';
import 'package:sq_hub_app/ui/pages/profile/task/task_page.dart';
import 'package:sq_hub_app/ui/pages/splash/splash_page.dart';
import 'package:sq_hub_app/ui/pages/home/index_page.dart';

import '../../api/index_api.dart';
import '../../common/web_page.dart';
import '../../config/app_color.dart';
import '../../config/app_config.dart';
import '../../controller/user_controller.dart';
import '../../firebase_options.dart';
import '../../service/location_service.dart';
import '../../utils/storage_manager.dart';
import '../../utils/toast_utils.dart';
import '../../widget/tab_button.dart';
import '../dialog/dialog_ad.dart';
import '../dialog/dialog_upgrade.dart';
import 'home/tab_events_page.dart';
import 'login/login_page.dart';
import 'notification/notification_page.dart';

GlobalKey<ScaffoldState> homeDrawerKey = GlobalKey();

class MainPage extends StatelessWidget {
  final controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    print('padding.bottom = ${padding.bottom}');

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          controller.controller.jumpToPage(0);
          controller.updateCurrentIndex(0);
        }
        if (controller.lastPopTime == null ||
            DateTime.now().difference(controller.lastPopTime!) >
                const Duration(seconds: 2)) {
          controller.lastPopTime = DateTime.now();
          showInfo("Press again to exit".tr);
        } else {
          controller.lastPopTime = DateTime.now();
          // 退出app
          // await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          exit(0);
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: AppColor.background,
          key: homeDrawerKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              title: const Text("Flutter 留着状态栏高度，去掉appbar高度"),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.controller,
                  itemCount: controller.tabs.length,
                  itemBuilder: (context, index) => controller.tabs[index],
                ),
              ),
              Container(
                color: hexColor('141517'),
                height: 60.h + 16.h,
                padding: EdgeInsets.only(bottom: 16.h),
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TabButton(
                            index: 0,
                            currentIndex: controller.currentIndex.value,
                            selectIconName: ImageUtils.tab_home,
                            normalIconName: ImageUtils.tab_home_normal,
                            onTap: () {
                              controller.controller.jumpToPage(0);
                              controller.updateCurrentIndex(0);
                            }),
                        TabButton(
                            index: 1,
                            currentIndex: controller.currentIndex.value,
                            selectIconName: ImageUtils.tab_social,
                            normalIconName: ImageUtils.tab_social_normal,
                            onTap: () {
                              controller.controller.jumpToPage(1);
                              controller.updateCurrentIndex(1);
                            }),
                        TabButton(
                            index: 2,
                            currentIndex: controller.currentIndex.value,
                            selectIconName: ImageUtils.tab_games,
                            normalIconName: ImageUtils.tab_games_normal,
                            onTap: () {
                              controller.controller.jumpToPage(2);
                              controller.updateCurrentIndex(2);
                            }),
                        TabButton(
                            index: 3,
                            currentIndex: controller.currentIndex.value,
                            selectIconName: ImageUtils.tab_quest,
                            normalIconName: ImageUtils.tab_quest_normal,
                            onTap: () {
                              controller.controller.jumpToPage(3);
                              controller.updateCurrentIndex(3);
                            }),
                        TabButton(
                            index: 4,
                            currentIndex: controller.currentIndex.value,
                            selectIconName: ImageUtils.tab_profile,
                            normalIconName: ImageUtils.tab_profile_normal,
                            onTap: () {
                              var account = StorageManager.getToken();
                              if (account.isEmpty) {
                                Get.to(() => LoginPage());
                              } else {
                                controller.controller.jumpToPage(4);
                                controller.updateCurrentIndex(4);
                                if (Get.isRegistered<ProfileController>()) {
                                  ProfileController.find.onRefresh();
                                }
                              }
                            }),
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}

class MainPageController extends FullLifeCycleController
    with FullLifeCycleMixin {
  static MainPageController get find => Get.find();

  late PageController controller;
  var currentIndex = 0.obs;

  bool checking = false;

  DateTime? lastPopTime;

  late Timer _timer;

  BuildContext? myContext;

  UserController userController = Get.find<UserController>();

  List<Widget> tabs = [
    IndexPage(),
    TabEventsPage(),
    TabHubsPage(),
    TaskPage(),
    MyProfilePage(),
  ];

  @override
  void onInit() async {
    super.onInit();
    LocationService().init();
    controller = PageController(initialPage: currentIndex.value);
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
    var firstUse = StorageManager.getFirstUse();
    if (firstUse) {
      Get.offAll(() => SplashPage());
      return;
    }

    checkAd();

    IndexApi.checkVersion().then((value) {
      if (value.upgrade) {
        if (Get.context != null) {
          Get.dialog(
            UpgradeDialog(model: value),
            barrierDismissible: !value.force
          );
        }
      }
    });

    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      IndexApi.checkVersion().then((value) {
        if (value.upgrade) {
          Get.dialog(
              UpgradeDialog(model: value),
              barrierDismissible: !value.force
          );
          _timer.cancel();
        }
      });
    });
  }

  @override
  void onResumed() {
    UserController.find.switchLogin(checkLastLoginTime: true);
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

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

  void checkAd() {
    IndexApi.getAD().then((value) async {
      if (value != null && value.image.isNotEmpty) {
        Map<String, dynamic> map = jsonDecode(value.content);
        if (map["type"] == "h5" && map["fullScreen"] == 1) {
          if (userController.user.value.id != 0) {
            IndexApi.readAD(value.id, value.title);
          }
          String? url = map["target"];
          Get.to(() => WebPage(
                url: url,
                title: '',
              ));
        } else {
          PopAdDialog.show(value, cancelable: false);
        }
      }
    });
  }

  Future selectNotification(String? payload) async {
    print('On Local Message Opened App');
    // Get.to(() => NotificationPage());
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print('onDidReceiveLocalNotification: $title');
  }
}
