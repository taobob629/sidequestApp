import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/base_scaffold.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../config/app_color.dart';
import '../../../controller/user_controller.dart';
import '../../../getx_ctr/bubble_confirm_order_ctr.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../model/pay_order_model.dart';
import '../../../utils/navigator_helper.dart';
import '../../../widget/container_tab_indicator.dart';

class BubbleConfirmOrderPage extends StatelessWidget {
  final ctr = Get.put(BubbleConfirmOrderCtr());

  @override
  Widget build(BuildContext context) {
    ctr.calStoreOpenTime();
    return BaseScaffold(
      title: 'Confirmation'.tr,
      leading: InkWell(
        onTap: () => Get.back(),
        child: Center(
          child: Container(
            width: 34.w,
            height: 34.w,
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            margin: EdgeInsets.only(left: 16.w),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 1.sw,
            height: 200.h,
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            decoration: ShapeDecoration(
              color: Color(0xFF141517),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 230.w,
                    height: 148.h,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFF231E13), Color(0x00141517)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 36.w,
                  top: 7.h,
                  width: 38.w,
                  height: 38.h,
                  child: Image.asset(ImageUtils.tea_icon),
                ),
                Positioned(
                  right: 8.w,
                  top: 32.h,
                  width: 25.w,
                  height: 25.h,
                  child: Image.asset(ImageUtils.tea_app_logo_icon),
                ),
                Positioned(
                  right: 14.w,
                  top: 18.h,
                  left: 14.w,
                  bottom: 22.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${TabBubbleTeaCtr.find.currentSelectStore.value.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        '${TabBubbleTeaCtr.find.currentSelectStore.value.address}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                        ),
                      ).paddingOnly(right: 45.w),
                      15.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'TAKE AWAY'.tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: 160.w,
                            height: 34.h,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.w,
                                  color: Color(0xFFFFB20E),
                                ),
                                borderRadius: BorderRadius.circular(60.r),
                              ),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                tabBarTheme:
                                    Theme.of(context).tabBarTheme.copyWith(
                                          labelColor: Colors.white,
                                          // 设置想要的选中标签文本颜色
                                          unselectedLabelColor: AppColor.yellow,
                                        ),
                              ),
                              child: TabBar(
                                controller: ctr.tabController,
                                tabs: ctr.tabs,
                                labelPadding: EdgeInsets.zero,
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                indicator: ContainerTabIndicator(
                                  height: 34.h,
                                  width: 80.w,
                                  radius: BorderRadius.circular(64.r),
                                  colors: [AppColor.yellow, AppColor.yellow],
                                ),
                                onTap: (index) => ctr.eatin.value = index,
                              ),
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'PICKUP AT'.tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                ctr.eatin.value == 0 ? null : ctr.selectTime(),
                            child: Obx(() => Row(
                                  children: [
                                    Text(
                                      ctr.eatin.value == 0
                                          ? 'Now'
                                          : '${ctr.selectHour.value} : ${ctr.selectMin.value}'
                                              .tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Visibility(
                                      visible: ctr.eatin.value != 0,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            decoration: ShapeDecoration(
              color: Color(0xFF141517),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            padding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
              top: 18.h,
              bottom: 22.h,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (c, i) => itemWidget(i),
              separatorBuilder: (c, i) => 10.verticalSpace,
              itemCount: TabBubbleTeaCtr.find.selectTeaList.length,
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 44.w,
        margin: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 34.h,
        ),
        decoration: ShapeDecoration(
          color: hexColor('4C3608'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.r),
          ),
        ),
        child: Row(
          children: [
            14.horizontalSpace,
            Obx(() => Text(
              '£${ctr.totalPrice.value}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.w600,
              ),
            )),
            10.horizontalSpace,
            Expanded(
              child: InkWell(
                onTap: () => NavigatorHelper.gotoCouponPage(
                  couponType: 3,
                  showTabbar: false,
                  // 只是为了能有返回值创建的一个空的payOrderModel
                  payOrderModel: PayOrderModel(),
                  storeId: TabBubbleTeaCtr.find.currentSelectStore.value.id,
                  goodsList: TabBubbleTeaCtr.find.getGoodsListMap(),
                  whenComplete: () => UserController.instance().updateInfo(),
                  onSelect: (model) => ctr.selectCoupon(model),
                ),
                child: Obx(() => RichText(
                  text: TextSpan(
                    text: 'Discount：-${ctr.discount.value} ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.6),
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            InkWell(
              onTap: () => ctr.payment(),
              child: Container(
                width: 100.w,
                height: 44.w,
                decoration: ShapeDecoration(
                  color: hexColor('FFB20E'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Payment'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemWidget(int i) => Row(
        children: [
          ImageUtil.networkImage(
            url: "${TabBubbleTeaCtr.find.selectTeaList[i].image}",
            width: 65.w,
            height: 65.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${TabBubbleTeaCtr.find.selectTeaList[i].name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                6.verticalSpace,
                Visibility(
                  visible: TabBubbleTeaCtr.find.selectTeaList[i].brief != null,
                  child: Text(
                    '${TabBubbleTeaCtr.find.selectTeaList[i].brief}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '£${TabBubbleTeaCtr.find.getPrice(TabBubbleTeaCtr.find.selectTeaList[i])}',
                style: TextStyle(
                  color: Color(0xFFFFB20E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              6.verticalSpace,
              Text(
                'X${TabBubbleTeaCtr.find.selectTeaList[i].count}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      );
}
