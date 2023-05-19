import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/profile/task/detail/task_detail_page.dart';
import 'package:wy/ui/profile/task/task_ctr.dart';
import 'package:wy/utils/index.dart';

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
              onTap: () => Get.to(() => TaskDetailPage()),
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
                            url:
                                'https://up.enterdesk.com/edpic_source/2f/ca/21/2fca21e447219c2cdd31940fc9cd0a1f.jpg',
                            height: 150.h,
                            width: Get.width - 30.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10.w,
                          top: 10.h,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff18D07A),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding: EdgeInsets.all(4.r),
                            child: Text(
                              'ACTIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 30.h),
                      child: Text(
                        'Milk tea Buy ten and get one free'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FONT_MEDIUM,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        10.horizontalSpace,
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: LinearProgressIndicator(
                              value: 0.2,
                              backgroundColor: Color(0xff2D2E3A),
                              valueColor: AlwaysStoppedAnimation(Color(0xffEAA18D)),
                              minHeight: 10.h,
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          '2',
                          style: TextStyle(
                            color: Color(0xffEAA18D),
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
                          '10',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: FONT_MEDIUM,
                            fontSize: 10.sp,
                          ),
                        ),
                        10.horizontalSpace,
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
                        Text(
                          '* You have participated'.tr,
                          style: TextStyle(
                            color: Color(0xffc3c3c3),
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColor.yellow,
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
