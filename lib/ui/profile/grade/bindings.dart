import 'package:get/get.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';
import 'package:wy/utils/utils.dart';

/**
    bindiing
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/

class GradePageBinding extends Bindings {
  @override
  void dependencies() {
    flog('dependencies');
    Get.lazyPut(() => BindBankCardController());
  }
}
