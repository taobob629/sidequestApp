import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';

import '../page/post_comments_page.dart';

class PostDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  static PostDetailController get find => Get.find();
  ScrollController scrollController=ScrollController();
  final postItem = PostItemModel().obs;
  late TabController tabController;
  RxBool _canScroll=RxBool(true);

  bool get canScroll => _canScroll.value;

  set canScroll(bool value) {
    _canScroll.value = value;
  }

  @override
  void onInit() {
    postItem.value = Get.arguments;
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    scrollController.addListener(() {
      try{
        Future.delayed(Duration(seconds: 1),(){
          canScroll= !Get.find<PostCommentController>().commentNode.hasFocus;
        });
      }catch(e){

      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
