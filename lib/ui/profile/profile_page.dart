import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/vip_api.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/vip_info_model.dart';
import 'package:wy/ui/common/action_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/accompany_certification_page.dart';
import 'package:wy/ui/playwith/play_balance_page.dart';
import 'package:wy/ui/playwith/play_with_page.dart';
import 'package:wy/ui/profile/booking/booking_page.dart';
import 'package:wy/ui/profile/events/my_events_page.dart';
import 'package:wy/ui/profile/orders/orders_page.dart';
import 'package:wy/ui/profile/profile_header.dart';
import 'package:wy/ui/profile/settings/settings_page.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';

import '../common/dialog_input.dart';
import 'balance/balance_page.dart';
import 'developer/developer_page.dart';
import 'menu_view.dart';
import 'notification/notification_page.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfilePageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 320,
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFC3C02), Color(0xFF171525)])),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  ActionButton(
                    icon: Image.asset("assets/images/ic_edit_new.webp", width: 24),
                    onTap: () => userController.checkLogin(() => NavigatorHelper.gotoEditProfilePage()),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Badge(
                    shape: BadgeShape.circle,
                    badgeColor: Color(0xFFFF9494),
                    position: BadgePosition(top: 3, end: 5),
                    animationType: BadgeAnimationType.fade,
                    animationDuration: const Duration(microseconds: 500),
                    showBadge: false,
                    badgeContent: null,
                    child: ActionButton(onTap: () => userController.checkLogin(() => Get.to(() => NotificationPage())), icon: Image.asset("assets/images/ic_msg_new.webp", width: 26)),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  ActionButton(
                      onTap: () => userController.checkLogin(() => Get.to(() => SettingsPage())),
                      icon: Image.asset(
                        "assets/images/ic_setting_new.webp",
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      )),
                  SizedBox(
                    width: 0,
                  ),
                ],
                floating: true,
              ),
              SliverToBoxAdapter(
                child: ProfileHeader(),
              ),
              SliverToBoxAdapter(
                child: Builder(builder: (context) {
                  var view;
                  if (true) {
                    view = PWidget.row([
                      PWidget.boxw(24),
                      PWidget.text(
                        "You're playing with me now",
                        [Colors.white, 20],
                        {'ff': 'DIN', 'exp': true},
                      ),
                      PWidget.container(
                        PWidget.text("Enter the play space", [Color(0xff3C8AEC), 16], {'ff': 'DIN'}),
                        [null, 32, Colors.white],
                        {
                          'br': 56,
                          'ali': PFun.lg(0, 0),
                          'pd': PFun.lg(0, 0, 16, 16),
                          'fun': () => jumpPage(AccompanyCertificationPage()),
                        },
                      ),
                      PWidget.boxw(24),
                    ]);
                  } else {
                    view = PWidget.text("Join as a companion", [Colors.white, 24], {'ff': 'DIN'});
                  }
                  return PWidget.container(
                    Stack(alignment: Alignment.center, children: [Image.asset("assets/images/peiwan.png"), view]),
                    {'pd': PFun.lg(8), 'fun': () {}},
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Obx(() => controller.online.value
                    ? MenuView(
                        icon: "balance",
                        title: "My Balance",
                        detail: "",
                        onTap: () => userController.checkLogin(() => Get.to(() => BalancePage())?.whenComplete(() => userController.updateInfo())),
                      )
                    : Container()),
              ),
              SliverToBoxAdapter(
                child: Obx(() => controller.online.value
                    ? MenuView(
                        icon: "balance",
                        title: "Play Balance",
                        detail: "",
                        onTap: () => userController.checkLogin(() => Get.to(() => PlayBalancePage())?.whenComplete(() => userController.updateInfo())),
                      )
                    : Container()),
              ),
              SliverToBoxAdapter(
                child: MenuView(
                  icon: "booking",
                  title: "My Bookings",
                  detail: "",
                  onTap: () => userController.checkLogin(() => Get.to(() => BookingPage())?.whenComplete(() => userController.updateInfo())),
                ),
              ),
              SliverToBoxAdapter(
                child: MenuView(
                  icon: "orders",
                  title: "My Orders",
                  detail: "",
                  onTap: () => userController.checkLogin(() => Get.to(() => OrdersPage())),
                ),
              ),
              SliverToBoxAdapter(
                child: MenuView(
                  icon: "tab_events",
                  title: "My Activities",
                  detail: "",
                  onTap: () => userController.checkLogin(() => Get.to(() => MyEventsPage())),
                ),
              ),
              SliverToBoxAdapter(
                child: MenuView(
                  icon: "address",
                  title: "My Address",
                  detail: "",
                  onTap: () => userController.checkLogin(() => NavigatorHelper.gotoAddressPage()),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ProfilePageController extends GetxController {
  RxList<VipInfoModel> vipInfoList = RxList();

  int devCount = 0;

  var online = false.obs;

  @override
  void onReady() async {
    super.onReady();
    online.value = StorageManager.getOnline();
    vipInfoList.clear();
    vipInfoList.addAll(await VipApi.info());
  }

  void goDev() {
    devCount++;
    if (devCount < 6) {
      return;
    }
    devCount = 0;

    Get.dialog(InputDialog(), barrierDismissible: true, barrierColor: Colors.black26).then((value) {
      if (value == "9637") {
        Get.to(() => DeveloperPage());
      } else {
        Get.back();
      }
    });
  }
}
