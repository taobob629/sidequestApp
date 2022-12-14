import 'package:get/get.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';

/**
    bindiing
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/

class BindBankCardPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BindBankCardController());
  }
}
