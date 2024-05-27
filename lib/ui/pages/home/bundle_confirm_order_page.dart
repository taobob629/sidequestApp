import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/base_scaffold.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/ui/pages/home/tab_bundles_page.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../config/app_color.dart';
import '../../../controller/user_controller.dart';
import '../../../getx_ctr/bundle_confirm_order_ctr.dart';
import '../../../model/bundles_model.dart';
import '../../../model/pay_order_model.dart';
import '../../../utils/navigator_helper.dart';

class BundleConfirmOrderPage extends StatelessWidget {
  final controller = Get.put(BundleConfirmOrderCtr());

  @override
  Widget build(BuildContext context) => BaseScaffold(
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
        body: Container(
          width: 1.sw,
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 18.h,
          ),
          padding: EdgeInsets.only(bottom: 80.h),
          decoration: ShapeDecoration(
            color: Color(0xFF141517),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.verticalSpace,
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (c, i) =>
                    teaItemWidget(TabBundlesPageController.find.selectList[i]),
                separatorBuilder: (c, i) => 10.verticalSpace,
                itemCount: TabBundlesPageController.find.selectList.length,
              ),
              Container(
                height: 1.h,
                margin: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 25.h,
                ),
                decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    "${TabBundlesPageController.find.selectList.length}",
                    style: TextStyle(
                      color: AppColor.yellow,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    'item in total',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    "£${TabBundlesPageController.find.totalPrice.value}",
                    style: TextStyle(
                      color: AppColor.yellow,
                      fontSize: 20.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  16.horizontalSpace,
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 44.w,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: ShapeDecoration(
            color: hexColor('4C3608'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
          child: Row(
            children: [
              14.horizontalSpace,
              Text(
                '£${TabBundlesPageController.find.totalPrice.value}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: InkWell(
                  onTap: () => NavigatorHelper.gotoCouponPage(
                    couponType: 3,
                    showTabbar: false,
                    // 只是为了能有返回值创建的一个空的payOrderModel
                    payOrderModel: PayOrderModel(),
                    whenComplete: () => UserController.instance().updateInfo(),
                    onSelect: (model) => controller.selectCoupon(model),
                    storeId: TabBundlesPageController.find.currentSelectStore.value.id,
                    goodsList: TabBundlesPageController.find.getGoodsListMap(),
                  ),
                  child: Obx(() => RichText(
                    text: TextSpan(
                      text: 'Discount：-${controller.discount.value} ',
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
                onTap: () => controller.payment(),
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

  Widget teaItemWidget(BundlesModel model) => Row(
        children: [
          16.horizontalSpace,
          ImageUtil.networkImage(
            url: '${model.image}',
            border: 10.r,
            width: 66.w,
            height: 66.w,
            fit: BoxFit.cover,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${model.name}',
                        style: TextStyle(
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '£${model.price}',
                      style: TextStyle(
                        color: const Color(0xFFFFB20E),
                        fontSize: 16.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w600,
                      ),
                    ).paddingOnly(right: 16.w),
                  ],
                ),
                4.verticalSpace,
                Text(
                  model.brief ?? '',
                  style: TextStyle(
                    fontFamily: FONT_LIGHT,
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );

  Widget itemWidget(int i) => Row(
        children: [
          ImageUtil.networkImage(
            url: "${TabBundlesPageController.find.selectList[i].image}",
            width: 65.w,
            height: 65.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${TabBundlesPageController.find.selectList[i].name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                6.verticalSpace,
                Visibility(
                  visible: TabBundlesPageController.find.selectList[i].brief != null,
                  child: Text(
                    '${TabBundlesPageController.find.selectList[i].brief}',
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
                '£${TabBundlesPageController.find.selectList[i].price}',
                style: TextStyle(
                  color: Color(0xFFFFB20E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              6.verticalSpace,
              Text(
                'X${TabBundlesPageController.find.selectList[i].count}',
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

  Widget footerWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
            margin: EdgeInsets.symmetric(vertical: 16.h),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Coupon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: "Currently unavailable".tr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 14.sp,
                        ).paddingOnly(left: 14.w),
                      ),
                    ]),
              ),
            ],
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
            margin: EdgeInsets.symmetric(vertical: 16.h),
          ),
          Row(
            children: [
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "${TabBundlesPageController.find.selectList.length}".tr,
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    WidgetSpan(child: 6.horizontalSpace),
                    TextSpan(
                      text: "item in total".tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    WidgetSpan(child: 6.horizontalSpace),
                    TextSpan(
                      text: "£${TabBundlesPageController.find.totalPrice.value}".tr,
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 20.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}
