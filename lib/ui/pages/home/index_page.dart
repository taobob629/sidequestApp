import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/api/index_api.dart';
import 'package:sq_hub_app/common/keep_alive_wrapper.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/ui/pages/home/tab_bundles_page.dart';
import 'package:sq_hub_app/ui/pages/home/tab_events_page.dart';
import 'package:sq_hub_app/ui/pages/home/tab_hubs_page.dart';

import '../../../config/app_color.dart';
import '../../../controller/user_controller.dart';
import '../../../model/index_tab_model.dart';
import 'tab_headlines_page.dart';
import 'tab_news_page.dart';

class IndexPage extends StatelessWidget {
  final controller = Get.put(IndexPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return TabNewsPage();
  }
}

class IndexPageController extends GetxController
    with GetSingleTickerProviderStateMixin {

  @override
  void onInit() {
    super.onInit();

    Get.put(TabNewsPageController());
  }
}
