import 'package:get/get.dart';

import '../../../../../model/beans/order_status_bean.dart';

class IntegralRedemptionCtr extends GetxController
    with GetTickerProviderStateMixin {
  var selectStatus = (-10).obs;

  List<OrderStatusBean> orderStatusList = [
    OrderStatusBean(statusName: 'All'.tr, status: -10),
    OrderStatusBean(statusName: 'Completed'.tr, status: -2),
    OrderStatusBean(statusName: 'Ongoing'.tr, status: 2),
    OrderStatusBean(statusName: 'Refund Dispute'.tr, status: 6),
    OrderStatusBean(statusName: 'Cancelled'.tr, status: -1),
  ];
}
