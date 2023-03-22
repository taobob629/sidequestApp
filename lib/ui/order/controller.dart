/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';
import 'package:wy/common/base_tab_controller.dart';
import 'package:wy/model/activity_tab.dart';

const int TYPE_ORDER_RECEIVED = 2;
const int TYPE_ORDER_PROVIDED = 1;

class OrderTabController extends BaseTabContoller {
  RxInt _curTab = RxInt(0);

  int get curTab => _curTab.value;

  set curTab(int value) {
    _curTab.value = value;
  }

  @override
  initTabs() {
    tabs = [
      {'type': TYPE_ORDER_RECEIVED, 'index': 0, 'title': 'Received'.tr},
      {'type': TYPE_ORDER_PROVIDED, 'index': 1, 'title': 'Provided'.tr}
    ];
    return tabs;
  }
}
