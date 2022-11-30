import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/coupon_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/coupon/dialog_add_coupon.dart';
import 'package:wy/utils/utils.dart';

import 'coupon_item.dart';
import 'dialog_coupon.dart';

class CouponPage extends StatelessWidget {
  static const int TYPE_STORE = 0;
  static const int TYPE_SIDE_KICK = 1;
  late final CouponPageController controller;
  bool showAppbar = false;

  CouponPage(
      {int couponType = 0,
      PayOrderModel? payOrderModel,
      Map<String, dynamic>? preOrder,
      int tab = TYPE_STORE,
      this.showAppbar = true}) {
    controller = Get.put(
        CouponPageController(
            preOrder: preOrder,
            tab: tab,
            couponType: couponType,
            payOrderModel: payOrderModel),
        tag: '$tab');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppbar
          ? AppBar(
              title: Text("Vouchers".tr),
            )
          : null,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Obx(() => controller.initializing.value
                  ? Container()
                  : controller.list.length == 0
                      ? EmptyView()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: GridView.builder(
                            controller: controller.scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                          ))))
        ],
      ),
      // floatingActionButton: Obx(() => controller.floatingActionButtonShow.value
      //     ? FloatingButton(
      //         label: "ADD".tr,
      //         onTap: () => Get.dialog(
      //                     AddCouponDialog(
      //                       tab: controller.tab,
      //                     ),
      //                     barrierColor: Colors.black26)
      //                 .then((value) {
      //               if (value != null) {
      //                 controller.reload();
      //                 Get.dialog(
      //                     ConfirmDialog(title: "Voucher Added".tr, info: value),
      //                     barrierColor: Colors.black26);
      //               }
      //             }))
      //     : Container()),
    );
  }
}

class CouponPageController extends GetxListController<CouponModel> {
  late ScrollController scrollController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  PayOrderModel? payOrderModel;
  int couponType = 0;
  int tab;
  Map<String, dynamic>? preOrder;

  CouponPageController(
      {required this.payOrderModel,
      required this.couponType,
      this.preOrder,
      this.tab = CouponPage.TYPE_STORE});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.offset - offset > 0) {
        //down
        if (floatingActionButtonShow.value) {
          floatingActionButtonShow.value = false;
        }
      } else {
        //up
        if (!floatingActionButtonShow.value) {
          floatingActionButtonShow.value = true;
        }
      }
      offset = scrollController.offset;
    });
    super.onReady();
  }

  Future<List<CouponModel>> loadData() async {
    EasyLoading.show();
    // flog('preOrder---$preOrder ');
    List<CouponModel> list;
    if (payOrderModel != null) {
      list = await CouponApi.avaList(payOrderModel!);
    } else if (preOrder != null) {
      list = await CouponApi.avaiPwcoupons(preOrder);
    } else {
      list = await CouponApi.list(couponType: couponType, tab: this.tab);
    }
    EasyLoading.dismiss();

    return list;
  }

  void selectCoupon(CouponModel model) {
    if (payOrderModel != null || preOrder != null) {
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
