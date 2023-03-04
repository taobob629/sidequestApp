import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/drawer.dart';
import 'package:wy/ui/frame/home/widget/banner.dart';
import 'package:wy/ui/frame/home/widget/home_horizontal_widget.dart';

import 'controller.dart';

GlobalKey<ScaffoldState> drawerKey = GlobalKey();

class HomePage extends StatelessWidget {
  HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: HomeDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled) => [buildSliverAppBar(context)],
        body: Builder(
          builder: (context) => CustomScrollView(
            slivers: [
              BannerWidget(),
              // HomeHorizontalWidget(
              //   'Popular events',
              //   controller.games,
              // ),
              // HomeHorizontalWidget('Browse games', controller.games),
              // HomeHorizontalWidget('Top Monthly Sidekick users', controller.games),
            ],
          ),
        ),
      ),
    );
  }

  ///导航部分渲染
  Widget buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: IconButton(
        color: Colors.white54,
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(40.w),
          child: CachedNetworkImage(width: 40.w, height: 40.w, imageUrl: Get.find<UserController>().userInfoModel?.value?.avatar ?? '', fit: BoxFit.cover),
        ),
      ),
      snap: false,
      toolbarHeight: 100.w,
      //阴影
      elevation: 0,
      //背景颜色
      //一个显示在 AppBar 下方的控件，高度和 AppBar 高度一样， // 可以实现一些特殊的效果，该属性通常在 SliverAppBar 中使用
    );
  }
}
