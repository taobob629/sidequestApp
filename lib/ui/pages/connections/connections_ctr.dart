import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/utils/utils.dart';

import '../../../api/wy_http.dart';
import '../../../config/app_color.dart';
import '../../../utils/toast_utils.dart';

class ConnectionsCtr extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabBarController;
  var currentIndex = 0.obs;

  late List<Widget> tabsList;

  @override
  void onInit() {
    super.onInit();

    tabsList = [
      Obx(() => Container(
        height: 34.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: hexColor('#141414'),
          border: Border.all(
              color: currentIndex.value == 0
                  ? hexColor('#FFB20E')
                  : Colors.transparent,
              width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text('My connections'.tr),
      )),
      Obx(() => Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: hexColor('#141414'),
          border: Border.all(
              color: currentIndex.value == 1
                  ? hexColor('#FFB20E')
                  : Colors.transparent,
              width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text('Add game account'.tr),
      )),
    ];
    tabBarController = TabController(length: tabsList.length, vsync: this);
    tabBarController.addListener(() {
      flog("tabBarController.index = ${tabBarController.index}, ${tabBarController.indexIsChanging}");
      // 在这里执行你的逻辑
      currentIndex.value = tabBarController.index;
    });

    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/peiwan/app/new/home/lol/user/list');
    // final response = await http.get('/peiwan/app/profile/connections/list');
    dismissLoading();
  }
}
