import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:sq_hub_app/model/banner_model.dart' as custom;
import 'package:sq_hub_app/ui/pages/shop/tab_cate_page.dart';

import '../../../api/index_api.dart';
import '../../../api/shop_api.dart';
import '../../../common/home_indicator.dart';
import '../../../common/keep_alive_wrapper.dart';
import '../../../config/app_color.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/shop_tab_model.dart';
import '../../../utils/navigator_helper.dart';
import 'cart/cart_page.dart';

class ShopPage extends StatelessWidget {
  final controller = Get.put(ShopPageController());

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () => NavigatorHelper.gotoSearchPage(),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(border: Border.all(color: Colors.white10), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Image.asset(
                              "assets/images/ic_search.webp",
                              width: 24,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            "Search anything you want to buy".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 14, color: Colors.white30),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: controller.tabs.length == 0
                        ? Container()
                        : TabBar(
                            controller: controller.tabController,
                            isScrollable: true,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            indicatorColor: Colors.white38,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: HomeIndicator(),
                            indicatorWeight: 4,
                            indicatorPadding: EdgeInsets.only(bottom: 5),
                            labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                            labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                            unselectedLabelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                            tabs: createTabs(),
                          ),
                  );
                })
              ],
            )),
          )),
      body: Obx(() {
        return controller.tabs.length == 0 ? Container() : TabBarView(controller: controller.tabController, children: createPages());
      }),
      floatingActionButton: FloatingActionButton(
          child: Obx(() => Badge(
                shape: BadgeShape.circle,
                badgeColor: AppColor.accent,
                position: BadgePosition(top: -5, end: -5),
                toAnimate: false,
                showBadge: cartController.totalCount.value > 0,
                badgeContent: Text(
                  "${cartController.totalCount.value}",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                child: Image.asset("assets/images/ic_shop_cart.webp"),
              )),
          backgroundColor: Colors.white,
          onPressed: () {
            var userController = Get.find<UserController>();
            userController.checkLogin(() => Get.to(() => CartPage()));
          }),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    for (ShopTabModel tab in controller.tabs) {
      tabs.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(tab.name),
      ));
    }
    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    int i = 0;
    for (ShopTabModel tab in controller.tabs) {
      pages.add(KeepAliveWrapper(
          child: TabCatePage(
        showBanners: i == 0,
        tab: tab,
      )));
      i++;
    }
    return pages;
  }
}

class ShopPageController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  RxList<ShopTabModel> tabs = RxList();

  RxList<custom.BannerModel> banners = RxList();

  @override
  void onInit() async {
    super.onInit();

    List<ShopTabModel> list = await ShopApi.tabs();
    tabs.clear();
    tabs.addAll(list);
    tabController = TabController(length: tabs.length, initialIndex: 0, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    banners.clear();
    banners.addAll(await IndexApi.getBanners(7));
  }
}
