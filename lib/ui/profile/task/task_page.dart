import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/profile/task/detail/task_detail_page.dart';
import 'package:wy/ui/profile/task/task_ctr.dart';
import 'package:wy/utils/index.dart';
import 'package:badges/badges.dart' as badges;

import '../../../config/app_color.dart';
import '../../common/base_scaffold.dart';

class TaskPage extends StatelessWidget {
  final t = Get.put(TaskCtr());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Task'.tr,
      body: Obx(
        () => SmartRefresher(
          controller: t.refreshController,
          onLoading: () => t.loadMore(),
          onRefresh: () => t.onRefresh(),
          enablePullUp: true,
          child: ListView.separated(
            itemCount: t.list.length,
            itemBuilder: (context, index) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (t.list[index].enabled == 0) {
                  Get.to(() => TaskDetailPage(), arguments: t.list[index]);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff262731),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r),
                          ),
                          child: ImageUtil.networkImage(
                            url: t.list[index].url,
                            height: 150.h,
                            width: Get.width - 30.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Positioned(
                        //   right: 10.w,
                        //   top: 10.h,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Color(0xff18D07A),
                        //       borderRadius: BorderRadius.circular(5.r),
                        //     ),
                        //     padding: EdgeInsets.all(4.r),
                        //     child: Text(
                        //       'ACTIVE'.tr,
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 12.sp,
                        //         fontFamily: FONT_MEDIUM,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 20.h),
                      child: badges.Badge(
                        showBadge: t.list[index].newReward > 0,
                        badgeContent: Text(
                          '${t.list[index].newReward}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        badgeColor: Color(0xffFF4848),
                        position: badges.BadgePosition(end: -16.w, top: -6.h),
                        alignment: Alignment.topRight,
                        child: Text(
                          t.list[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FONT_MEDIUM,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 22.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              20.horizontalSpace,
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: LinearProgressIndicator(
                                    value: t.list[index].userNum /
                                        t.list[index].threshold,
                                    backgroundColor: Color(0xff2D2E3A),
                                    valueColor: AlwaysStoppedAnimation(
                                      t.list[index].enabled == 0
                                          ? Color(0xffEAA18D)
                                          : Colors.grey,
                                    ),
                                    minHeight: 10.h,
                                  ),
                                ),
                              ),
                              8.horizontalSpace,
                              Text(
                                t.list[index].userNum.toString(),
                                style: TextStyle(
                                  color: t.list[index].enabled == 0
                                      ? Color(0xffEAA18D)
                                      : Colors.grey,
                                  fontFamily: FONT_MEDIUM,
                                  fontSize: 10.sp,
                                ),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: FONT_MEDIUM,
                                  fontSize: 10.sp,
                                ),
                              ),
                              Text(
                                t.list[index].threshold.toString(),
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: FONT_MEDIUM,
                                  fontSize: 10.sp,
                                ),
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Image.asset(
                            ImageUtils.icon_naicha,
                            width: 22.w,
                            height: 22.w,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1.h,
                      color: Color(0xff2D2E3A),
                      margin: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 0),
                    ),
                    Row(
                      children: [
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            t.list[index].description,
                            style: TextStyle(
                              color: Color(0xffc3c3c3),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: t.list[index].enabled == 0
                                ? AppColor.yellow
                                : Colors.grey,
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            right: 10.w,
                            top: 10.h,
                            bottom: 10.h,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          child: Text(
                            "DETAIL",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.tabBackGround,
                              fontWeight: FontWeight.bold,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                15.verticalSpace,
          ),
        ),
      ),
    );
  }
}
