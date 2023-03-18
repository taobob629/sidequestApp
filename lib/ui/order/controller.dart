/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';
import 'package:wy/common/base_tab_controller.dart';
import 'package:wy/model/activity_tab.dart';

class OrderTabController extends BaseTabContoller {
  RxInt _curTab = RxInt(0);

  int get curTab => _curTab.value;

  set curTab(int value) {
    _curTab.value = value;
  }

  @override
  initTabs() {
    tabs = [
      {'type': 2, 'index': 0, 'title': 'Received'.tr},
      {'type': 1, 'index': 1, 'title': 'Provided'.tr}
    ];
    return tabs;
  }
}
