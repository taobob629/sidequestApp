import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/login/login_page.dart';

import '../../../api/auth_api.dart';
import '../../../api/index_api.dart';
import '../../../api/user_api.dart';
import '../../../api/wy_http.dart';
import '../../../common/base_scaffold.dart';
import '../../../common/floating_button.dart';
import '../../../common/setting_item.dart';
import '../../../config/lang/translations.dart';
import '../../../controller/user_controller.dart';
import '../../../model/version_model.dart';
import '../../../utils/platform_utils.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/dialog_comment.dart';
import '../../dialog/dialog_confirm.dart';
import '../../dialog/dialog_upgrade.dart';
import '../main_page.dart';
import '../profile/my_profile/profile_edit_page.dart';
import '../profile/vip/vip_page.dart';
import 'about_page.dart';
import 'change_password_page.dart';
import 'language_page.dart';

class SettingsPage extends StatelessWidget {
  final controller = Get.put(SettingsPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Settings".tr,
        body: Column(
          children: [
            SettingItem(
              title: "ID".tr,
              info: "${UserController.find.userProfile.uk}",
              showRightIcon: false,
              onTap: () {},
            ),
            SettingItem(
              title: "Personal".tr,
              onTap: () => Get.to(() => ProfileEditPage()),
            ),
            SettingItem(
              title: "Account Password".tr,
              onTap: () => controller.checkHasPwd(1),
            ),
            SettingItem(
              title: "Payment Pin".tr,
              onTap: () => controller.checkHasPwd(2),
            ),
            Obx(() => SettingItem(
                  title: "Language".tr,
                  info:
                      controller.curLan.value.toLanguageTag().contains("en-US")
                          ? "English"
                          : "中文",
                  onTap: () => Get.to(() => LanguagePage())?.then((value) =>
                      controller.curLan.value = Get.locale ?? ENGLISH),
                )),
            SettingItem(
              title: "Delete Account".tr,
              info: UserController.find.user.value.email,
              onTap: () => controller.deleteAccount(),
            ),
            SettingItem(
              title: "About Us".tr,
              onTap: () => gotoAboutPage(context),
            ),
            Obx(() => SettingItem(
                  title: "Version".tr,
                  info: controller.version.value,
                  onTap: () => controller.checkVersion(),
                )),
            Visibility(
              visible: controller.getMembership()["index"] != -1,
              child: Obx(() => SettingItem(
                    title: controller.getMembership()["name"],
                    info: UserController.find.userProfile.nextRenew,
                    onTap: () => Get.to(() => VipPage(),
                        arguments: controller.getMembership()["index"]),
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingButton(
          label: "SIGN OUT".tr,
          onTap: () => controller.logout(),
        ));
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

  var curLan = Locale(ENGLISH.languageCode).obs;

  @override
  void onReady() async {
    super.onReady();
    version.value = await PlatformUtils.getAppVersion();
    online.value = StorageManager.getOnline();

    curLan.value = Get.locale ?? ENGLISH;
  }

  Map<String, dynamic> getMembership() {
    int vipLevel = UserController.find.userProfile.vipLevel;
    String membershipName = "Normal";
    int index = -1;
    switch (vipLevel) {
      case 5:
        membershipName = "Adventurer";
        index = 0;
        break;
      case 10:
        membershipName = "Hero";
        index = 1;
        break;
      case 15:
        membershipName = "Champion";
        index = 2;
        break;
      case 15:
        membershipName = "Legend";
        index = 3;
        break;
    }
    return {"name": membershipName, "index": index};
  }

  void checkHasPwd(int type) async {
    showLoading();
    var response = await http.get('/peiwan/app/user/hasPwd');
    dismissLoading();
    if (type == 1) {
      Get.to(() => ChangePasswordPage(
        type: 1,
        hasPwd: response.data['haspwd'],
      ));
    } else {
      Get.to(() => ChangePasswordPage(
        type: 2,
        hasPwd: response.data['haspin'],
      ));
    }
  }

  void updateLanguage(Locale local) {
    if (local.languageCode == Get.locale?.languageCode) {
      Get.back();
    }
    StorageManager.setLocal(local?.languageCode);
    Get.updateLocale(local);
    Get.back();
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
          confimPwd();
        },
      ),
      barrierColor: Colors.black26,
    );
  }

  void confimPwd() {
    Get.dialog(DialogComment(
      maxLines: 1,
      minLines: 1,
      autoClose: false,
      obscureText: true,
      title: "Delete Account".tr,
      hint: 'Please input your password'.tr,
      onConfirm: (text) async {
        showLoading();
        var res = await UserApi.confirmPwd(text);
        dismissLoading();
        if (res.data == null) {
          Get.back();
          showLoading();
          await UserApi.deleteAccount();
          await logout();
        }
      },
    ));
  }

  void checkVersion() async {
    showLoading();
    VersionModel model = await IndexApi.checkVersion();
    dismissLoading();
    if (!model.upgrade) {
      showError("You are using the latest version".tr);
    } else {
      showCustom(
        UpgradeDialog(model: model),
        clickMaskDismiss: !model.force,
        backDismiss: false,
      );
    }
  }

  Future<void> logout() async {
    showLoading();
    await AuthApi.signOut();
    dismissLoading();
    UserController userController = Get.find<UserController>();
    userController.logout(done: () {
      try {
        if (Get.isRegistered<UserController>()) {
          Get.delete<UserController>();
        }
        if (Get.isRegistered<MainPageController>()) {
          Get.delete<MainPageController>();
        }
        throw Exception();
      } finally {
        Get.offAll(() => LoginPage());
      }
    });
  }
}
