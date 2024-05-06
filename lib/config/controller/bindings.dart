/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:get/get.dart';

import 'controller.dart';
class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(AppController(),permanent: true);
  }

}