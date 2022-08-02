
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/api/vip_api.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/model/version_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_upgrade.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/profile_page.dart';
import 'package:wy/ui/profile/settings/about_page.dart';
import 'package:wy/ui/profile/settings/change_password_page.dart';
import 'package:wy/utils/platform_utils.dart';

import '../../common/dialog_confirm.dart';
import 'setting_item.dart';

class SettingsPage extends StatelessWidget {

  final controller = Get.put(SettingsPageController());

  final userController = Get.find<UserController>();



  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Settings",
      body: Column(
        children: [
          SettingItem(
            title: "Account Password",
            onTap: ()=>Get.to(()=>ChangePasswordPage(type: 1, have: true,)),
          ),
          SettingItem(
            title: "Payment Pin",
            onTap: ()=>Get.to(()=>ChangePasswordPage(type: 2, check: true,)),
          ),
          SettingItem(
            title: "About Us",
            onTap: ()=> gotoAboutPage(context),
          ),
          Obx(()=>userController.userInfoModel.value.vipLevel > 0?SettingItem(
            title: "Cancel Subscription",
            info: "${controller.getVipName(userController.userInfoModel.value.vipLevel)}",
            onTap: ()=>controller.cancelVip(userController.userInfoModel.value.vipLevel),
          ):Container()),
          Obx(()=>SettingItem(
            title: "Version",
            info: "${controller.version.value}",
            onTap: ()=> controller.checkVersion(),
          ))
        ],
      ),
      floatingActionButton: FloatingButton(
        label: "SIGN OUT",
        onTap: () => controller.logout(),
      )
    );
  }

  void gotoAboutPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return AboutPage();
      }
    ));
  }
}

class SettingsPageController extends GetxController {

  var version = "".obs;

  @override
  void onReady() async {
    super.onReady();
    version.value = await PlatformUtils.getAppVersion();
  }

  void logout() async {
    EasyLoading.show();
    await AuthApi.signOut();
    await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
    EasyLoading.dismiss();
    UserController userController = Get.find<UserController>();
    userController.logout(done: ()=>Get.back());
  }

  void checkVersion() async{
    EasyLoading.show();
    VersionModel model = await IndexApi.checkVersion();
    if(!model.upgrade){
      EasyLoading.showInfo("You are using the latest version");
    }else{
      EasyLoading.dismiss();
      Get.dialog(UpgradeDialog(model:model),barrierColor: Colors.black26);
    }
  }

  String getVipName(int level){
    String name = "";
    final profilePageController = Get.find<ProfilePageController>();
    profilePageController.vipInfoList.forEach((element) {
      if(element.level == level){
        name = element.name;
      }
    });
    return name;
  }

  void cancelVip(int level) async{
    EasyLoading.show();
    String info = await VipApi.cancelInfo();
    EasyLoading.dismiss();
    Get.dialog(ConfirmDialog(
      title: "Cancel Subscription",
      info: info,
      confirmBtn: "CONFIRM",
      onConfirm: () async {
        Get.back();
        EasyLoading.show();
        String info = await VipApi.cancel();
        EasyLoading.dismiss();
        Get.dialog(ConfirmDialog(
          title: "Subscription Canceled",
          info: info,
          confirmBtn: "CONFIRM",
          onConfirm: (){
            Get.back();
          }
        ),barrierColor: Colors.black26);
        },
    ),barrierColor: Colors.black26);
  }
}