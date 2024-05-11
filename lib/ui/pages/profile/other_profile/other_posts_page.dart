import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/common/getx_refresh_controller.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../api/profile_api.dart';
import '../../../../config/app_color.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../model/player_info_mdoel.dart';
import '../../../../model/post_item_model.dart';
import '../../../../widget/cs_photo_viewer.dart';
import '../../../../widget/like_button/like_button.dart';
import '../../social/post/post_detail_page.dart';
import '../../social/post/post_list_controller.dart';

class OtherPostsPage extends StatelessWidget {
  OtherPostsPage({Key? key}) : super(key: key);

  final t = Get.put(OtherPostsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF141517),
      child: SmartRefresher(
          controller: t.refreshController,
          onRefresh: t.onRefresh,
          onLoading: t.loadMore,
          enablePullUp: true,
          enablePullDown: true,
          child: Obx(() => WaterfallFlow.builder(
            padding: EdgeInsets.all(5.0.r),
            gridDelegate:
            SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.r,
              mainAxisSpacing: 10.r,
            ),
            itemBuilder: (BuildContext c, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.to(() => PostDetailPage(),
                    arguments: t.list[index]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (t.list[index].imageList.isNotEmpty)
                      GestureDetector(
                        onTap: () => Get.dialog(
                          CsPhotoViewer(
                            photoList: t.list[index].imageList,
                            tapIndex: t.list[index].imageList
                                .indexOf(
                                t.list[index].imageList[0]),
                          ),
                          useSafeArea: false,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.r),
                            topLeft: Radius.circular(8.r),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: t.list[index].imageList[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            itemCount: t.list.length,
          )),),
    );
  }
}

class OtherPostsController extends GetxRefreshController<PostItemModel>
    with GetSingleTickerProviderStateMixin {
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
