import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/dialog_password.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../common/dialog_input.dart';

class DeveloperPage extends StatelessWidget {

  final controller = Get.put(DeveloperPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Developer",
      body: Obx(()=>Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text("Push Token",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Clipboard.setData(ClipboardData(text: controller.pushToken.value));
                EasyLoading.showToast("The push token has been copied to your clipboard");
              },
              child: Text(
                "${controller.pushToken.value}",
                style: TextStyle(fontSize: 14,color: Colors.white,)
              ),
            ),
            SizedBox(height: 20,),
            Text("Environment",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Row(
              children: [
                Radio<String>(
                  activeColor: AppColor.accent,
                  value: "dev220",
                  groupValue: controller.env.value,
                  onChanged: (value) {
                    controller.env.value = value!;
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("dev220", style: TextStyle(fontSize: 14, color: Colors.white),),
                )
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  activeColor: AppColor.accent,
                  value: "dev201",
                  groupValue: controller.env.value,
                  onChanged: (value) {
                    controller.env.value = value!;
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("dev201", style: TextStyle(fontSize: 14, color: Colors.white),),
                )
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  activeColor: AppColor.accent,
                  value: "test",
                  groupValue: controller.env.value,
                  onChanged: (value) {
                    controller.env.value = value!;
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("test121", style: TextStyle(fontSize: 14, color: Colors.white),),
                )
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
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("prod", style: TextStyle(fontSize: 14, color: Colors.white),),
                )
              ],
            )
          ],
        ),
      )),
      floatingActionButton: FloatingButton(label: "SAVE",onTap: () {
        controller.saveEnv();
        Get.dialog(
          ConfirmDialog(
            title: 'Restart required',
            info: 'Please restart the app to make the configuration take effect',
          ),barrierColor: Colors.black26
        ).whenComplete(() async {
          //await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          exit(0);
        });
      })
    );
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

  void saveEnv(){
    StorageManager.setEnv(env.value);
  }

}