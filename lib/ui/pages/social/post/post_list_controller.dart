import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/string_ext.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_detail_page.dart';

import '../../../../../../utils/time_utils.dart';
import '../../../../../api/post_api.dart';
import '../../../../../common/getx_refresh_controller.dart';
import '../../../../../model/post_item_model.dart';

class PostListController extends GetxRefreshController<PostItemModel> {
  static PostListController get find => Get.find();

  final list = <PostItemModel>[].obs;

  BuildContext? myContext;

  @override
  void onInit() {
    // getPostList();
    this.initialRefresh = true;
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
    final result = await PostApi.getPostList(page: pageNum);
    return result;
  }

  void jumpDetail(int index) async {
    final result = await Get.to(() => PostDetailPage(), arguments: list[index]);
    if (result != null) {
      onRefresh();
    }
  }
}
