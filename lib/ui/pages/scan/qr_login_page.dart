import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/scan/widget/qr_login_form_view.dart';

import '../../../api/auth_api.dart';
import '../../../api/wy_http.dart';
import '../../../common/base_scaffold.dart';
import '../../../common/floating_button.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../../../model/qr_login.dart';
import '../../../model/qr_login_info.dart';
import '../../../utils/toast_utils.dart';

class QrLoginPage extends StatelessWidget {
  late final QrLoginPageController controller;

  final userController = Get.find<UserController>();

  QrLoginPage({required String code}) {
    controller = Get.put(QrLoginPageController(code: code));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Authorization".tr,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, bottom: 8.h),
            child: SizedBox(
              width: 92.w,
              height: 92.w,
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      child: Icon(
                        IconFonts.pc,
                        size: 92.w,
                        color: Colors.white38,
                      )),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 23.w,
                      bottom: 46.w,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.asset(
                            ImageUtils.default_logo,
                            fit: BoxFit.cover,
                            width: 24.w,
                            height: 24.w,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 4.h),
            child: Text(
              "You are signing in to a PC client with account below, do you want to continue?"
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15.sp, height: 1.35),
            ),
          ),
          QrLoginFromWidget()
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h),
          child: FloatingButton(
            label: "Login".tr,
            onTap: () => controller.login(),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelIcon() {
    if (userController.userProfile.vipLevel == 0) {
      return Container();
    } else {
      return Image.asset(
        "assets/images/ic_level${userController.userProfile.vipLevel}.webp",
        width: 30,
        height: 30,
      );
    }
  }
}

class QrLoginPageController extends GetxController {
  String code;
  Rxn<QrLoginInfoModel> _qrLoginInfoModel = Rxn();

  QrLoginInfoModel? get qrLoginInfoModel => _qrLoginInfoModel.value;

  set qrLoginInfoModel(QrLoginInfoModel? value) {
    _qrLoginInfoModel.value = value;
  }

  QrLoginPageController({required this.code});

  @override
  void onInit() {
    super.onInit();

    scanInfo();
  }

  void scanInfo() async {
    qrLoginInfoModel = await AuthApi.scanInfo(code);
  }

  void login() async {
    showLoading();
    var res = await AuthApi.qrCodeLogin(code);
    dismissLoading();
    if (res.code == 0 || res.code == 200) {
      showSuccess("Success".tr, duration: const Duration(seconds: 3))
          .then((value) => Get.back());
    } else {
      showError("Server Failure".tr);
    }
  }

  static Future<QrLoginModel> qrCodeLogin(String code) async {
    var formData = {
      "secret": code,
    };
    var res = await http.post('/app/index/qrcode/login', data: formData);
    return QrLoginModel.fromJson(res.data);
  }
}
