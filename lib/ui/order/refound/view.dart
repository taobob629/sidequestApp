/**
    author:mac
    创建日期:2023/3/24
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/order/detail/widgets/widgets.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/views.dart';

import 'controller.dart';

class OrderRefoundPage extends GetView<OrderRefoundController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Request a refund'.tr),
        ),
        resizeToAvoidBottomInset: true,
        body: Obx(() => controller.list.isEmpty ? buildLoad() : buildBody()),
        bottomNavigationBar: Obx(() => Visibility(
              visible: controller.list.isNotEmpty,
              child: FloatingButton(
                  label: "CONFIRM".tr,
                  onTap: () => Get.dialog(ConfirmDialog(
                        title: 'Warning'.tr,
                        info: 'These Coins are only used for SideKick.'.tr,
                        // onConfirm: () => controller.pay(),
                      ))),
            )));
  }

  Widget buildBody() {
    return contentPadding(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lable('Reason for application'),
          InkWell(
            onTap: () => controller.choseReason(),
            child: itemBg(rowLine(
                'reason',
                Row(
                  children: [
                    Obx(() => Text(
                          '${controller.reason?.reason??''}',
                          style: textStyle,
                        )),
                    arrowMore(color: AppColor.textSubtitle, size: 13.w)
                  ],
                ))),
          ),
          lable('Application amount'),
          itemBg(rowLine('${controller.order.priceWithSufix()}', Container())),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 10).r,
            child: Row(
              children: [
                ImageUtil.assetImage('ic_warn', width: 16.h, height: 16.h),
                5.horizontalSpace,
                Text(
                  'The order will be cancelled after the refund \n application is approved'.tr,
                  style: TextStyle(
                      fontFamily: FONT_BLACK, fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 18, right: 18).r,
              child: Text(
                'This order uses the payment before use service. The actual payment for placing the order is 0 yuan. No refund will be generated after the refund application is approved'
                    .tr,
                style: TextStyle(
                  fontFamily: FONT_LIGHT,
                  fontSize: 11.sp,
                ),
              )),
          lable('Application Description'),
          comments(),
          10.verticalSpace,
          Row(
            children: [
              Row(
                children: [
                  ImageUtil.assetImage('ic_dial', width: 18, height: 18),
                  5.horizontalSpace,
                  Text(
                    'Contact number'.tr,
                    style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 16.sp),
                  )
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  launchUrl(Uri(scheme: 'mailto', path: '$contact_emal'));
                },
                child: Text(
                  '$contact_emal',
                  style:
                      TextStyle(color: AppColor.yellow, fontFamily: FONT_MEDIUM, fontSize: 15.sp),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }

  comments() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10).r,
      alignment: Alignment.topLeft,
      decoration: itemDecoration(color: Color(0xFF313033), radius: 10.r),
      //  constraints: BoxConstraints(minHeight: 100.h, maxWidth: Get.width),
      child: TextField(
        controller: controller.etCommnetController,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        maxLength: 255,
        decoration: InputDecoration(
            border: InputBorder.none,
            counterStyle: TextStyle(color: Colors.white60),
            // labelText: 'Please write down your comments'.tr,
            hintStyle: TextStyle(color: Color(0xFFB2B9C9), fontSize: 13.sp)),
      ),
    );
  }
}

var textStyle = TextStyle(fontFamily: FONT_LIGHT, fontSize: 14.sp);

Widget lable(var text) => Container(
      padding: EdgeInsets.only(top: 15, bottom: 15).r,
      child: Text(
        '$text',
        style: TextStyle(fontSize: 16.sp, fontFamily: FONT_LIGHT),
      ),
    );

rowLine(var leftText, Widget rightWidget) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '$leftText',
        style: textStyle,
      ),
      rightWidget
    ],
  );
}

Widget itemBg(Widget view) {
  return Container(
    height: 45.h,
    padding: EdgeInsets.only(left: 14, right: 14).w,
    decoration: itemDecoration(color: Color(0xFF313033), radius: 10.r),
    child: view,
  );
}
