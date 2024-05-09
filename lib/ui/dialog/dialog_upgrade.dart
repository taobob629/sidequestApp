import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../common/colorful_button.dart';
import '../../common/wy_dialog.dart';
import '../../model/version_model.dart';

class UpgradeDialog extends StatelessWidget {
  final VersionModel model;

  final controller = Get.put(UpgradeDialogController());

  UpgradeDialog({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Image.asset(
              ImageUtils.upgrade_top_bg,
              fit: BoxFit.cover,
              width: 1.sw,
            ),
            Text(
              'New Version Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF141414),
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.bold,
              ),
            ).marginOnly(left: 40.w, top: 70.h),
          ],
        ),
        Transform.translate(
          offset: Offset(0, -14.h),
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xFF23201C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
            ),
            child: Column(
              children: [
                24.verticalSpace,
                Center(
                  child: Text(
                    "New Version Available".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                13.verticalSpace,
                Center(
                  child: Text(
                    "${model.version}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                13.verticalSpace,
                Text(
                  "${model.intro}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h, bottom: 0),
                  child: Obx(() {
                    if (controller.showProgress.value == true) {
                      return Container(
                        height: 40,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white24,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.amber),
                              semanticsLabel:
                                  controller.progress.value.toString(),
                              value: controller.progress.value / 100,
                              semanticsValue:
                                  controller.progress.value.toString(),
                            ),
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        StoreRedirect.redirect(
                          androidAppId: "uk.co.sidequest.wy",
                          iOSAppId: "1614945163",
                        );
                      },
                      child: Container(
                        width: 250.w,
                        height: 40.h,
                        margin: EdgeInsets.only(bottom: 20.h),
                        decoration: ShapeDecoration(
                          color: Color(0xFFFFB20E),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "UPGRADE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        )
      ],
    ).marginSymmetric(horizontal: 20.w);
  }
}

class UpgradeDialogController extends GetxController {
  var showProgress = false.obs;
  var progress = 0.obs;

  @override
  void onReady() {
    super.onReady();
    showProgress.value = false;
    progress.value = 0;
  }
//
// void startDownload(String url){
//   showProgress.value = true;
//   try {
//     OtaUpdate()
//       .execute(
//       //'https://internal1.4q.sk/flutter_hello_world.apk',
//       url,
//       // OPTIONAL
//       destinationFilename: 'SideQuestGame.apk',
//     ).listen((OtaEvent event) {
//       if(event.status == OtaStatus.DOWNLOADING) {
//         progress.value = int.parse(event.value??"0");
//       }else if(event.status == OtaStatus.ALREADY_RUNNING_ERROR){
//         SmartDialog.showToast("Upgrade already started".tr);
//       }else if(event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR){
//         Get.dialog(
//           ConfirmDialog(title: "Permission required".tr, info: "File access denied, please click the button below to change current setting.".tr),barrierColor: Colors.black26
//         ).then((value) async{
//           if (value != null && value == true) {
//             await openAppSettings();
//           }
//         });
//       }else if(event.status == OtaStatus.INTERNAL_ERROR || event.status == OtaStatus.DOWNLOAD_ERROR){
//         SmartDialog.showError("${'Upgrade failed'.tr} :${event.value}");
//         showProgress.value = false;
//         progress.value = 0;
//       }else if(event.status == OtaStatus.INSTALLING){
//         showProgress.value = false;
//         progress.value = 0;
//       }
//     });
//   } catch (e) {
//     print('Failed to make OTA update. Details: $e');
//   }
// }
}
