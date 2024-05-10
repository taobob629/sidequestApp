import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/home/tab_hubs_page.dart';
import 'package:sq_hub_app/ui/pages/profile/my_profile/my_profile_page.dart';
import 'package:sq_hub_app/ui/pages/social/tab_social_page.dart';
import 'package:sq_hub_app/ui/pages/splash/splash_page.dart';
import 'package:sq_hub_app/ui/pages/home/index_page.dart';
import 'package:sq_hub_app/ui/pages/stores/tab_cybercafe_page.dart';

import '../../common/keep_alive_wrapper.dart';
import '../../config/app_color.dart';
import '../../controller/user_controller.dart';
import '../../utils/storage_manager.dart';
import '../../utils/toast_utils.dart';
import '../../widget/tab_button.dart';
import 'login/login_page.dart';

GlobalKey<ScaffoldState> homeDrawerKey = GlobalKey();

class MainPage extends StatelessWidget {
  final controller = Get.put(MainPageController());

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
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: padding.bottom + 50,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.controller,
                  itemCount: controller.tabs.length,
                  itemBuilder: (context, index) => controller.tabs[index],
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: padding.bottom + 50,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: padding.bottom,
                  height: 80.h,
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
                          Badge(
                            shape: BadgeShape.circle,
                            badgeColor: Colors.red,
                            position: BadgePosition(top: 3.h, end: 5.h),
                            animationType: BadgeAnimationType.fade,
                            animationDuration:
                                const Duration(microseconds: 500),
                            showBadge:
                                UserController.find.unreadMsgCount.value > 0,
                            badgeContent: Text(
                              "${UserController.find.unreadMsgCount.value}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                            ignorePointer: true,
                            child: TabButton(
                                index: 3,
                                currentIndex: controller.currentIndex.value,
                                selectIconName: ImageUtils.tab_stores,
                                normalIconName: ImageUtils.tab_stores_normal,
                                onTap: () {
                                  controller.controller.jumpToPage(3);
                                  controller.updateCurrentIndex(3);
                                }),
                          ),
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
                                }
                              }),
                        ],
                      )))
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

  List<Widget> tabs = [
    IndexPage(),
    TabSocialPage(),
    TabHubsPage(),
    KeepAliveWrapper(child: TabCybercafePage()),
    MyProfilePage(),
  ];

  @override
  void onInit() async {
    super.onInit();
    controller = PageController(initialPage: currentIndex.value);
  }

  @override
  void onReady() {
    super.onReady();
    var firstUse = StorageManager.getFirstUse();
    if (firstUse) {
      Get.offAll(() => SplashPage());
      return;
    }

    // _timer = Timer.periodic(Duration(minutes: 5), (timer) {
    //   IndexApi.checkVersion().then((value) {
    //     if (value.upgrade && value.force) {
    //       showCustom(
    //         UpgradeDialog(model: value),
    //         clickMaskDismiss: value.force,
    //       );
    //       _timer.cancel();
    //     }
    //   });
    // });
  }

  @override
  void onResumed() {}

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

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print('onDidReceiveLocalNotification: $title');
  }
}
