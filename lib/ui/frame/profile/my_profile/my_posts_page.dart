import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';

import '../../social/post/view/post_list_item_view.dart';
import '../model/post_item_model.dart';

class MyPostsPage extends StatelessWidget {
  MyPostsPage({Key? key}) : super(key: key);

  final t = Get.put(ProfilePostsController());

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

class ProfilePostsController extends GetxRefreshController<PostItemModel> with GetSingleTickerProviderStateMixin {
  static ProfilePostsController get find => Get.find();

  final list = <PostItemModel>[].obs;

  @override
  void onInit() {
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
    return await ProfileApi.getPostList(page: pageNum, uid: UserController.find.userProfile.value.pwId);

    throw UnimplementedError();
  }
}
