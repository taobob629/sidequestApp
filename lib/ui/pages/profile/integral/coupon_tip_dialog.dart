import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/colorful_button.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:sq_hub_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../../../common/dialog_selector.dart';
import '../../../../config/app_color.dart';
import '../../../../image_utils.dart';
import '../../../../model/integral_lv_model.dart';
import '../../../../utils/toast_utils.dart';
import 'ctr/integral_interests_ctr.dart';

class CouponTipDialog extends StatelessWidget {
  final dynamic info;
  final int limitConnectionsCount;
  final String? confirmBtn;
  final Function? onConfirm;
  // 是否有计算器
  final bool? isCal;
  final TextEditingController editingController =
      TextEditingController(text: "6");
  var addFriendList = <double>[].obs;
  var yourLevelModel = IntegralLevelModel().obs;

  // 添加朋友的限制
  var friendLimitCount = 2.obs;
  var calPrice = "0.00".obs;
  List<IntegralLevelModel> lvList = [];

  CouponTipDialog({
    this.info,
    this.limitConnectionsCount = 0,
    this.isCal,
    this.confirmBtn = "OK",
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    if (isCal == false) {
      return view1(context);
    }
    for (int i = 0; i <= 6; i++) {
      IntegralLevelModel model = IntegralLevelModel();
      model.zhekou = 1 - i * 5 / 100;
      model.name = "Level $i(${i * 5}%)";
      model.model = "Level $i(${i * 5}%)".obs;
      switch (i) {
        case 0:
        case 1:
        case 2:
          model.friendLimitCount = 2;
          break;
        case 3:
        case 4:
          model.friendLimitCount = 3;
          break;
        case 5:
        case 6:
          model.friendLimitCount = 4;
          break;
      }
      lvList.add(model);
    }

    IntegralInterestsCtr.find.currentVIPIndex.value + 1 > 5
        ? yourLevelModel.value = lvList[5]
        : yourLevelModel.value =
            lvList[IntegralInterestsCtr.find.currentVIPIndex.value + 1];

    calPrice.value =
        editingController.text.mul(yourLevelModel.value.zhekou.toString());

    return view2(context);
  }

  /// 没有计算器
  Widget view1(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hexColor('#202026'),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.all(15.r),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Platform.isAndroid
              ? Html(
                  data: info["description"],
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
                  info["description"],
                  onTapUrl: (url) async => await launchUrl(Uri.parse(url)),
                ),
          InkWell(
            onTap: () =>
                onConfirm == null ? dismissLoading() : onConfirm!.call(),
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xFFFFB20E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              margin: EdgeInsets.only(top: 15.h),
              alignment: Alignment.center,
              child: Text(
                "$confirmBtn".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.bold,
                ),
              ),
              height: 40.h,
            ),
          ),
        ],
      ),
    );
  }

  /// 有计算器
  Widget view2(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hexColor('#202026'),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: 0.8.sh,
      ),
      padding: EdgeInsets.all(15.r),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(
                  ImageUtils.icon_invitation,
                  width: 40.w,
                  height: 40.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${info['title']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          color: Colors.white,
                        ),
                      ),
                      Visibility(
                        visible: info['notes'] != null,
                        child: 10.verticalSpace,
                      ),
                      Visibility(
                        visible: info['notes'] != null,
                        child: Text(
                          '${info['notes']}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                            color: hexColor('#FFB20E'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: hexColor('#3C3C43'),
              height: 1.h,
              margin: EdgeInsets.only(top: 14.h, bottom: 14.h),
            ),
            Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: hexColor('#3DD84D'),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 8.w),
                  child: Text(
                    "01",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Play with Friends discount".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "Receive the gaming rate discount when gaming simultaneously with your Connections.\nAt this Level, the discount can be applied with up to $limitConnectionsCount different Connections.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ).paddingOnly(top: 13.h),
            Text(
              "Enter Base Hourly Price (£):",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ).paddingOnly(top: 13.h, bottom: 10.h),
            addAndMinusWidget(),
            Text(
              "Your Level:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ).paddingOnly(top: 16.h, bottom: 13.h),
            Obx(() => selectWidget(
                  onTap: () async {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    final result = await showCustom(
                      SelectorDialog(
                        items: lvList,
                        title: "Select Level".tr,
                        isSmartDialog: true,
                      ),
                    );
                    if (result != null) {
                      IntegralLevelModel selectModel =
                          result as IntegralLevelModel;
                      addFriendList.clear();
                      yourLevelModel.value = selectModel;

                      if (editingController.text.isNotEmpty) {
                        calPrice.value = editingController.text
                            .mul(selectModel.zhekou.toString());
                      }
                    }
                  },
                  yourLevel: yourLevelModel.value.name,
                )),
            Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: hexColor('#3DD84D'),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 8.w),
                  child: Text(
                    "02",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Friends Discounts (based on levels)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).paddingOnly(bottom: 14.h),
            Obx(() => ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Friend ${i + 1} Level:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ).paddingOnly(right: 10.w),
                      Expanded(
                        child: Obx(() => selectWidget(
                              bottom: 0,
                              yourLevel: getLevelName(addFriendList[i]),
                              onTap: () async {
                                final result = await showCustom(
                                  SelectorDialog(
                                    items: lvList,
                                    title: "Select Level".tr,
                                    isSmartDialog: true,
                                  ),
                                );
                                if (result != null) {
                                  IntegralLevelModel selectModel =
                                      result as IntegralLevelModel;
                                  addFriendList[i] = selectModel.zhekou;

                                  final ji = addFriendList.fold(
                                      1.0,
                                      (previousValue, element) =>
                                          previousValue * element);
                                  if (editingController.text.isNotEmpty) {
                                    calPrice.value = yourLevelModel.value.zhekou
                                        .toString()
                                        .mul(editingController.text
                                            .mul(ji.toString()));
                                  }
                                }
                              },
                            )),
                      ),
                    ],
                  ),
                  separatorBuilder: (c, i) => 14.verticalSpace,
                  itemCount: addFriendList.length,
                )),
            20.verticalSpace,
            Obx(() => Visibility(
                  visible: addFriendList.isNotEmpty,
                  child: Text(
                    "Note:You can add up to ${yourLevelModel.value.friendLimitCount} friends",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(bottom: 20.h),
                )),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => addFriendList.length <
                            yourLevelModel.value.friendLimitCount - 1
                        ? addFriendList.add(1.0)
                        : showToast(
                            " You have reached the maximum friends combo at this level"),
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hexColor('#FFB20E'),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(38.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: hexColor('#FFB20E'),
                          ),
                          Text(
                            "Add Friend".tr,
                            style: TextStyle(
                              color: hexColor('#FFB20E'),
                              fontSize: 14.sp,
                              fontFamily: FONT_LIGHT,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: InkWell(
                    onTap: () => addFriendList.length == 1
                        ? addFriendList.clear()
                        : addFriendList.removeLast(),
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hexColor('#5E6B84'),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(38.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            "Remove last friend".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_LIGHT,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ColorfulButton(
              child: Text(
                "Calculate Final Price".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              borderRadius: 15.r,
              height: 40,
              margin: EdgeInsets.only(top: 24.h, bottom: 20.h),
              onTap: () {
                final ji = addFriendList.fold(
                    1.0, (previousValue, element) => previousValue * element);
                if (editingController.text.isNotEmpty) {
                  calPrice.value = yourLevelModel.value.zhekou
                      .toString()
                      .mul(editingController.text.mul(ji.toString()));
                }
              },
            ),
            Text(
              "Calculation Result".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_LIGHT,
              ),
            ),
            Obx(() => RichText(
                  text: TextSpan(
                      text: "Final price after discounts: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "£${double.parse(calPrice.value).toStringAsFixed(2)}",
                          style: TextStyle(
                            color: hexColor('#FFB20E'),
                            fontSize: 20.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ]),
                )),
            Container(
              color: hexColor('#3C3C43'),
              height: 1.h,
              margin: EdgeInsets.only(top: 14.h, bottom: 14.h),
            ),
            Platform.isAndroid
                ? Html(
                    data: info["description"],
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
                    info["description"],
                    onTapUrl: (url) async => await launchUrl(Uri.parse(url)),
                  ),
            InkWell(
              onTap: () =>
                  onConfirm == null ? dismissLoading() : onConfirm!.call(),
              child: Container(
                decoration: ShapeDecoration(
                  color: Color(0xFFFFB20E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$confirmBtn".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height: 40.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addAndMinusWidget() => Container(
        height: 32.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: hexColor('5E6B84'),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                if (editingController.text.isNotEmpty) {
                  editingController.text =
                      double.parse(editingController.text.minus("1")) < 0
                          ? "1"
                          : editingController.text.minus("1");
                  editingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: editingController.text.length),
                  );
                }
              },
              child: Container(
                width: 32.h,
                height: 32.h,
                decoration: BoxDecoration(
                  color: hexColor('5E6B84'),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3.r),
                    bottomLeft: Radius.circular(3.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: editingController,
                maxLines: 1,
                cursorColor: Colors.white70,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'), // 允许数字和小数点
                  ),
                ],
                decoration: InputDecoration(
                  hintText: "0.00",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.whiteGray,
                  ),
                  isCollapsed: true,
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                if (editingController.text.isNotEmpty) {
                  editingController.text = editingController.text.add("1");
                  editingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: editingController.text.length),
                  );
                }
              },
              child: Container(
                width: 32.h,
                height: 32.h,
                decoration: BoxDecoration(
                  color: hexColor('5E6B84'),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3.r),
                    bottomRight: Radius.circular(3.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  String getLevelName(double targetZhekou) {
    IntegralLevelModel? result = lvList.firstWhereOrNull(
      (model) => model.zhekou == targetZhekou,
    );
    return result?.name ?? lvList[0].name;
  }

  Widget selectWidget({
    double? bottom,
    Function? onTap,
    required String yourLevel,
  }) =>
      InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          height: 34.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: hexColor('5E6B84'),
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          margin: EdgeInsets.only(bottom: bottom ?? 14.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  yourLevel ?? "Level 0(0%)".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
}
