/**
    author:mac
    创建日期:2023/3/15
    描述:
 */
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../../common/privacy_check.dart';
import '../../../../../common/styles.dart';
import '../../../../../config/app_color.dart';
import '../../../../../res/dimens.dart';
import '../../../../../utils/storage_manager.dart';
import '../../../../../widget/scaffold_widget.dart';
import '../../../../../widget/stadium_button.dart';
import '../../../../../widget/views.dart';
import '../controller.dart';
import '../widget/price_slider.dart';

class AddServiceTypePage extends GetView<AddGamePageController> {
  @override
  Widget build(BuildContext context) {
    controller.privacyCheckController = PrivacyCheckController();

    bool? sideKickNext2Key = StorageManager.getBoolByKey('sideKickNext2Key');
    // if (sideKickNext2Key == null || sideKickNext2Key == false) {
    //   ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
    //         (_) =>
    //         ShowCaseWidget.of(controller.myContext!).startShowCase([
    //           GlobalKeyConstants.sideKickNext2Key,
    //         ]),
    //   );
    // }

    return ScaffoldWidget(
        appBar: AppBar(
          title: Text('${Get.arguments}'),
        ),
        body: contentPadding(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // physics: NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.all(0),
            children: [
              itemLable('Service Types'.tr),
              PriceSliderWidget(
                showLable: false,
              ),
              10.verticalSpace,
              _addButton()
            ],
          ),
        )),
        btnBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrivacyCheck(
              controller: controller.privacyCheckController,
              type: TYPE_ADD_BANK,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16).w,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: StadiumButton(
                    'Previous'.tr,
                    textStyle:
                        const TextStyle(color: AppColor.yellow, fontSize: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.yellow,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20).r)),
                    onTap: () {
                      Get.back();
                    },
                  )),
                  16.horizontalSpace,
                  Expanded(
                    child: StadiumButton(
                      'Next'.tr,
                      onTap: () {
                        //  if (controller.privacyCheckController.check()) controller.updateService();
                        controller.toBioPage();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _addButton() {
    return DottedBorder(
      color: AppColor.yellow,
      borderType: BorderType.RRect,
      radius: Radius.circular(12.r),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12).r),
        child: InkWell(
          child: Container(
            // padding: EdgeInsets.all(6),
            color: Color(0xFF2D2E3C),
            height: 45.h,
            width: Get.width - 32.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImageUtils.ic_add, width: 20.w, height: 20.w),
                10.horizontalSpace,
                Text(
                  'Add More Service Types'.tr,
                  style: PageStyle.btnStyle,
                )
              ],
            ),
          ),
          onTap: () {
            controller.addPriceRange();
          },
        ),
      ),
    );
  }
}
