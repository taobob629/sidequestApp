/*
    bindings
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 */
import 'package:get/get.dart';

import 'controller.dart';

class WithDrawRecordPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithDrawRecordPageController());
  }
}
