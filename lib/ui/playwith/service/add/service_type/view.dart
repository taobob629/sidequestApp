/**
    author:mac
    创建日期:2023/3/15
    描述:
 */
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/playwith/service/add/widget/price_slider.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/stadium_button.dart';

import '../controller.dart';

class AddServiceTypePage extends GetView<AddGamePageController> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments}'),
      ),
      body: contentPadding(
          child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          itemLable('Service Types'),
          PriceSliderWidget(
            showLable: false,
          ),
          10.verticalSpace,
          _addButton()
        ],
      )),
      floatingActionButton: contentPadding(
          width: Get.width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 30,
              ),
              Expanded(
                  child: StadiumButton(
                'Previous'.tr,
                textStyle: const TextStyle(color: AppColor.yellow, fontSize: 16),
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
              SizedBox(
                width: 17,
              ),
              Expanded(
                  child: StadiumButton(
                'Submit'.tr,
                onTap: () {
                  controller.updateService();
                },
              )),
            ],
          )));

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
                ImageUtil.assetImage('ic_add', imageType: IMG_PNG, width: 20.w, height: 20.w),
                10.horizontalSpace,
                Text(
                  'Add More Service Types',
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
