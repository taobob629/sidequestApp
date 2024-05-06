import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../common/getx_refresh_controller.dart';
import '../../../../../controller/user_controller.dart';
import '../../../../../model/integral_list_model.dart';

class IntegralRecordCtr extends GetxRefreshController<IntegralListRow>
    with GetSingleTickerProviderStateMixin {
  TabController? tabBarController;

  List<Widget> tabsList = [
    Tab(text: 'Received'.tr),
    Tab(text: 'Income'.tr),
    Tab(text: 'Expenditure'.tr),
  ];

  // receive:0; income:1; Expenditure:不传
  int mold = 0;

  @override
  void onInit() {
    super.onInit();

    tabBarController = TabController(length: tabsList.length, vsync: this);
  }

  @override
  Future<List<IntegralListRow>> loadData({int pageNum = 1}) async {
    final params = {
      "userId": UserController.find.userProfile.memberId,
      "pageNum": pageNum,
      "pageSize": pageSize,
    };
    if (mold != 2) {
      params['mold'] = mold;
    }

    var response = await http.get(
      '/web/app/integral/queryIntegralDetailList',
      queryParameters: params,
    );
    final model = IntegralListModel.fromJson(response.data);

    return model.rows;
  }

  void changeData(int index) {
    mold = index;
    onRefresh(init: true);
  }
}
