import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/profile/task/detail/task_detail_ctr.dart';

import '../../../../../common/base_scaffold.dart';
import '../../../../../config/icon_font.dart';
import '../../../../../image_utils.dart';
import '../../../../../utils/navigator_helper.dart';
import '../../../../../utils/time_utils.dart';
import '../task_page.dart';

class TaskDetailPage extends StatelessWidget {
  final ctr = Get.put(TaskDetailCtr());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Task Detail'.tr,
      body: GetBuilder<TaskDetailCtr>(
          builder: (builder) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: ExtendedImage.network(
                          ctr.taskModel.url,
                          height: 110.h,
                          width: Get.width - 30.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, top: 20.h, right: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Info'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 16.sp,
                            ),
                          ),
                          Visibility(
                            visible: ctr.taskModel.target != null,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => NavigatorHelper.gotoConfigTarget(
                                  ctr.taskModel.target!),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 20.w),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  gradient: LinearGradient(colors: [
                                    Color(0xff766AB4),
                                    Color(0xff9345AD),
                                  ], tileMode: TileMode.decal),
                                ),
                                child: Text(
                                  'GO'.tr,
                                  style: TextStyle(
                                      fontFamily: FONT_MEDIUM, fontSize: 13.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                          Stack(
                            children: [
                              Container(
                                height: 22.w,
                                padding: EdgeInsets.only(left: 4.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                        child: LinearProgressIndicator(
                                          value: ctr.taskModel.userNum /
                                              ctr.taskModel.threshold,
                                          backgroundColor: Color(0xff2D2E3A),
                                          valueColor: AlwaysStoppedAnimation(
                                              Color(0xffFFD20E)),
                                          minHeight: 10.h,
                                        ),
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Text(
                                      ctr.taskModel.userNum.toString(),
                                      style: TextStyle(
                                        color: Color(0xffFFD20E),
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
                                      ctr.taskModel.threshold.toString(),
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontFamily: FONT_MEDIUM,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                ImageUtils.icon_task_gift,
                                width: 22.w,
                                height: 22.w,
                              ),
                            ],
                          ),
                          Container(
                            height: 1.h,
                            color: Color(0xff2D2E3A),
                            margin: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: '.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ctr.taskModel.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rule: '.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ctr.taskModel.description,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ctr.model?.rewards.isNotEmpty == true,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 15.w,
                          top: 10.h,
                        ),
                        child: Text(
                          'Record'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FONT_MEDIUM,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: ctr.model?.rewards.isNotEmpty == true,
                      child: Container(
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
                                      TimeUtils.convertTime(
                                          ctr.model?.rewards[i].createtime ??
                                              0),
                                      style: TextStyle(
                                        color: Color(0xffB2B9C9),
                                        fontSize: 12.sp,
                                        fontFamily: FONT_LIGHT,
                                      ),
                                    ),
                                    Container(
                                      height: 1.h,
                                      color: Color(0xff2D2E3A),
                                      margin:
                                          EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          ImageUtils.ic_coupons_new,
                                          width: 20.w,
                                          height: 19.h,
                                        ),
                                        8.horizontalSpace,
                                        Expanded(
                                          child: Text(
                                            ctr.model?.rewards[i].couponName ??
                                                '',
                                            style: TextStyle(
                                              color: Color(0xffffffff),
                                              fontSize: 14.sp,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: ctr.model?.rewards[i].draw ==
                                                  0 &&
                                              !ctr.ifShowExpired(
                                                  ctr.model?.rewards[i].draw ??
                                                      0,
                                                  ctr.model?.rewards[i]
                                                          .expireState ??
                                                      0),
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () => ctr.receive(
                                                ctr.model?.rewards[i].id ?? 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14.r),
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xFFEAA18D),
                                                    Color(0xFFE66A47)
                                                  ],
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 6.h),
                                              child: Text(
                                                'Receive',
                                                style: TextStyle(
                                                  color: Color(0xffffffff),
                                                  fontSize: 14.sp,
                                                  fontFamily: FONT_MEDIUM,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: ctr.model?.rewards[i].draw == 1,
                                  child: Positioned(
                                    right: 0,
                                    child: Image.asset(
                                      ImageUtils.task_received_icon,
                                      width: 45.w,
                                      height: 40.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: ctr.model?.rewards[i].draw == 0 &&
                                      ctr.ifShowExpired(
                                          ctr.model?.rewards[i].draw ?? 0,
                                          ctr.model?.rewards[i].expireState ??
                                              0),
                                  child: Positioned(
                                    right: 0,
                                    child: Image.asset(
                                      ImageUtils.task_expired_icon,
                                      width: 45.w,
                                      height: 40.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          separatorBuilder: (c, i) => 10.verticalSpace,
                          itemCount: ctr.model?.rewards.length ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
