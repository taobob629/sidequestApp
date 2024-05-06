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
import 'package:sq_hub_app/ui/pages/sidekick/search/search_page.dart';
import 'package:sq_hub_app/ui/pages/sidekick/sidekick_ctr.dart';
import 'package:sq_hub_app/ui/pages/sidekick/tabs/tab_ranking/tab_ranking_page.dart';
import 'package:sq_hub_app/ui/pages/sidekick/tabs/tab_sidekick/tab_sidekick_page.dart';

import '../../../image_utils.dart';
import '../service/view.dart';

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
                    IconButton(
                        onPressed: () => Get.to(() => MoreGamesPage()),
                        icon: Image.asset(
                          ImageUtils.ic_add,
                          width: 24.w,
                          height: 24.w,
                        )),
                    IconButton(
                      onPressed: () => Get.to(() => SearchUserPage()),
                      icon: Image.asset(
                        ImageUtils.ic_search,
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
