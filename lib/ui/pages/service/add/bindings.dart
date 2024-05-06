/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'package:get/get.dart';

import 'controller.dart';
class AddGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddGamePageController());
  }
}