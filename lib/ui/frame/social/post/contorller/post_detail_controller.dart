import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';

class PostDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  static PostDetailController get find => Get.find();
  final postItem = PostItemModel().obs;
  late TabController tabController;

  @override
  void onInit() {

    postItem.value = Get.arguments;
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
