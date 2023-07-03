import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/frame/profile/my_profile/post/my_praised_post_page.dart';
import 'package:wy/ui/frame/profile/my_profile/post/my_released_post_page.dart';
import 'package:wy/ui/frame/profile/my_profile/post/my_replied_post_page.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../model/post_item_model.dart';

class MyPostsPage extends StatelessWidget {
  MyPostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Get.put(ProfilePostsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Posts".tr,
          style: TextStyle(fontSize: 16.sp),
        ),
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 40),
            child: Container(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 30, right: 20),
                child: Theme(
                  data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  child: TabBar(
                    controller: t.tabController,
                    isScrollable: false,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColor.textC5C5,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2,
                    unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, fontFamily: FONT_MEDIUM),
                    labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM),
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicator: BoxDecoration(),
                    tabs: [
                      Text(
                        "Post".tr,
                      ),
                      Text(
                        "Commented".tr,
                      ),
                      Text(
                        "Liked".tr,
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
      body: TabBarView(controller: t.tabController, children: [
        MyReleasedPostPage(),
        MyRepliedPostPage(),
        MyPraisedPostPage(),
      ]),
    );
  }
}

class ProfilePostsController extends GetxController with GetSingleTickerProviderStateMixin {
  static ProfilePostsController get find => Get.find();
  late TabController tabController;

  final list = <PostItemModel>[].obs;

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);

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
  // deletePost(postId) {
  //   Get.dialog(ConfirmDialog(
  //     title: "Confirm".tr,
  //     info: "Are you sure to delete this post?".tr,
  //     concelBtn: "Cancel",
  //     onConfirm: () {
  //       Get.back();
  //       ProfileApi.deletePost(postId: postId).then((value) {
  //         onRefresh();
  //       });
  //     },
  //   ));
  // }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  // @override
  // Future<List<PostItemModel>> loadData({int pageNum = 0}) async {
  //   // TODO: implement loadData
  //   return await ProfileApi.getPostList(page: pageNum, uid: UserController.find.userProfile.pwId);

  //   throw UnimplementedError();
  // }
}
