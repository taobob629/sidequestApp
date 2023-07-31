import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/coupon_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/coupon/coupon_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/toast_utils.dart';

import '../event/event_page.dart';

class CheckFeeWidget extends GetView<EventPageController> {
  Function checkDone;

  CheckFeeWidget(this.checkDone);

  @override
  Widget build(BuildContext context) {
    String tips =
        "${'We will charge a deposit of £'.tr}${controller.eventDetailModel.value.fee} ${'from your \nbalance for this sign up, Please make sure that \nyou have enough balance.'.tr}";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
          color: Color(0xFF262731)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deposit required'.tr,
                  style: TextStyle(fontSize: 18.sp, fontFamily: FONT_BLACK),
                ),
                TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel'.tr,
                      style: TextStyle(fontSize: 15.sp, fontFamily: FONT_LIGHT),
                    )),
              ],
            ),
          ),
          Row(
            children: [
              ImageUtil.assetImage('coin_2', width: 40.w),
              10.horizontalSpace,
              Text(
                tips,
                style: TextStyle(
                    color: Color(0xffF9DAA8),
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT),
              )
            ],
          ),
          20.verticalSpace,
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.r),
                ),
                color: Color(0xFF2D2E3C)),
            child: Column(
              children: [
                ListTile(
                  trailing: Text('£ ${controller.eventDetailModel.value.fee}'),
                  leading: Text(
                    'Subtotal',
                    style: TextStyle(fontFamily: FONT_MEDIUM),
                  ),
                ),
                ListTile(
                  onTap: ()=>NavigatorHelper.gotoCouponPage(couponType: 4,tab: CouponPage.TYPE_ACTIVITY,onSelect: (model) async {
                    flog('$model');
                    showLoading();
                    //计算优惠金额
                    var result=await  CouponApi.caculateFee(model.id, controller.eventDetailModel.value.id);
                    dismissLoading();
                  }),
                  trailing: Obx(()=>controller.eventDetailModel.value.discount.isEmpty?arrowMore(): Text('£ ${controller.eventDetailModel.value.fee}')),
                  leading: Text(
                    'Vouchers',
                    style: TextStyle(fontFamily: FONT_MEDIUM),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            trailing: Text('£ ${controller.eventDetailModel.value.fee}'),
            leading: Text(
              'Total',
              style:
                  TextStyle(fontFamily: FONT_MEDIUM, color: Color(0xffFFD20E)),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('Balance'.tr),
                  10.verticalSpace,
                  Text('£ ${UserController.find.userProfile.balance}'.tr),
                ],
              ),
              ColorfulButton(
                child: Text('Pay'.tr),
                width: 222.w,
                height: 42.h,
                borderRadius: 21.h,
              )
            ],
          ),
          20.verticalSpace
        ],
      ),
    );
  }
}
