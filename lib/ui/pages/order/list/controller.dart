/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'dart:async';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/api/order_api.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../../common/getx_refresh_controller.dart';
import '../../../../model/order_list_model.dart';

class OrderListController extends GetxController {

  late RefreshController refreshController;

  var list = <OrderListModel>[].obs;

  var showOrHide = true.obs;

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
  }
}
