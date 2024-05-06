/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/base_tab_controller.dart';
import '../../../config/app_color.dart';
import '../../../image_utils.dart';

class SideKickCtr extends BaseTabContoller {
  static SideKickCtr get find => Get.find();

  List<Widget> tabsList = [];

  var currentIndex = 0.obs;

  @override
  initTabs() {}

  @override
  void onInit() {
    super.onInit();

    tabsList.add(Obx(() => Image.asset(
          ImageUtils.tab_sidekick,
          color: currentIndex.value == 0 ? AppColor.yellow : Colors.white,
          width: 30.w,
          height: 30.w,
        )));
    tabsList.add(Obx(() => Image.asset(
          ImageUtils.tab_ranking_icon,
          color: currentIndex.value == 1 ? AppColor.yellow : Colors.white,
          width: 30.w,
          height: 30.w,
        )));
    tabbarController = TabController(length: tabsList.length, vsync: this);
  }
}
