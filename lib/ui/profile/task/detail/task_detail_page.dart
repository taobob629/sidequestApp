import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/profile/task/detail/task_detail_ctr.dart';

import '../../../../config/icon_font.dart';
import '../../../../utils/image_util.dart';
import '../../../common/base_scaffold.dart';

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
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: ImageUtil.networkImage(
                              url: ctr.taskModel.url,
                              height: 110.h,
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
                          //       'ACTIVE',
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, top: 20.h),
                      child: Text(
                        'Info'.tr,
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
                          Stack(
                            children: [
                              Container(
                                height: 22.w,
                                margin: EdgeInsets.only(left: 10.w),
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
                                              Color(0xffEAA18D)),
                                          minHeight: 10.h,
                                        ),
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Text(
                                      ctr.taskModel.userNum.toString(),
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
                                ImageUtils.icon_naicha,
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
                            children: [
                              Text(
                                'Name: '.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                ctr.taskModel.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
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
                                      ctr.getTime(
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
                                      children: [
                                        Image.asset(
                                          ImageUtils.icon_naicha,
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
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Visibility(
                                          visible: ctr.model?.rewards[i].draw ==
                                                  0 &&
                                              !ctr.ifShowExpired(
                                                  ctr.model?.rewards[i].draw ??
                                                      0,
                                                  ctr.model?.rewards[i]
                                                          .createtime ??
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
                                          ctr.model?.rewards[i].createtime ??
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
