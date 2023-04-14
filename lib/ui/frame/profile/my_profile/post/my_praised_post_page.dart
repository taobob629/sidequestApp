import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';
import 'package:wy/common/getx_refresh_controller.dart';

import '../../../../../api_service/profile_api.dart';
import '../../../../../config/app_pages.dart';
import '../../../../controller/user_controller.dart';
import '../../../social/post/view/post_list_item_view.dart';
import '../../model/post_item_model.dart';

class MyPraisedPostPage extends StatelessWidget {
  const MyPraisedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Get.put(MyPraisedPostController());

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

class MyPraisedPostController extends GetxRefreshController<PostItemModel> {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  Future<List<PostItemModel>> loadData({int pageNum = 1}) async {
    // TODO: implement loadData
    return await ProfileApi.getMyPraisedPostList(page: pageNum, uid: UserController.find.userProfile.pwId);

    throw UnimplementedError();
  }
}
