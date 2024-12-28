import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../../../common/base_scaffold.dart';
import '../../../../common/colorful_button.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import 'ctr/integral_detail_ctr.dart';

class IntegralDetailPage extends StatelessWidget {
  final ctr = Get.put(IntegralDetailCtr());

  @override
  Widget build(BuildContext context) => BaseScaffold(
        title: "Details".tr,
        body: Obx(() => ctr.integralGoodsDetailModel.value.name == null
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: '${ctr.integralGoodsDetailModel.value.pic}',
                        errorWidget: (c, m, e) =>
                            Image.asset(ImageUtils.default_logo),
                        height: 200.h,
                        width: 300.w,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: 1.sw,
                        decoration: ShapeDecoration(
                          color: Color(0xFF202026),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                    "${ctr.integralGoodsDetailModel.value.price} ",
                                style: TextStyle(
                                  color: AppColor.yellow,
                                  fontSize: 20.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Points".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: FONT_LIGHT,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              '${ctr.integralGoodsDetailModel.value.name}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            Text(
                              '--------------------------------------------------------------------------------------------------------------------------------------------',
                              style: TextStyle(
                                color: hexColor('3C3C43'),
                                fontSize: 10.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                              maxLines: 1,
                            ),
                            6.verticalSpace,
                            ...ctr.integralGoodsDetailModel.value.coupons.map(
                              (e) => infoWidget(e.couponName ?? ''),
                            ),
                          ],
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
                          bottom: 48.h,
                        ),
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            10.verticalSpace,
                            infoWidget('${ctr.integralGoodsDetailModel.value.des}')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        floatingActionButton: ColorfulButton(
          margin: EdgeInsets.only(bottom: 10.h),
          child: Text(
            ctr.integralGoodsDetailModel.value.enoughPoint == true
                ? "${ctr.integralGoodsDetailModel.value.price} points"
                : "Insufficient points, earn points".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "DIN",
            ),
          ),
          height: 50.h,
          width: 0.85.sw,
          onTap: () => ctr.integralGoodsDetailModel.value.enoughPoint == true
              ? Get.dialog(
                  pointsPayWidget(),
                )
              : Get.back(),
        ),
      );

  Widget infoWidget(String des) => Platform.isAndroid
      ? Html(
          data: des,
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
          des,
          onTapUrl: (url) async => await launchUrl(Uri.parse(url)),
        );

  Widget pointsPayWidget() => Center(
        child: Container(
          width: 260.w,
          height: 300.h,
          child: Stack(
            children: [
              Container(
                width: 260.w,
                height: 260.h,
                margin: EdgeInsets.only(top: 40.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    60.verticalSpace,
                    Text(
                      'Consume points',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    30.verticalSpace,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'You will consume ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${ctr.integralGoodsDetailModel.value.price} ',
                            style: TextStyle(
                              color: Color(0xFFFFB20E),
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          TextSpan(
                            text: 'points to redeem the benefit.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => ctr.confirm(),
                      child: Container(
                        height: 40.h,
                        margin: EdgeInsets.only(
                          left: 15.w,
                          right: 15.w,
                          top: 30.h,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFF760E),
                                  Color(0xFFFFB20E)
                                ])),
                        child: Text(
                          'Confirm exchange',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Image.asset(
                  ImageUtils.integral_detail_dialog_icon,
                  fit: BoxFit.contain,
                  width: 190.w,
                  height: 90.h,
                ),
              ),
            ],
          ),
        ),
      );
}
