import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/ui/controller/user_controller.dart';

import '../../../api/user_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../model/beans/order_status_bean.dart';
import '../../../model/service_list_model.dart';
import '../../../model/vistor_model.dart';
import '../../../utils/toast_utils.dart';

class MyGiftCtr extends GetxRefreshController<ServiceListModel> {
  var ifScaleBigReceived = true.obs;

  int selectStatus = -10;

  List<OrderStatusBean> orderStatusList = [
    OrderStatusBean(statusName: 'All'.tr, status: -10),
    OrderStatusBean(statusName: 'Completed'.tr, status: -2),
    OrderStatusBean(statusName: 'Ongoing'.tr, status: 2),
    OrderStatusBean(statusName: 'Refund Dispute'.tr, status: 6),
    OrderStatusBean(statusName: 'Cancelled'.tr, status: -1),
  ];

  @override
  void onInit() {
    super.onInit();

    ifScaleBigReceived.value = UserController.find.userProfile.isAuth == 1;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<List<ServiceListModel>> loadData({int pageNum = 1}) async {
    List<ServiceListModel> list = [];
    int type = 2;
    if (!ifScaleBigReceived.value) {
      type = 1;
    }
    showLoading();

    String url = '/peiwan/app/new/orders/list?type=$type&status=$selectStatus';
    var response = await http.get(url,
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data['rows']
        .map<ServiceListModel>((item) => ServiceListModel.fromJson(item))
        .toList();
    dismissLoading();
    return list;
  }
}
