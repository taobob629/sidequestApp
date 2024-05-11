import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/ui/pages/login/login_page.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_list_controller.dart';
import 'package:sq_hub_app/ui/pages/social/post/release_post_page.dart';
import 'package:sq_hub_app/ui/pages/social/post/view/post_list_item_view.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';

import '../../../../../config/app_color.dart';
import '../../../../../controller/user_controller.dart';
import '../../../../../image_utils.dart';

class PostListPage extends StatelessWidget {
  PostListPage({Key? key}) : super(key: key);

  final t = Get.put(PostListController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// post 列表
          Obx(() => SmartRefresher(
                controller: t.refreshController,
                onRefresh: t.onRefresh,
                onLoading: t.loadMore,
                enablePullUp: true,
                enablePullDown: true,
                child: ListView.separated(
                  itemBuilder: (c, index) => PostListItemView(
                    model: t.list[index],
                    isSelf: UserController.find.userProfile.pwId ==
                        t.list[index].uid,
                    index: index,
                    onTap: () => t.jumpDetail(index),
                  ),
                  separatorBuilder: (c, i) => Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    height: 1.h,
                    color: hexColor('141517'),
                  ),
                  itemCount: t.list.length,
                ),
              )),

          /// post 发帖按钮
          Positioned(
            right: 20,
            bottom: 15,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  var account = StorageManager.getToken();
                  if (account.isEmpty) {
                    Get.to(() => LoginPage());
                  } else {
                    Get.to(() => ReleasePostPage())?.then((value) {
                      t.onRefresh();
                    });
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                          colors: [Color(0XFFCFAB21), Color(0XFFED5A24)]),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 0.5,
                            offset: Offset(0, 1.5))
                      ]),
                  child: Image.asset(
                    ImageUtils.ic_edit_new,
                    width: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
