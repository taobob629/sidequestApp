import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../common/colorful_button.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../event/event_page.dart';

class CheckFeeWidget extends GetView<EventPageController> {
  Function checkDone;

  CheckFeeWidget(this.checkDone);

  var balance = '0'.obs;
  var subTotal = '0'.obs;
  var total = '0'.obs;
  var discount = '0'.obs;

  @override
  Widget build(BuildContext context) {
    balance.value = UserController.find.userProfile.balance;
    subTotal.value = '${controller.eventDetailModel.value.fee}';
    total.value = '${controller.eventDetailModel.value.fee}';
    String tips =
        "${'We will charge a entry fee of £'.tr}${controller.eventDetailModel.value.fee} ${'from your \nbalance for this sign up, Please make sure that \nyou have enough balance.'.tr}";
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
                  'Entry Fee'.tr,
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
              Image.asset(ImageUtils.coin_2, width: 40.w),
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
                  trailing: Obx(() => Text('£ $subTotal')),
                  leading: Text(
                    'Subtotal',
                    style: TextStyle(fontFamily: FONT_MEDIUM),
                  ),
                ),
                Divider(
                  color: Colors.white.withAlpha(100),
                  height: 1,
                ),
                ListTile(
                  trailing: Obx(() => discount.value == '0'
                      ? Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        )
                      : Text('£ $discount')),
                  leading: Text(
                    'Vouchers',
                    style: TextStyle(fontFamily: FONT_MEDIUM),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            trailing: Obx(() => Text('£ $total')),
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
                child: Text('Confirm'.tr),
                width: 222.w,
                height: 42.h,
                borderRadius: 21.h,
                onTap: () => pay(),
              )
            ],
          ),
          20.verticalSpace
        ],
      ),
    );
  }

  void pay() {
    UserController userController = Get.find<UserController>();
    double userBalance = double.parse(userController.userProfile.balance);

    if (userBalance >= double.parse(total.value)) {
      checkDone.call();
      Get.back();
    } else {
      // Get.to(() => BalancePage(
      //       amount: controller.eventDetailModel.value.fee.toDouble(),
      //     ));
    }
  }
}
