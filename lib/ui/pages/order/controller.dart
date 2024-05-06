/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';

import '../../../common/base_tab_controller.dart';
import '../../../event_bus/beans/order_bean.dart';

const int TYPE_ORDER_RECEIVED = -2;
const int TYPE_ORDER_PROVIDED = 1;

class OrderTabController extends BaseTabContoller {
  RxInt _curTab = RxInt(0);

  int get curTab => _curTab.value;

  OrderBean? orderBean;

  set curTab(int value) {
    _curTab.value = value;
  }

  @override
  initTabs() {
    tabs = [
      {'status': TYPE_ORDER_RECEIVED, 'index': 0, 'title': 'Completed'.tr},
      {'status': TYPE_ORDER_PROVIDED, 'index': 1, 'title': 'Others'.tr}
    ];
    return tabs;
  }
}
