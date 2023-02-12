import 'package:get/get.dart';

import 'controller.dart';

/*
    bindiing
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 */

class ChooseGamePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChooseGamePageController());
  }
}
