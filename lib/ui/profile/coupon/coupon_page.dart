import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/coupon_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/im/im_util.dart';
import 'package:wy/ui/profile/coupon/dialog_add_coupon.dart';
import 'package:wy/widget/tab_widget.dart';
import 'package:wy/widget/views.dart';

import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import 'coupon_item.dart';
import 'dialog_coupon.dart';

class CouponPage extends StatelessWidget {
  static const int TYPE_STORE = 0;
  static const int TYPE_SIDE_KICK = 1;
  static const int TYPE_ACTIVITY = 2;
  late final CouponPageController controller;
  bool showAppbar = false;

  CouponPage({
    int couponType = 0,
    PayOrderModel? payOrderModel,
    Map<String, dynamic>? preOrder,
    int tab = TYPE_STORE,
    this.showAppbar = true,
  }) {
    controller = Get.put(
      CouponPageController(
        preOrder: preOrder,
        tab: tab,
        couponType: couponType,
        payOrderModel: payOrderModel,
      ),
      tag: '$tab',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppbar
          ? AppBar(
              title: Text("Vouchers".tr),
            )
          : null,
      body: Obx(() => controller.initializing.value
          ? buildLoad()
          : Column(
              children: [
                TabBar(
                  padding: EdgeInsets.zero,
                  controller: controller.tabController,
                  isScrollable: false,
                  labelColor: Color(0xFFFFCB0D),
                  unselectedLabelColor: AppColor.textC5C5,
                  indicatorColor: Color(0xFFFFCB0D),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2,
                  indicatorPadding: EdgeInsets.only(bottom: 5),
                  labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: FONT_MEDIUM,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: FONT_MEDIUM,
                  ),
                  tabs: controller.createTabs(),
                  onTap: (index) => controller.requestData(index),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 2,
                      right: 2,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 688 / 333),
                      itemBuilder: (context, index) {
                        CouponModel model = controller.list[index];
                        return CouponItem(
                          model: model,
                          onTap: (model) => controller.selectCoupon(model),
                        );
                      },
                      itemCount: controller.list.length,
                    ),
                  ),
                ),
              ],
            )),
      bottomNavigationBar: Obx(() => controller.floatingActionButtonShow.value
          ? FloatingButton(
              label: "ADD".tr,
              onTap: () => Get.dialog(
                          AddCouponDialog(
                            tab: controller.tab,
                          ),
                          barrierColor: Colors.black26)
                      .then((value) {
                    if (value != null) {
                      controller.reload();
                      Get.dialog(
                          ConfirmDialog(title: "Voucher Added".tr, info: value),
                          barrierColor: Colors.black26);
                    }
                  }))
          : Container()),
    );
  }
}

class CouponPageController extends GetxListController<CouponModel> {
  // late ScrollController scrollController;
  late TabController tabController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  PayOrderModel? payOrderModel;
  int couponType = 0;
  int tab;
  Map<String, dynamic>? preOrder;
  int type = 3;
  bool isFirstEnter = true;

  CouponPageController(
      {required this.payOrderModel,
      required this.couponType,
      this.preOrder,
      this.tab = CouponPage.TYPE_STORE});

  @override
  void onInit() {
    super.onInit();
    // scrollController = ScrollController();
    isFirstEnter = true;
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void onClose() {
    // scrollController.dispose();
    super.onClose();
    isFirstEnter = true;
  }

  @override
  void onReady() {
    // scrollController.addListener(() {
    //   if (scrollController.offset - offset > 0) {
    //     //down
    //     if (floatingActionButtonShow.value) {
    //       floatingActionButtonShow.value = false;
    //     }
    //   } else {
    //     //up
    //     if (!floatingActionButtonShow.value) {
    //       floatingActionButtonShow.value = true;
    //     }
    //   }
    //   offset = scrollController.offset;
    // });
    super.onReady();
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Product".tr,
    ));
    tabs.add(Text(
      "Gaming".tr,
    ));
    tabs.add(Text(
      "Event".tr,
    ));

    return tabs;
  }

  void requestData(int index) {
    isFirstEnter = false;
    switch (index) {
      case 0:
        type = 3;
        break;
      case 1:
        type = 5;
        break;
      case 2:
        type = 4;
        break;
    }
    loadData();
  }

  @override
  Future<List<CouponModel>> loadData() async {
    //  showLoading();
    List<CouponModel> couponList = await CouponApi.listCoupon(type);
    // if (payOrderModel != null) {
    //   couponList = await CouponApi.avaList(payOrderModel!);
    // } else if (preOrder != null) {
    //   print('index2222 = $type');
    //   couponList = await CouponApi.listCoupon(type);
    // } else {
    //   couponList = await CouponApi.list(couponType: couponType, tab: this.tab);
    // }
//    dismissLoading();
    list.assignAll(couponList);

    if (isFirstEnter) {
      return couponList;
    }
    return list;
  }

  void selectCoupon(CouponModel model) {
    if (payOrderModel != null || preOrder != null || couponType == 4) {
      Get.back(result: model);
    } else {
      Get.dialog(
          CouponDialog(
            model: model,
          ),
          barrierColor: Colors.black26);
    }
  }
}
