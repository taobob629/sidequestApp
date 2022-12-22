import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
// import 'package:ota_update/ota_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/model/version_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/wy_dialog.dart';
import 'package:wy/utils/utils.dart';

import 'dialog_confirm.dart';

class UpgradeDialog extends StatelessWidget {

  final VersionModel model;

  final controller = Get.put(UpgradeDialogController());

  UpgradeDialog({required this.model});

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      forceShow: model.force,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Center(
            child: Text(
              "New Version Available".tr,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              "${model.version}",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white,fontSize: 14),
            ),
          ),
          SizedBox(height: 10,),
          Text(
            "${model.intro}",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white,fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50,bottom: 0),
            child: Obx((){
              if(controller.showProgress.value == true){
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                        semanticsLabel: controller.progress.value.toString(),
                        value: controller.progress.value / 100,
                        semanticsValue: controller.progress.value.toString(),
                      ),
                    ),
                  ),
                );
              }
              return ColorfulButton(
                child: Text("UPGRADE",style: TextStyle(color: Colors.white,fontSize: 16)),
                height: 40,
                onTap: () async {
                      // if(Platform.isAndroid) {
                      //   controller.startDownload(model.store);
                      //   return;
                      // }
                      // await launch("https://play.google.com/store/apps/details?id=uk.co.sidequest.wy");
                      StoreRedirect.redirect(
                          androidAppId: "uk.co.sidequest.wy", iOSAppId: "1614945163");
                    });
            }),
          )
        ],
      )
    );
  }

  static Future<bool?> show(BuildContext context, VersionModel model, {bool cancelable = true}) async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black26,
      barrierDismissible: cancelable,
      builder: (BuildContext context) {
        return UpgradeDialog(model: model);
      }
    );
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
//         EasyLoading.showToast("Upgrade already started".tr);
//       }else if(event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR){
//         Get.dialog(
//           ConfirmDialog(title: "Permission required".tr, info: "File access denied, please click the button below to change current setting.".tr),barrierColor: Colors.black26
//         ).then((value) async{
//           if (value != null && value == true) {
//             await openAppSettings();
//           }
//         });
//       }else if(event.status == OtaStatus.INTERNAL_ERROR || event.status == OtaStatus.DOWNLOAD_ERROR){
//         EasyLoading.showError("${'Upgrade failed'.tr} :${event.value}");
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