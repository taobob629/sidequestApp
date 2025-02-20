import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sq_hub_app/config/app_config.dart';

import '../../../../common/base_scaffold.dart';
import '../../../../common/floating_button.dart';
import '../../../../config/app_color.dart';
import '../../../../utils/storage_manager.dart';
import '../../../../utils/toast_utils.dart';
import '../../../dialog/dialog_confirm.dart';

class DeveloperPage extends StatelessWidget {
  final controller = Get.put(DeveloperPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Developer".tr,
        body: Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Subscription ID".tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  10.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: controller.pushToken.value));
                      showError(
                          "The Subscription ID has been copied to your clipboard"
                              .tr);
                    },
                    child: Text("${controller.pushToken.value}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ),
                  10.verticalSpace,
                  Text(
                    "Onesignal ID".tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: controller.onesignalId.value));
                      showError(
                          "The Onesignal ID has been copied to your clipboard"
                              .tr);
                    },
                    child: Text("${controller.onesignalId.value}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Environment".tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Radio<String>(
                          activeColor: AppColor.accent,
                          value: "dev137",
                          groupValue: controller.env.value,
                          onChanged: (value) {
                            controller.env.value = value!;
                          }),
                      10.horizontalSpace,
                      RichText(
                        text: TextSpan(
                          text: "dev137:\n",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: AppConfig.devServer,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                          activeColor: AppColor.accent,
                          value: "dev127",
                          groupValue: controller.env.value,
                          onChanged: (value) {
                            controller.env.value = value!;
                          }),
                      10.horizontalSpace,
                      RichText(
                        text: TextSpan(
                          text: "dev117:\n",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: AppConfig.devServer2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                          activeColor: AppColor.accent,
                          value: "dev198",
                          groupValue: controller.env.value,
                          onChanged: (value) {
                            controller.env.value = value!;
                          }),
                      10.horizontalSpace,
                      RichText(
                        text: TextSpan(
                          text: "dev198:\n",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: AppConfig.testServer,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                          activeColor: AppColor.accent,
                          value: "prod",
                          groupValue: controller.env.value,
                          onChanged: (value) {
                            controller.env.value = value!;
                          }),
                      10.horizontalSpace,
                      RichText(
                        text: TextSpan(
                          text: "prod:\n",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: AppConfig.prodServer,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
        floatingActionButton: FloatingButton(
            label: "SAVE",
            onTap: () {
              controller.saveEnv();
              Get.dialog(
                      ConfirmDialog(
                        title: 'Restart required',
                        info:
                            'Please restart the app to make the configuration take effect',
                      ),
                      barrierColor: Colors.black26)
                  .whenComplete(() async {
                //await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                exit(0);
              });
            }));
  }
}

class DeveloperPageController extends GetxController {
  var pushToken = "".obs;
  var onesignalId = "".obs;
  var one = "".obs;

  var env = "prod".obs;

  @override
  void onReady() {
    super.onReady();
    pushToken.value = StorageManager.getPushToken();
    env.value = StorageManager.getEnv();

    getOnesignalId();
  }

  void getOnesignalId() async {
    String? result = await OneSignal.User.getOnesignalId();
    if (result != null) {
      onesignalId.value = result;
    }
  }

  void saveEnv() {
    StorageManager.setEnv(env.value);
  }
}
