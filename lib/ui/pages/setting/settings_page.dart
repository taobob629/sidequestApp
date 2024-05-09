import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/login/login_page.dart';

import '../../../api/auth_api.dart';
import '../../../api/user_api.dart';
import '../../../common/base_scaffold.dart';
import '../../../common/floating_button.dart';
import '../../../common/setting_item.dart';
import '../../../controller/user_controller.dart';
import '../../../utils/platform_utils.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/dialog_comment.dart';
import '../../dialog/dialog_confirm.dart';
import '../main_page.dart';
import 'about_page.dart';
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
            onTap: () {},
          ),
          SettingItem(
            title: "Language".tr,
            onTap: () => Get.to(() => LanguagePage()),
          ),
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
                onTap: () {},
              )),
        ],
      ),
      floatingActionButton: FloatingButton(
        label: "SIGN OUT".tr,
        onTap: () => controller.logout(),
      )
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
