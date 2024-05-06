import 'package:get/get.dart';

import 'controller.dart';


class CreateGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateGroupController());
  }
}
