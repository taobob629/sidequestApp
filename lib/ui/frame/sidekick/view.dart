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
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/ui/frame/sidekick/widget/horizontal_list.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/show_error_widget.dart';

import '../../../config/icon_font.dart';
import '../../../image_utils.dart';
import '../../../res/styles.dart';
import '../../../utils/storage_manager.dart';
import '../../../widget/refresh_list.dart';
import '../../common/dialog_match_top.dart';
import '../../match/filter/view.dart';
import 'widget/list_item.dart';
import 'widget/section.dart';

class SideKickPage extends StatelessWidget {
  var controller = Get.put(SideKickController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    bool? zc = StorageManager.getBoolByKey('caseView');
    if (zc == null || zc == false) {
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
            (_) =>
            ShowCaseWidget.of(context).startShowCase([addGameKey, languageKey]),
      );
    }

    controller.refreshController = RefreshController(initialRefresh: false);
    return Stack(
      children: [
        Container(
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
                leadingWidth: 150.w,
                leading: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sidekick',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21.sp,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Showcase(
                    key: addGameKey,
                    description: '点击添加你常玩的游戏',
                    child: IconButton(
                        onPressed: () => controller.toGameListPage(),
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
              HorizontalGameListWidget(),
            ],
            body: SectionWidget(
              listBody: Obx(() => biuldSmartRefresh(
                  controller.refreshController,
                  controller.pageState == PageState.sucess
                      ? body(context)
                      : controller.buildEmpty(),
                  onRefresh: () {
                    controller.onRefresh();
                  },
                  onLoad: () => controller.onLoadMore())),
            ),
          ),
        ),
        Obx(
              () => Positioned(
            bottom: controller.bottom.value,
            right: controller.right.value,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                controller.bottom.value -= details.delta.dy;
                controller.right.value -= details.delta.dx;
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.toNamed(AppPages.side_kick_match_page),
                child: Image.asset(
                  ImageUtils.iconPicMatch,
                  width: 120.w,
                  height: 80.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var model = controller.mDatas[index];
        return GameListItemWidget(model, () {
          NavigatorHelper.toOtherProfile(model.id,
              gid: controller.gameList[controller.currentSelectIndex].id);
        });
      },
      itemCount: controller.mDatas.length,
    );
  }
}
