import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
                    "Push Token".tr,
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
                          ClipboardData(text: controller.pushToken.value));
                      showToast(
                          "The push token has been copied to your clipboard"
                              .tr);
                    },
                    child: Text("${controller.pushToken.value}",
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
                              text: "http://114.117.203.137:8081",
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
                              text: "http://139.186.149.117:8081",
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
                              text: "http://43.136.135.198:8081",
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
                              text: "https://sidequesthub.com",
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

  var env = "prod".obs;

  @override
  void onReady() {
    super.onReady();
    pushToken.value = StorageManager.getPushToken();
    env.value = StorageManager.getEnv();
  }

  void saveEnv() {
    StorageManager.setEnv(env.value);
  }
}
