/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/ui/frame/sidekick/widget/horizontal_list.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/utils.dart';

import '../../../widget/refresh_list.dart';
import '../../match/filter/view.dart';
import 'widget/list_item.dart';
import 'widget/section.dart';

class SideKickPage extends StatelessWidget {
  var controller = Get.put(SideKickController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    controller.refreshController = RefreshController(initialRefresh: false);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_sidekick.webp'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter)),
      child: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, index) => [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leadingWidth: 200,
            leading: TextButton.icon(
              onPressed: () {
                Get.to(() => SideKickMatchPage());
              },
              icon: Container(),
              label: Text(
                'Sidekick',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.sp, color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () => Get.toNamed(AppPages.SEARCH_USER_PAGE),
                  icon: ImageUtil.assetImage('ic_search', width: 23.w, height: 23.w))
            ],
          ),
          HorizontalGameListWidget(),
        ],
        body: SectionWidget(
          listBody: Obx(() => biuldSmartRefresh(controller.refreshController,
              controller.pageState == PageState.sucess ? body(context) : controller.buildEmpty(),
              onRefresh: () {
                controller.onRefresh();
              },
              onLoad: () => controller.onLoadMore())),
        ),
      ),
    );
  }

  body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var model = controller.mDatas[index];
        return GameListItemWidget(model!!);
      },
      itemCount: controller.mDatas.length,
    );
  }
}
