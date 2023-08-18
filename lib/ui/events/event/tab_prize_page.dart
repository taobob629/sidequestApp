import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/utils/image_util.dart';

import '../../../res/styles.dart';
import 'event_page.dart';

class TabPrizePage extends StatelessWidget {
  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
      padding: const EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
      decoration: itemDecoration(),
      child: Obx(() => ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (c, i) => Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  ImageUtil.networkImage(
                      url: controller
                          .eventDetailModel.value.eventPrize[i].avatar,
                      width: 50.w,
                      height: 50.w,
                      border: 30.w,
                      fit: BoxFit.cover,
                      errorWidget: ExtendedImage.asset(
                        ImageUtils.default_logo,
                        shape: BoxShape.circle,
                        width: 50.w,
                        height: 50.w,
                      )),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible: i < 3,
                            child: Image.asset(
                              i == 0
                                  ? ImageUtils.icon_first
                                  : i == 1
                                      ? ImageUtils.icon_second
                                      : ImageUtils.icon_third,
                              scale: 5.6,
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            controller
                                .eventDetailModel.value.eventPrize[i].name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'DIN',
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Text(
                        controller.eventDetailModel.value.eventPrize[i].value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'DIN',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            separatorBuilder: (c, i) => Container(
              color: Colors.grey,
              height: 1.h,
            ),
            itemCount: controller.eventDetailModel.value.eventPrize.length,
          )),
    );
  }
}
