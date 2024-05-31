import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../api/profile_api.dart';
import '../../../../../common/getx_refresh_controller.dart';
import '../../../../../controller/user_controller.dart';
import '../../../../../model/post_item_model.dart';
import '../../../../dialog/dialog_confirm.dart';
import '../../../social/post/post_detail_page.dart';
import '../../../social/post/view/post_list_item_view.dart';

class MyReleasedPostPage extends StatelessWidget {
  const MyReleasedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Get.put(MyReleasedPostController());

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
                    isSelf: true,
                    index: index,
                    onTap: () {
                      Get.to(() => PostDetailPage(), arguments: t.list[index])?.then((value) =>t.onRefresh() );
                    },
                    onDelete: () {
                      t.deletePost(t.list[index].id);
                    },
                  );
                }, childCount: t.list.length));
              })
            ],
          )),
    );
  }
}

class MyReleasedPostController extends GetxRefreshController<PostItemModel> {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  deletePost(postId) {
    Get.dialog(ConfirmDialog(
      title: "Confirm".tr,
      info: "Are you sure to delete this post?".tr,
      concelBtn: "CANCEL".tr,
      onConfirm: () {
        Get.back();
        ProfileApi.deletePost(postId: postId).then((value) {
          onRefresh();
        });
      },
    ));
  }

  @override
  Future<List<PostItemModel>> loadData({int pageNum = 0}) async {
    return await ProfileApi.getMyPostList(page: pageNum);
  }
}
