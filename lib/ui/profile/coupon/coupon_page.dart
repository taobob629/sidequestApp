
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/coupon_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/profile/coupon/dialog_add_coupon.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';

import 'coupon_item.dart';
import 'dialog_coupon.dart';

class CouponPage extends StatelessWidget {

  late final CouponPageController controller;

  CouponPage({int couponType = 0, PayOrderModel? payOrderModel}){
    controller = Get.put(CouponPageController(couponType: couponType, payOrderModel: payOrderModel));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Vouchers".tr,
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 167/116
                ),
                itemBuilder: (context,index){
                  CouponModel model = controller.list[index];
                  return CouponItem(model: model, onTap: (model)=>controller.selectCoupon(model),);
                },
                itemCount: controller.list.length,
              )
            ))
          )
        ],
      ),
      floatingActionButton: Obx(
          ()=>controller.floatingActionButtonShow.value ?
        FloatingButton(
            label: "ADD".tr,
              onTap: () => Get.dialog(AddCouponDialog(), barrierColor: Colors.black26).then((value) {
                    if (value != null) {
                      controller.reload();
                      Get.dialog(ConfirmDialog(title: "Voucher Added".tr, info: value), barrierColor: Colors.black26);
                    }
                  }))
          : Container()
      ),
    );
  }
}

class CouponPageController extends GetxListController<CouponModel> {
  late ScrollController scrollController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  PayOrderModel? payOrderModel;
  int couponType = 0;

  CouponPageController({required this.payOrderModel, required this.couponType});

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
      if (scrollController.offset - offset > 0) { //down
        if (floatingActionButtonShow.value) {
          floatingActionButtonShow.value = false;
        }
      } else { //up
        if (!floatingActionButtonShow.value) {
          floatingActionButtonShow.value = true;
        }
      }
      offset = scrollController.offset;
    });
    super.onReady();
  }

  Future<List<CouponModel>> loadData() async{
    EasyLoading.show();


    List<CouponModel> list;
    if(payOrderModel == null) {
      if(couponType == 0) {
        list = await CouponApi.list();
      }else{
        list = await CouponApi.list(couponType: couponType);
      }
    }else{
      list = await CouponApi.avaList(payOrderModel!);
    }

    EasyLoading.dismiss();

    return list;
  }

  void selectCoupon(CouponModel model){
    if(payOrderModel != null){
      Get.back(result: model);
    }else{
      Get.dialog(CouponDialog(model: model,),barrierColor: Colors.black26);
    }
  }
}