import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api/vip_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/lang/translations.dart';
import 'package:wy/model/version_model.dart';
import 'package:wy/ui/common/action_button.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_upgrade.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/profile_page.dart';
import 'package:wy/ui/profile/settings/about_page.dart';
import 'package:wy/ui/profile/settings/change_password_page.dart';
import 'package:wy/utils/platform_utils.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

import '../../common/dialog_confirm.dart';
import 'setting_item.dart';

class SettingsPage extends StatelessWidget {
  final controller = Get.put(SettingsPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Settings".tr,
      body: Column(
        children: [
          SettingItem(
            title: "Account Password".tr,
            onTap: () => Get.to(() => ChangePasswordPage(
                  type: 1,
                  have: true,
                )),
          ),
          SettingItem(
            title: "Payment Pin".tr,
            onTap: () => Get.to(() => ChangePasswordPage(
                  type: 2,
                  check: true,
                )),
          ),
          SettingItem(
            title: "Language".tr,
            onTap: () => controller.choseLanguage(),
          ),
          SettingItem(
            title: "About Us".tr,
            onTap: () => gotoAboutPage(context),
          ),
          Obx(() => controller.online.value && userController.userInfoModel.value.vipLevel > 0
              ? SettingItem(
                  title: "Cancel Subscription".tr,
                  info: "${controller.getVipName(userController.userInfoModel.value.vipLevel)}",
                  onTap: () => controller.cancelVip(userController.userInfoModel.value.vipLevel),
                )
              : Container()),
          Obx(() => SettingItem(
                title: "Version".tr,
                info: "${controller.version.value}",
                onTap: () => controller.checkVersion(),
              )),
          SettingItem(
            title: "Delete Account".tr,
            info: "${userController.user.value.email}",
            onTap: () => controller.deleteAccount(),
          ),
          Spacer(),
          SafeArea(
            child: FloatingButton(
              label: "SIGN OUT".tr,
              onTap: () => controller.logout(),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingButton(
      //   label: "SIGN OUT".tr,
      //   onTap: () => controller.logout(),
      // )
    );
  }

  void gotoAboutPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AboutPage();
    }));
  }
}

class SettingsPageController extends GetxController {
  var version = "".obs;

  var online = false.obs;

  @override
  void onReady() async {
    super.onReady();
    version.value = await PlatformUtils.getAppVersion();
    online.value = StorageManager.getOnline();
  }

  Future<void> logout() async {
    EasyLoading.show();
    await AuthApi.signOut();
    await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
    EasyLoading.dismiss();
    UserController userController = Get.find<UserController>();
    userController.logout(done: () => Get.offAllNamed(AppPages.Login));
  }

  void checkVersion() async {
    EasyLoading.show();
    VersionModel model = await IndexApi.checkVersion();
    if (!model.upgrade) {
      EasyLoading.showInfo("You are using the latest version".tr);
    } else {
      EasyLoading.dismiss();
      Get.dialog(UpgradeDialog(model: model), barrierColor: Colors.black26);
    }
  }

  void deleteAccount() async {
    var info = '''
Deleting your account will remove your profile and all of your content from SideQuest. Delete account means you won't be able to get any of your data back. All your SideQuest account data will be deleted. If you experienced an issue with your account and need help, please contact us so we can assist you. This action cannot be UNDONE. Are you sure you need to DELETE ACCOUNT?'''
        .tr;
    Get.dialog(
        ConfirmDialog(
          title: "Delete Account".tr,
          info: info,
          confirmBtn: "CONFIRM".tr,
          onConfirm: () async {
            Get.back();
            EasyLoading.show();
            await UserApi.deleteAccount();
            await logout();
          },
        ),
        barrierColor: Colors.black26);
  }

  String getVipName(int level) {
    String name = "";
    final profilePageController = Get.find<ProfilePageController>();
    profilePageController.vipInfoList.forEach((element) {
      if (element.level == level) {
        name = element.name;
      }
    });
    return name;
  }

  void cancelVip(int level) async {
    EasyLoading.show();
    String info = await VipApi.cancelInfo();
    EasyLoading.dismiss();
    Get.dialog(
        ConfirmDialog(
          title: "Cancel Subscription".tr,
          info: info,
          confirmBtn: "CONFIRM".tr,
          onConfirm: () async {
            Get.back();
            EasyLoading.show();
            String info = await VipApi.cancel();
            EasyLoading.dismiss();
            Get.dialog(
                ConfirmDialog(
                    title: "Subscription Canceled".tr,
                    info: info,
                    confirmBtn: "CONFIRM".tr,
                    onConfirm: () {
                      Get.back();
                    }),
                barrierColor: Colors.black26);
          },
        ),
        barrierColor: Colors.black26);
  }

  void choseLanguage() {
    Get.toNamed(AppPages.LANGUAGE_PAGE);
    // Get.bottomSheet(
    //     Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: languages
    //           .map(
    //             (local) => ListTile(
    //                 title: RawMaterialButton(
    //                     onPressed: () {
    //                       updateLanguage(local);
    //                     },
    //                     child: Text(
    //                       local.languageCode.tr,
    //                       style: TextStyle(
    //                           color: local.languageCode == Get.locale?.languageCode
    //                               ? Colors.white
    //                               : Colors.white54),
    //                     ))),
    //           )
    //           .toList(),
    //     ),
    //     backgroundColor: AppColor.primary,
    //     enableDrag: false);
  }

  void updateLanguage(Locale local) {
    if (local.languageCode == Get.locale?.languageCode) {
      Get.back();
    }
    StorageManager.setLocal(local?.languageCode);
    Get.updateLocale(local);
    Get.back();
  }
}
