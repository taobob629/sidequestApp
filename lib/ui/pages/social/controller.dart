/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';

import '../../../../common/base_tab_controller.dart';

class SocialTabController extends BaseTabContoller {
  @override
  initTabs() {
    tabs = ['Posts'.tr, 'Events'.tr];
  }
}
