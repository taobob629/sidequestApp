import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../../../common/colorful_button.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../widget/progress_bar/with_icon_progress_bar.dart';
import 'ctr/integral_task_detail_ctr.dart';

class IntegralTaskDetailPage extends StatelessWidget {
  final ctr = Get.put(IntegralTaskDetailCtr());

  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        height: 1.sh,
        color: AppColor.background,
        child: Obx(() => ctr.model.value.taskName == null
            ? Container()
            : Stack(
                children: [
                  Image.asset(
                    ImageUtils.integral_task_detail_top,
                    fit: BoxFit.fill,
                    width: 1.sw,
                    height: 280.h,
                  ),
                  SafeArea(
                    child: Container(
                      height: 40.h,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 100,
                    top: 230.h,
                    child: Container(
                      width: 1.sw,
                      height: 1.sh,
                      decoration: BoxDecoration(
                        color: Color(0xFF161819),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 74.h,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff4B3B28),
                                  Color(0xff161819),
                                ],
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.h, right: 6.w),
                                  child: Image.asset(
                                    ImageUtils.integral_checkin_icon,
                                    height: 30.h,
                                  ),
                                ),
                                Text(
                                  '${ctr.model.value.pointsNum} Points',
                                  style: TextStyle(
                                    color: Color(0xFFFFB20E),
                                    fontSize: 16.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Text(
                              '${ctr.model.value.taskName}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                          ),
                          Container(
                            width: 340.w,
                            margin: EdgeInsets.only(
                              left: 16.w,
                              top: 14.h,
                              bottom: 6.h,
                            ),
                            child: WithIconProgressBar(
                              size: 6.h,
                              currentValue:
                                  ((ctr.model.value.nowTaskDetail?.myNum ?? 0)
                                              .toDouble() *
                                          100) /
                                      (ctr.model.value.nowTaskDetail?.maxNum ??
                                              1)
                                          .toDouble(),
                              // 这里的高度和下面的icon的Container高度要一致
                              outBoxHeight: 18.w,
                              // 这里的宽度是为了计算百分比的，要和WithIconProgressBar的父组件Container的宽度要一致
                              outBoxWidth: 340.w,
                              progressGradient: LinearGradient(colors: [
                                hexColor('#FFB20E'),
                                hexColor('#5D61EC'),
                              ]),
                              backgroundColor: hexColor('#45494B'),
                              icon: Container(
                                width: 18.w,
                                height: 18.w,
                                decoration: BoxDecoration(
                                  color: hexColor('#FFB20E'),
                                  borderRadius: BorderRadius.circular(18.w),
                                ),
                                child: SvgPicture.asset(ImageUtils.icon_flash),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.sw,
                            decoration: ShapeDecoration(
                              color: Color(0xFF202026),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            margin: EdgeInsets.only(
                              top: 10.h,
                              left: 15.w,
                              right: 15.w,
                            ),
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task description'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                ),
                                10.verticalSpace,
                                Platform.isAndroid
                                    ? Html(
                                        data: '${ctr.model.value.description}',
                                        style: {"body": Style()},
                                        onLinkTap: (
                                          String? url,
                                          RenderContext context,
                                          Map<String, String> attributes,
                                          dom.Element? element,
                                        ) async {
                                          if (url != null) {
                                            await launchUrl(Uri.parse(url));
                                          }
                                        },
                                      )
                                    : HtmlWidget(
                                        '${ctr.model.value.description}',
                                        onTapUrl: (url) async =>
                                            await launchUrl(Uri.parse(url)),
                                      ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 1.sw,
                              decoration: ShapeDecoration(
                                color: Color(0xFF202026),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              margin: EdgeInsets.only(
                                top: 10.h,
                                left: 15.w,
                                right: 15.w,
                              ),
                              padding: EdgeInsets.all(20.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'History records'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                  ).paddingOnly(bottom: 16.h),
                                  Expanded(
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (c, i) => Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${ctr.model.value.taskName}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.sp,
                                                    fontFamily: FONT_MEDIUM,
                                                  ),
                                                ).paddingOnly(bottom: 10.h),
                                                Text(
                                                  '${ctr.model.value.taskDetailList[i].createTime}',
                                                  style: TextStyle(
                                                    color: hexColor('#9CA3AF'),
                                                    fontSize: 12.sp,
                                                    fontFamily: FONT_MEDIUM,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            ctr.model.value.taskDetailList[i]
                                                        .taskState ==
                                                    1
                                                ? 'Received'.tr
                                                : 'Unclaimed'.tr,
                                            style: TextStyle(
                                              color: ctr
                                                          .model
                                                          .value
                                                          .taskDetailList[i]
                                                          .taskState ==
                                                      1
                                                  ? hexColor('#5ECA46')
                                                  : Colors.white,
                                              fontSize: 16.sp,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          ),
                                        ],
                                      ),
                                      separatorBuilder: (c, i) => Container(
                                        color: hexColor('#3C3C43'),
                                        height: 1.h,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                      ),
                                      itemCount:
                                          ctr.model.value.taskDetailList.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    right: 16.w,
                    bottom: 20.h,
                    child: ColorfulButton(
                      child: Text(
                        "To Complete".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: FONT_LIGHT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      height: 50.h,
                      onTap: () => Get.back(result: true),
                    ),
                  ),
                ],
              )),
      );
}
