/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/api/order_api.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../../common/getx_refresh_controller.dart';
import '../../../../model/order_list_model.dart';

class OrderListController extends GetxController {

  late RefreshController refreshController;

  var list = <OrderListModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: true);

    requestData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void requestData() async {
    showLoading();
    list.value = await OrderApi.getOrderList();
    dismissLoading();
    isLoading.value = false;
  }

  void showOrHideItem(OrderListModel model) {
    model.showOrHide.value = !model.showOrHide.value;
    if (model.showOrHide.value) {
      model.goodsItemTotalHeight.value = (65.w + 12.h) * model.items.length;
    } else {
      model.goodsItemTotalHeight.value = 165.w;
    }
  }
}
