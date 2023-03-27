import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_pages.dart';

import '../../social/post/view/post_list_item_view.dart';
import '../model/post_item_model.dart';
import 'mdoel/player_info_mdoel.dart';

class OtherPostsPage extends StatelessWidget {
  OtherPostsPage({Key? key}) : super(key: key);

  final t = Get.put(OtherPostsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
          controller: t.refreshController,
          onRefresh: t.onRefresh,
          onLoading: t.loadMore,
          enablePullUp: true,
          enablePullDown: true,
          child: CustomScrollView(
            slivers: [
              Obx(() {
                return SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return PostListItemView(
                    model: t.list[index],
                    onTap: () {
                      Get.toNamed(AppPages.PostDetail, arguments: t.list[index]);
                    },
                  );
                }, childCount: t.list.length));
              })
            ],
          )),
    );
  }
}

class OtherPostsController extends GetxRefreshController<PostItemModel> with GetSingleTickerProviderStateMixin {
  static OtherPostsController get find => Get.find();

  final list = <PostItemModel>[].obs;
  PlayerInfoModel player = PlayerInfoModel();

  @override
  void onInit() {
    player = Get.arguments;

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // praisePost(PostItemModel post) {
  //   ProfileApi.praisePost(postId: post.uid).then((value) {
  //   });
  // }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<PostItemModel>> loadData({int pageNum = 0}) async {
    // TODO: implement loadData
    return await ProfileApi.getPostList(page: pageNum, uid: player.uid);

    throw UnimplementedError();
  }
}
