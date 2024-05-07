import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../config/icon_font.dart';
import '../../../getx_ctr/bubble_tea_detail_ctr.dart';
import '../../../getx_ctr/bundles_detail_ctr.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../widget/tag/simple_tags.dart';
import '../../../widget/tag/tag_bean.dart';

class BubbleTeaDetailPage extends StatelessWidget {
  final ctr = Get.put(BubbleTeaDetailCtr());

  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        height: 1.sh,
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        child: Obx(() => Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 274.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF0A0A0A), Color(0xFF2B221C)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: ImageUtil.networkImage(
                          url: "${ctr.model.value.image}",
                          width: 165.w,
                          height: 165.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.back(),
                        child: Container(
                          width: 34.w,
                          height: 34.w,
                          margin: EdgeInsets.only(left: 16.w),
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 260.h,
                  bottom: 60.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 1.sw,
                    decoration: ShapeDecoration(
                      color: hexColor('0A0A0A'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ctr.model.value.name ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingOnly(left: 16.w, top: 20.h),
                          Visibility(
                            visible: ctr.model.value.brief != null,
                            child: Text(
                              ctr.model.value.brief ?? '',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: 'DIN',
                                fontWeight: FontWeight.w400,
                              ),
                            ).paddingOnly(left: 16.w, top: 16.h),
                          ),
                          20.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: FONT_MEDIUM,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ).paddingOnly(left: 16.w),
                              ),
                              InkWell(
                                onTap: () => ctr.minusMoney(),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: ctr.count.value == 1
                                      ? Colors.white.withOpacity(0.6)
                                      : Colors.white,
                                ),
                              ),
                              Obx(() => Text(
                                    '${ctr.count.value}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontFamily: FONT_LIGHT,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ).paddingSymmetric(horizontal: 15.w)),
                              InkWell(
                                onTap: () => ctr.addMoney(),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: hexColor('#FFB20E'),
                                ),
                              ),
                              16.horizontalSpace,
                            ],
                          ),
                          if (ctr.sizeTags.isNotEmpty)
                            commonWidget(
                              title: "Size",
                              selectSize: 1,
                              tagList: ctr.sizeTags,
                            ),
                          if (ctr.iceTags.isNotEmpty)
                            commonWidget(
                              title: "Ice Level",
                              selectSize: 1,
                              tagList: ctr.iceTags,
                            ),
                          if (ctr.sugarTags.isNotEmpty)
                            commonWidget(
                              title: "Sugar",
                              selectSize: 1,
                              tagList: ctr.sugarTags,
                            ),
                          if (ctr.toppingTags.isNotEmpty)
                            commonWidget(
                              title: "Toppings",
                              selectSize: 2,
                              tagList: ctr.toppingTags,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 1.sw,
                    height: 60.h,
                    decoration: ShapeDecoration(
                      color: hexColor('141517'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Obx(() => Expanded(
                              child: Text(
                                '£ ${ctr.totalMoney.value}',
                                style: TextStyle(
                                  color: const Color(0xFFFFB20E),
                                  fontSize: 24.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingOnly(left: 16.w),
                            )),
                        InkWell(
                          onTap: () => ctr.addTea(),
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            margin: EdgeInsets.only(right: 16.w),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFB20E),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImageUtils.add_to_cart_icon,
                                ),
                                6.horizontalSpace,
                                Text(
                                  'Add To Cart',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: FONT_MEDIUM,
                                    fontWeight: FontWeight.bold,
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
              ],
            )),
      );

  Widget commonWidget({
    required String title,
    required int selectSize,
    required List<TagBean> tagList,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(left: 16.w, top: 24.h),
          SimpleTags(
            content: tagList,
            selectSize: selectSize,
            wrapSpacing: 10.w,
            wrapRunSpacing: 10.h,
            onTagPress: (TagBean tagBean) {},
            tagContainerPadding: EdgeInsets.symmetric(
              vertical: 6.h,
              horizontal: 15.w,
            ),
            tagTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            tagSelectTextStyle: TextStyle(
              color: Color(0xffFFCB0E),
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            tagContainerDecoration: BoxDecoration(
              color: Color(0xFF141414),
              border: Border.all(
                color: Color(0xFF2F2F2F),
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            tagContainerSelectDecoration: BoxDecoration(
              color: Color(0xff3a3627),
              border: Border.all(
                color: Color(0xffFFCB0E),
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ).paddingOnly(left: 16.w, top: 10.h, right: 16.w),
        ],
      );
}
