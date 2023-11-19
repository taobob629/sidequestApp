/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/ui/frame/sidekick/sidekick_ctr.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_ranking/tab_ranking_page.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_sidekick/tab_sidekick_page.dart';
import 'package:wy/ui/frame/sidekick/widget/container_tab_indicator.dart';

import '../../../config/app_color.dart';
import '../../../config/app_pages.dart';
import '../../../config/icon_font.dart';
import '../../../image_utils.dart';
import '../../../utils/global_key_constants.dart';
import '../../../utils/image_util.dart';

class SideKickPage extends StatelessWidget {
  final controller = Get.put(SideKickCtr());

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 44.h,
                    child: TabBar(
                      controller: controller.tabbarController,
                      tabs: controller.tabsList,
                      isScrollable: true,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      indicator: BoxDecoration(),
                      onTap: (index) => controller.currentIndex.value = index,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabbarController,
                      children: [
                        TabSideKickPage(),
                        TabRankingPage(),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                child: Row(
                  children: [
                    Showcase(
                      key: GlobalKeyConstants.addGameKey,
                      description: '点击添加你常玩的游戏',
                      child: IconButton(
                          onPressed: () => Get.toNamed(AppPages.MoreGames),
                          icon: Image.asset(
                            ImageUtils.ic_add,
                            width: 24.w,
                            height: 24.w,
                          )),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(AppPages.SEARCH_USER_PAGE),
                      icon: ImageUtil.assetImage(
                        'ic_search',
                        width: 23.w,
                        height: 23.w,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
