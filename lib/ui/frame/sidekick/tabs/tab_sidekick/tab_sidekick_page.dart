import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_sidekick/controller.dart';
import 'package:wy/ui/frame/sidekick/widget/horizontal_list.dart';
import 'package:wy/ui/frame/sidekick/widget/list_item.dart';
import 'package:wy/ui/frame/sidekick/widget/section.dart';

import '../../../../../common/base_controller.dart';
import '../../../../../config/app_pages.dart';
import '../../../../../image_utils.dart';
import '../../../../../utils/global_key_constants.dart';
import '../../../../../utils/navigator_helper.dart';
import '../../../../../widget/refresh_list.dart';

class TabSideKickPage extends StatelessWidget {
  var controller = Get.put(TabSideKickController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    controller.refreshController = RefreshController(initialRefresh: false);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_sidekick.webp'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          margin: EdgeInsets.only(top: 10.h),
          child: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, index) => [
              HorizontalGameListWidget(),
            ],
            body: SectionWidget(
              listBody: Obx(() => biuldSmartRefresh(
                  controller.refreshController,
                  controller.pageState == PageState.sucess
                      ? body(context)
                      : controller.buildEmpty(),
                  onRefresh: () => controller.onRefresh(),
                  onLoad: () => controller.onLoadMore())),
            ),
          ),
        ),
        // Obx(
        //   () => Positioned(
        //     bottom: controller.bottom.value,
        //     right: controller.right.value,
        //     child: Showcase(
        //       key: GlobalKeyConstants.matchKey,
        //       description: 'Automatically find corresponding playmates'.tr,
        //       child: GestureDetector(
        //         onPanUpdate: (DragUpdateDetails details) {
        //           controller.bottom.value -= details.delta.dy;
        //           controller.right.value -= details.delta.dx;
        //         },
        //         behavior: HitTestBehavior.translucent,
        //         onTap: () => Get.toNamed(AppPages.side_kick_match_page),
        //         child: Image.asset(
        //           ImageUtils.iconPicMatch,
        //           width: 120.w,
        //           height: 80.h,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var model = controller.mDatas[index];
        return index == 0
            ? Showcase(
                key: GlobalKeyConstants.sideKickItemKey,
                description:
                    'Choose the companion you want to place an order with'.tr,
                child: GameListItemWidget(model, () {
                  NavigatorHelper.toOtherProfile(model.id,
                      gid: controller
                          .gameList[controller.currentSelectIndex].id);
                }))
            : GameListItemWidget(model, () {
                NavigatorHelper.toOtherProfile(model.id,
                    gid: controller.gameList[controller.currentSelectIndex].id);
              });
      },
      itemCount: controller.mDatas.length,
    );
  }
}
