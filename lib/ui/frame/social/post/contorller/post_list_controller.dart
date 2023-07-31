import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../utils/time_utils.dart';
import '../../../profile/model/post_item_model.dart';

class PostListController extends GetxRefreshController<PostItemModel> {
  static PostListController get find => Get.find();

  final list = <PostItemModel>[].obs;

  BuildContext? myContext;

  @override
  void onInit() {
    // getPostList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // getPostList() {
  //   PostApi.getPostList().then((value) {
  //     list.value = value;
  //     list.refresh();
  //   });
  // }

  Future<bool> praisePost(PostItemModel post) async {
    try {
      var resp = await PostApi.praisePost(postsId: post.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  String dealDateTime(int addTime) {
    int cHour = TimeUtils.daysBetweenHour(
        DateTime.fromMillisecondsSinceEpoch(addTime * 1000, isUtc: false),
        DateTime.now());
    return cHour > 24
        ? addTime.toDateStr
        : cHour == 0
            ? 'now'
            : '${cHour}h';
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<PostItemModel>> loadData({int pageNum = 1}) async {
    showLoading();
    final result = await PostApi.getPostList(page: pageNum);
    dismissLoading();
    return result;
  }
}
