import 'package:get/get.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';
import 'package:wy/utils/utils.dart';

import 'controller.dart';


class CreateGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateGroupController());
  }
}
