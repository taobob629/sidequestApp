import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/image_utils.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/image_util.dart';
import '../../../common/base_scaffold.dart';

class TaskDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Task Detail'.tr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: ImageUtil.networkImage(
                      url:
                          'https://up.enterdesk.com/edpic_source/2f/ca/21/2fca21e447219c2cdd31940fc9cd0a1f.jpg',
                      height: 110.h,
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
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w, top: 20.h),
              child: Text(
                'Activity Rules'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: FONT_MEDIUM,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff262731),
                borderRadius: BorderRadius.circular(15.r),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
              padding: EdgeInsets.all(15.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: LinearProgressIndicator(
                            value: 0.2,
                            backgroundColor: Color(0xff2D2E3A),
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xffEAA18D)),
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
                    ],
                  ),
                  Container(
                    height: 1.h,
                    color: Color(0xff2D2E3A),
                    margin: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                  ),
                  Row(
                    children: [
                      Text(
                        '活动名称： ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        'hahaha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        '活动时间： ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        'hahaha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        '活动规则： ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        'hahaha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15.w,
              ),
              child: Text(
                'Active record'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: FONT_MEDIUM,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff262731),
                borderRadius: BorderRadius.circular(15.r),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
              padding: EdgeInsets.all(15.r),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: Color(0xffFFBCAD),
                      width: 0.5.w,
                    ),
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2021-12-23 12:00:00',
                            style: TextStyle(
                              color: Color(0xffB2B9C9),
                              fontSize: 12.sp,
                              fontFamily: FONT_LIGHT,
                            ),
                          ),
                          Container(
                            height: 1.h,
                            color: Color(0xff2D2E3A),
                            margin: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                ImageUtils.eruption_flag_icon,
                                width: 20.w,
                                height: 19.h,
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: Text(
                                  'Get a cup of milk tea',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 14.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Color(0xFFEAA18D), Color(0xFFE66A47)],
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 6.h),
                                child: Text(
                                  'Receive',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 14.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        child: Image.asset(
                          ImageUtils.task_received_icon,
                          width: 45.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (c, i) => 10.verticalSpace,
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
