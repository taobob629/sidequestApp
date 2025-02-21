import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/colorful_button.dart';
import 'package:sq_hub_app/controller/user_controller.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../api/notification_api.dart';
import '../../../config/icon_font.dart';
import '../../../widget/switch/custom_switch.dart';

class ReceiveNotifyPage extends StatelessWidget {
  final controller = Get.put(ReceiveNotifyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''.tr),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Receive All Notification",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              Obx(() => CustomSwitch(
                    value: controller.allSwitch.value,
                    onChanged: (value) => controller.allSwitch.value =
                        !controller.allSwitch.value,
                    width: 50.w,
                    height: 26.h,
                  )),
            ],
          ),
          Row(
            children: [
              Obx(() => Checkbox(
                    value: controller.systemSwitch.value,
                    activeColor:
                        controller.allSwitch.value ? Colors.green : Colors.grey,
                    onChanged: (bool? value) {
                      if (controller.allSwitch.value) {
                        controller.systemSwitch.value =
                            !controller.systemSwitch.value;
                        if (!controller.systemSwitch.value &&
                            !controller.marketSwitch.value) {
                          controller.allSwitch.value = false;
                        }
                      } else {
                        showError("Please turn on the Receive All Notification switch".tr);
                      }
                    },
                  )),
              Text(
                "Receive System Notification".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontFamily: FONT_LIGHT,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(() => Checkbox(
                    value: controller.marketSwitch.value,
                    activeColor:
                        controller.allSwitch.value ? Colors.green : Colors.grey,
                    onChanged: (bool? value) {
                      if (controller.allSwitch.value) {
                        controller.marketSwitch.value =
                            !controller.marketSwitch.value;
                        if (!controller.systemSwitch.value &&
                            !controller.marketSwitch.value) {
                          controller.allSwitch.value = false;
                        }
                      } else {
                        showError("Please turn on the Receive All Notification switch".tr);
                      }
                    },
                  )),
              Text(
                "Receive Marketing Notification".tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontFamily: FONT_LIGHT,
                ),
              ),
            ],
          ),
          ColorfulButton(
            margin: EdgeInsets.only(top: 20.h),
            child: Text(
              "CONFIRM".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "DIN",
              ),
            ),
            height: 40,
            onTap: () => controller.confirm(),
          ),
        ],
      ).marginAll(15.r),
    );
  }
}

class ReceiveNotifyController extends GetxController {
  var allSwitch = true.obs;

  var systemSwitch = true.obs;

  var marketSwitch = true.obs;

  @override
  void onInit() {
    super.onInit();

    if (UserController.find.userProfile.notification == 0) {
      allSwitch.value = true;
    } else if (UserController.find.userProfile.notification == 1) {
      allSwitch.value = true;
      systemSwitch.value = true;
      marketSwitch.value = false;
    } else if (UserController.find.userProfile.notification == 2) {
      allSwitch.value = true;
      systemSwitch.value = false;
      marketSwitch.value = true;
    } else {
      allSwitch.value = false;
    }
  }

  void confirm() async {
    showLoading();
    int setting = 0;
    if (allSwitch.value) {
      if (systemSwitch.value && !marketSwitch.value) {
        // 如果system选中、market未选中
        setting = 1;
      }
      if (!systemSwitch.value && marketSwitch.value) {
        // 如果system未选中、market选中
        setting = 2;
      }
    } else {
      setting = 3;
    }

    await NotificationApi.notifySetting(setting);
    dismissLoading();
    Get.back(result: true);
  }
}
