import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sq_hub_app/image_utils.dart';

import '../../../../api/coupon_api.dart';
import '../../../../common/floating_button.dart';
import '../../../../common/getx_list_controller.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../model/coupon_model.dart';
import '../../../../model/goods_detail_model.dart';
import '../../../../model/pay_order_model.dart';
import '../../../../widget/views.dart';
import '../../../dialog/dialog_confirm.dart';
import 'coupon_item.dart';
import 'dialog_add_coupon.dart';
import 'dialog_coupon.dart';

class CouponPage extends StatelessWidget {
  static const int TYPE_STORE = 0;
  static const int TYPE_SIDE_KICK = 1;
  static const int TYPE_ACTIVITY = 2;
  late final CouponPageController controller;
  bool showAppbar = false;
  bool showTabbar = true;

  CouponPage({
    int couponType = 0,
    PayOrderModel? payOrderModel,
    Map<String, dynamic>? preOrder,
    int? storeId,
    List<Map<String, dynamic>>? goodsList,
    int tab = TYPE_STORE,
    this.showAppbar = true,
    this.showTabbar = true,
  }) {
    controller = Get.put(
      CouponPageController(
        preOrder: preOrder,
        tab: tab,
        couponType: couponType,
        payOrderModel: payOrderModel,
        storeId: storeId,
        goodsList: goodsList,
      ),
      tag: '$tab',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppbar
          ? AppBar(
              title: Text("".tr),
            )
          : null,
      body: Obx(() => controller.initializing.value
          ? buildLoad()
          : Column(
              children: [
                Visibility(
                  visible: showTabbar,
                  child: TabBar(
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
                ),
                controller.list.isEmpty
                    ? noDataEmpty()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 2,
                            right: 2,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 688 / 333),
                            itemBuilder: (context, index) {
                              CouponsListModel couponsListModel =
                                  controller.list[index];
                              return CouponItem(
                                listModel: couponsListModel,
                                onTap: (model) =>
                                    controller.selectCoupon(couponsListModel),
                              );
                            },
                            itemCount: controller.list.length,
                          ),
                        ),
                      ),
              ],
            )),
      bottomNavigationBar: Visibility(
        visible: controller.floatingActionButtonShow.value &&
            controller.list.isNotEmpty,
        child: Obx(() => FloatingButton(
              label: "ADD".tr,
              onTap: () => Get.dialog(
                AddCouponDialog(
                  tab: controller.tab,
                ),
                barrierColor: Colors.black26,
              ).then(
                (value) {
                  if (value != null) {
                    controller.reload();
                    Get.dialog(
                        ConfirmDialog(title: "Voucher Added".tr, info: value),
                        barrierColor: Colors.black26);
                  }
                },
              ),
            )),
      ),
    );
  }

  Widget noDataEmpty() => Expanded(
        child: Container(
          width: 1.sw,
          child: Center(
            child: Image.asset(
              ImageUtils.coupon_no_data_icon,
              width: 116.w,
            ),
          ),
        ),
      );
}

class CouponPageController extends GetxListController<CouponsListModel> {
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
  int? storeId;
  List<Map<String, dynamic>>? goodsList;

  var couponOurModel = CouponOurModel(
    gaming: 0,
    product: 0,
    coupons: [],
    event: 0,
  ).obs;

  CouponPageController({
    required this.payOrderModel,
    required this.couponType,
    int? storeId,
    List<Map<String, dynamic>>? goodsList,
    this.preOrder,
    this.tab = CouponPage.TYPE_STORE,
  }) {
    this.storeId = storeId;
    this.goodsList = goodsList;
  }

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
    tabs.add(Obx(() => badges.Badge(
          showBadge: couponOurModel.value.product > 0,
          badgeContent: Text(
            '${couponOurModel.value.product}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
            ),
          ),
          badgeColor: Color(0xffFF4848),
          position: badges.BadgePosition(end: -13.w, top: -2.h),
          alignment: Alignment.topRight,
          child: Text(
            "Product".tr,
          ),
        )));
    tabs.add(Obx(() => badges.Badge(
          showBadge: couponOurModel.value.gaming > 0,
          badgeContent: Text(
            '${couponOurModel.value.gaming}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
            ),
          ),
          badgeColor: Color(0xffFF4848),
          position: badges.BadgePosition(end: -13.w, top: -2.h),
          alignment: Alignment.topRight,
          child: Text(
            "Gaming".tr,
          ),
        )));
    tabs.add(Obx(() => badges.Badge(
          showBadge: couponOurModel.value.event > 0,
          badgeContent: Text(
            '${couponOurModel.value.event}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
            ),
          ),
          badgeColor: Color(0xffFF4848),
          position: badges.BadgePosition(end: -13.w, top: -2.h),
          alignment: Alignment.topRight,
          child: Text(
            "Event".tr,
          ),
        )));

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
  Future<List<CouponsListModel>> loadData() async {
    //  showLoading();
    if (storeId != null) {
      couponOurModel.value = await CouponApi.myVouchers(storeId: storeId, goodsList: goodsList);
    } else {
      couponOurModel.value = await CouponApi.listCoupon(type);
    }
    List<CouponsListModel> couponList = couponOurModel.value.coupons;
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

  void selectCoupon(CouponsListModel model) {
    if (payOrderModel != null || preOrder != null || couponType == 4) {
      Get.back(result: model);
    } else {
      Get.dialog(
        CouponDialog(model: model.couponModel),
        barrierColor: Colors.black26,
      );
    }
  }
}
