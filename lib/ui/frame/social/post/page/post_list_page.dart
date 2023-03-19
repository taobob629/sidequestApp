import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/social/post/contorller/post_list_controller.dart';
import 'package:wy/ui/frame/social/post/view/post_list_item_view.dart';

class PostListPage extends StatelessWidget {
  PostListPage({Key? key}) : super(key: key);

  final t = Get.put(PostListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// post 列表
          SmartRefresher(
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

          /// post 发帖按钮
          Positioned(
              right: 20,
              bottom: 15,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppPages.ReleasePost)?.then((value) {
                      t.onRefresh();
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(colors: [Color(0XFFCFAB21), Color(0XFFED5A24)]),
                        boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 0.5, offset: Offset(0, 1.5))]),
                    child: Image.asset(
                      "assets/images/ic_edit_new.webp",
                      width: 22,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
