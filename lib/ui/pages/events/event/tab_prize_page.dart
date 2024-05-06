import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/styles.dart';
import '../../../../image_utils.dart';
import 'event_page.dart';

class TabPrizePage extends StatelessWidget {
  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
      padding: const EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
      decoration: itemDecoration(),
      child: Obx(() => ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (c, i) => Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.w,
                    color: Color(0xFF424242),
                  ),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: CachedNetworkImage(
                        imageUrl: controller
                            .eventDetailModel.value.eventPrize[i].avatar,
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.cover,),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: controller.eventDetailModel.value.eventPrize[i]
                              .nickname.isNotEmpty,
                          child: Text(
                            controller
                                .eventDetailModel.value.eventPrize[i].nickname,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'DIN',
                            ),
                          ),
                        ),
                        4.verticalSpace,
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
                            Visibility(
                              visible: i < 3,
                              child: 6.horizontalSpace,
                            ),
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
                            fontSize: 14.sp,
                            fontFamily: 'DIN',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            itemCount: controller.eventDetailModel.value.eventPrize.length,
          )),
    );
  }
}
