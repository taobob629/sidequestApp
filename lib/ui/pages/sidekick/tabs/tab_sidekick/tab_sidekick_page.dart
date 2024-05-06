import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../common/base_controller.dart';
import '../../../../../common/refresh_list.dart';
import '../../../../../utils/navigator_helper.dart';
import '../../widget/horizontal_list.dart';
import '../../widget/list_item.dart';
import '../../widget/section.dart';
import 'controller.dart';

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
            ? GameListItemWidget(model, () {
                NavigatorHelper.toOtherProfile(model.id,
                    gid: controller.gameList[controller.currentSelectIndex].id);
              })
            : GameListItemWidget(model, () {
                NavigatorHelper.toOtherProfile(model.id,
                    gid: controller.gameList[controller.currentSelectIndex].id);
              });
      },
      itemCount: controller.mDatas.length,
    );
  }
}
