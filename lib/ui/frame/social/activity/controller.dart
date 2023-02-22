/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';
import 'package:wy/api/activity_api.dart';
import 'package:wy/common/base_tab_controller.dart';

class ActivityTabController<ActivityTabModel> extends BaseTabContoller {
  Rxn<ActivityTabModel> _curTab = Rxn();

  ActivityTabModel? get curTab => _curTab.value;

  set curTab(ActivityTabModel? value) {
    _curTab.value = value;
  }

  @override
  initTabs() async {
    tabs = await ActivityApi.activityTabs();
    if (tabs.isNotEmpty) curTab = tabs[0];
  }
}
