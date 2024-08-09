import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/common/base_scaffold.dart';
import 'package:sq_hub_app/common/empty_view.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../api/index_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../config/app_color.dart';
import '../../../model/what_on_event_model.dart';
import '../events/event/event_page.dart';

class TabEventsPage extends StatelessWidget {
  final controller = Get.put(TabEventsPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Events'.tr,
      body: Obx(() => SmartRefresher(
            controller: controller.refreshController,
            onLoading: () => controller.loadMore(),
            onRefresh: () => controller.onRefresh(),
            enablePullUp: true,
            child: controller.list.isNotEmpty
                ? ListView.separated(
                    itemBuilder: (c, i) => InkWell(
                      onTap: () => Get.to(() => EventPage(
                            id: controller.list[i].id,
                            type: controller.list[i].matchDiff,
                          )),
                      child: Container(
                        decoration: BoxDecoration(
                          color: hexColor('141414'),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: 6.h,
                          bottom: 15.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 164.h,
                              width: 1.sw,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${controller.list[i].image}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 8.h,
                              ),
                              child: Text(
                                '${controller.list[i].title}',
                                style: TextStyle(
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 8.h,
                              ),
                              child: Text(
                                '${controller.list[i].time}',
                                style: TextStyle(
                                  fontFamily: FONT_LIGHT,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                            Container(
                              width: 1.sw,
                              height: 1.h,
                              color: hexColor('303030'),
                              margin: EdgeInsets.symmetric(
                                vertical: 8.h,
                              ),
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible: controller.list[i].joins.isNotEmpty,
                                  child: SizedBox(
                                    width: controller.getJoinPeopleWidth(i),
                                    height: 34.w,
                                    child: Stack(
                                      children: [
                                        if (controller.list[i].joins.length > 3)
                                          Positioned(
                                            top: 0,
                                            left: 36.w,
                                            child: ImageUtil.networkImage(
                                              url:
                                                  '${controller.list[i].joins[3].photo}',
                                              fit: BoxFit.fill,
                                              border: 24.w,
                                              height: 24.w,
                                              width: 24.w,
                                            ),
                                          ),
                                        if (controller.list[i].joins.length > 2)
                                          Positioned(
                                            top: 0,
                                            left: 24.w,
                                            child: ImageUtil.networkImage(
                                              url:
                                                  '${controller.list[i].joins[2].photo}',
                                              fit: BoxFit.fill,
                                              border: 24.w,
                                              height: 24.w,
                                              width: 24.w,
                                            ),
                                          ),
                                        if (controller.list[i].joins.length > 1)
                                          Positioned(
                                            top: 0,
                                            left: 12.w,
                                            child: ImageUtil.networkImage(
                                              url:
                                                  '${controller.list[i].joins[1].photo}',
                                              fit: BoxFit.fill,
                                              border: 24.w,
                                              height: 24.w,
                                              width: 24.w,
                                            ),
                                          ),
                                        if (controller.list[i].joins.isNotEmpty)
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: ImageUtil.networkImage(
                                              url:
                                                  '${controller.list[i].joins[0].photo}',
                                              fit: BoxFit.fill,
                                              border: 24.w,
                                              height: 24.w,
                                              width: 24.w,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: controller.list[i].joins.isNotEmpty
                                      ? RichText(
                                          text: TextSpan(
                                            text:
                                                " ${controller.list[i].joins.length} ",
                                            style: TextStyle(
                                              color: hexColor('FFB20E'),
                                              fontSize: 10.sp,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " attendees will join",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ),
                                Container(
                                  width: 78.w,
                                  height: 34.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      width: 1.w,
                                      color: hexColor('FFB20E'),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Join',
                                    style: TextStyle(
                                      color: hexColor('FFB20E'),
                                      fontFamily: FONT_MEDIUM,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (c, i) => 10.verticalSpace,
                    itemCount: controller.list.length,
                  )
                : EmptyView(),
          )),
    );
  }
}

class TabEventsPageController extends GetxRefreshController<WhatOnEventModel> {
  static TabEventsPageController get find => Get.find();

  @override
  Future<List<WhatOnEventModel>> loadData({int pageNum = 1}) async {
    List<WhatOnEventModel> list = await IndexApi.getEvents(pageNum, pageSize);
    return list;
  }

  double getJoinPeopleWidth(int i) {
    if (list[i].joins.length > 3) {
      return 72.w;
    } else if (list[i].joins.length > 2) {
      return 60.w;
    } else if (list[i].joins.length > 1) {
      return 48.w;
    }
    return 36.w;
  }
}
