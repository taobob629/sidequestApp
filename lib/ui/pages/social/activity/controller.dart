/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';

import '../../../../common/base_tab_controller.dart';
import '../../../../model/activity_tab.dart';

class ActivityTabController extends BaseTabContoller<ActivityTabModel> {
  Rxn<ActivityTabModel> _curTab = Rxn();

  ActivityTabModel? get curTab => _curTab.value;

  set curTab(ActivityTabModel? value) {
    _curTab.value = value;
  }

  @override
  Future initTabs() async {
    // List<ActivityTabModel> tabs = await ActivityApi.activityTabs();
    // var defaultTab = tabs.firstWhereOrNull((tab) => tab.defaut == 1);
    // //默认展示
    // // if (tabs.isNotEmpty) curTab = tabs[0];
    // curTab = defaultTab ?? tabs[0];
    return tabs;
  }
}
