import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/dialog_pop_ad.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/drawer.dart';
import 'package:wy/ui/index/tab_games_page.dart';
import 'package:wy/ui/index/tab_headlines_page.dart';
import 'package:wy/ui/index/tab_news_page.dart';
import 'package:wy/ui/login/qr_login_page.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/booking/booking_page.dart';
import 'package:wy/ui/scan/scan_page.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:wy/widget/tab_widget.dart';

import '../store/store_page.dart';

GlobalKey<ScaffoldState> homeDrawerKey = GlobalKey();

class IndexPage extends StatelessWidget {
  final controller = Get.put(IndexPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(headerSliverBuilder: (context,_)=>[
      SliverToBoxAdapter(
        child: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          indicatorColor: Colors.white38,
          indicatorSize: TabBarIndicatorSize.label,
          indicator:  HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
          labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          indicatorWeight: 4,
          indicatorPadding: EdgeInsets.only(bottom: 5),
          labelStyle: selectTabStyle(TAB_STYLE_2),
          unselectedLabelStyle: unSelectTabStyle(TAB_STYLE_2),
          tabs: createTabs(),
        ),)
    ], body: TabBarView(controller: controller.tabController, children: createPages()));
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Recommend".tr,
    ));
    tabs.add(Text(
      "News".tr,
    ));
    tabs.add(Text(
      "Games".tr,
    ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabHeadlinesPage()));
    pages.add(KeepAliveWrapper(child: TabNewsPage()));
    pages.add(KeepAliveWrapper(child: TabGamesPage()));
    return pages;
  }

  String decryptData(String data) {
    final key = encrypt.Key.fromUtf8('my 32 length key.......sidequest');
    final iv = encrypt.IV.fromLength(16);
    final encryptMaker = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    encrypt.Encrypted encrypted = encrypt.Encrypted.fromBase64(data);
    return encryptMaker.decrypt(encrypted, iv: iv);
  }

  void encryptData(String data) {
    final key = encrypt.Key.fromUtf8('my 32 length key.......sidequest');
    final iv = encrypt.IV.fromLength(16);
    final encryptMaker = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    final encrypted = encryptMaker.encrypt(data, iv: iv);
  }
}

class IndexPageController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
  }

}
