/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';

import '../../../../common/base_tab_controller.dart';

class SocialTabController extends GetxController {
  List<String> tabs = ['Social Feed'.tr, 'Messages'.tr];
  var selectTopTabIndex = 0.obs;

  void clickTopTab(int i) {
    selectTopTabIndex.value = i;
  }
}
