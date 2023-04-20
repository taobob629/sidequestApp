import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/frame/profile/my_profile/post/my_praised_post_page.dart';
import 'package:wy/ui/frame/profile/my_profile/post/my_released_post_page.dart';
import 'package:wy/ui/frame/profile/my_profile/post/my_replied_post_page.dart';
import 'package:wy/widget/tab_widget.dart';

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
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 30, right: 20),
                child: TabBar(
                  controller: t.tabController,
                  isScrollable: false,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColor.textC5C5,
                  indicatorColor: Color(0xFFFFCB0D),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2,
                  unselectedLabelStyle: unSelectTabStyle(TAB_STYLE_2),
                  labelStyle: selectTabStyle(TAB_STYLE_2) ,
                  indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
                  indicatorPadding: EdgeInsets.only(bottom: 5),
                  labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                 // unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM),
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
