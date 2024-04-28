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
      body: ListView(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: SizedBox(
              width: 120.w,
              height: 120.w,
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      child: Icon(
                        IconFonts.pc,
                        size: 120.w,
                        color: Colors.white38,
                      )),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 30.w,
                      bottom: 60.w,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.asset(
                            ImageUtils.default_logo,
                            fit: BoxFit.cover,
                            width: 30.w,
                            height: 30.w,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Text(
              "You are signing in to a PC client with account below, do you want to continue?"
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          QrLoginFromWidget()
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 60),
          //   padding: const EdgeInsets.only(top: 30,bottom: 50),
          //   decoration: BoxDecoration(
          //     color: Colors.white12,
          //     borderRadius: BorderRadius.circular(12)
          //   ),
          //   child: Column(
          //     children: [
          //       CircleAvatar(
          //         backgroundColor: Colors.white,
          //         radius: 40,
          //         child: Padding(
          //           padding: const EdgeInsets.all(2.0),
          //           child: CachedNetworkImage(
          //             imageUrl: userController.userProfile.avatar,
          //             fit: BoxFit.cover,
          //             imageBuilder: (context,provider){
          //               return Container(
          //                 width: 76,
          //                 height: 76,
          //                 clipBehavior: Clip.antiAlias,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(40),
          //                   image:DecorationImage(
          //                     image: provider,
          //                     fit: BoxFit.cover,
          //                   )
          //                 ),
          //               );
          //             },
          //           )
          //         )
          //       ),
          //       SizedBox(height: 10,),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             "${userController.userProfile.nickName}",
          //             style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),
          //           ),
          //           _buildLevelIcon()
          //         ],
          //       ),
          //       SizedBox(
          //         height: 30,
          //       ),
          //       Text(
          //         "${userController.userProfile.email}",
          //         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
              child: FloatingButton(
            label: "Login".tr,
            onTap: () => controller.login(),
          )),
        ],
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
    if (res.code == 0) {
      showSuccess("Success".tr, duration: const Duration(seconds: 3))
          .then((value) => Get.back());
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
