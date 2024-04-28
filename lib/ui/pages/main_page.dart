import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/profile/my_profile_page.dart';
import 'package:sq_hub_app/ui/pages/social/view.dart';
import 'package:sq_hub_app/ui/pages/splash/splash_page.dart';
import 'package:sq_hub_app/ui/pages/home/index_page.dart';
import 'package:sq_hub_app/ui/pages/stores/tab_cybercafe_page.dart';

import '../../config/app_color.dart';
import '../../config/icon_font.dart';
import '../../controller/user_controller.dart';
import '../../utils/permission_helper.dart';
import '../../utils/storage_manager.dart';
import '../../utils/toast_utils.dart';
import '../../widget/tab_button.dart';
import 'booking/booking_page.dart';
import 'home/drawer.dart';
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
      child: AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: Obx(() => Scaffold(
              backgroundColor: AppColor.background,
              key: homeDrawerKey,
              drawer: HomeDrawer(),
              appBar: controller.currentIndex.value == 0
                  ? AppBar(
                      elevation: 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => BookingPage()),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10, right: 4),
                              child: Image.asset(
                                ImageUtils.ic_store,
                                width: 27,
                                height: 27,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              UserController.find.checkLogin(() async {
                                bool access = await PermissionHelper
                                    .requestCameraPermission(context);
                                if (access) {
                                  UserController.find.scan();
                                }
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 10, right: 5),
                              child: Icon(
                                IconFonts.scan,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : null,
              body: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: padding.bottom + 50,
                    //  child: buildTabView(),
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
                      height: 80,
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TabButton(
                                index: 0,
                                currentIndex: controller.currentIndex.value,
                                iconName: "tab_home",
                                title: "Home".tr,
                                colors: const [
                                  Color(0xffb991ff),
                                  Color(0xff1817FF)
                                ],
                                onTap: () {
                                  controller.controller.jumpToPage(0);
                                  controller.updateCurrentIndex(0);
                                }),
                            TabButton(
                                index: 1,
                                currentIndex: controller.currentIndex.value,
                                iconName: "tab_social",
                                title: "Social".tr,
                                colors: const [
                                  Color(0xffFFD189),
                                  Color(0xffFF3617)
                                ],
                                onTap: () {
                                  controller.controller.jumpToPage(1);
                                  controller.updateCurrentIndex(1);
                                }),
                            TabButton(
                                index: 2,
                                currentIndex: controller.currentIndex.value,
                                iconName: "tab_stores",
                                title: "Stores".tr,
                                //colors: [Color(0xff4cd8fa), Color(0xff01819c)],
                                colors: const [
                                  Color(0xfffa7f85),
                                  Color(0xffb6262c)
                                ],
                                onTap: () {
                                  controller.controller.jumpToPage(2);
                                  controller.updateCurrentIndex(2);
                                }),
                            TabButton(
                                index: 3,
                                currentIndex: controller.currentIndex.value,
                                iconName: "tab_profile",
                                title: "Profile".tr,
                                colors: const [
                                  Color(0xff99c6fa),
                                  Color(0xff727DFF)
                                ],
                                onTap: () {
                                  var account = StorageManager.getToken();
                                  if (account.isEmpty) {
                                    Get.to(() => LoginPage());
                                  } else {
                                    controller.controller.jumpToPage(3);
                                    controller.updateCurrentIndex(3);
                                  }
                                }),
                          ],
                        );
                      }))
                ],
              )))),
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
    SocialPage(),
    TabCybercafePage(),
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
