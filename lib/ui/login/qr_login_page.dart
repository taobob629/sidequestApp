import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/controller/user_controller.dart';

class QrLoginPage extends StatelessWidget {


  late final QrLoginPageController controller;

  final userController = Get.find<UserController>();

  QrLoginPage({required String code}){
    controller = Get.put(QrLoginPageController(code: code));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Authorization".tr,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Icon(
              IconFonts.pc,
              size: 110,
              color: Colors.white38,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 50),
            child: Text(
              "You are signing in to a PC client with account below, do you want to continue?".tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.only(top: 30,bottom: 50),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CachedNetworkImage(
                      imageUrl: userController.userProfile.avatar,
                      fit: BoxFit.cover,
                      imageBuilder: (context,provider){
                        return Container(
                          width: 76,
                          height: 76,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image:DecorationImage(
                              image: provider,
                              fit: BoxFit.cover,
                            )
                          ),
                        );
                      },
                    )
                  )
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${userController.userProfile.nickName}",
                      style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),
                    ),
                    _buildLevelIcon()
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "${userController.userProfile.email}",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingButton(
        label: "CONFIRM".tr,
        onTap: () => controller.login(),
      ),
    );
  }

  Widget _buildLevelIcon(){
    if(userController.userProfile.vipLevel == 0){
      return Container();
    }else{
      return Image.asset("assets/images/ic_level${userController.userProfile.vipLevel}.webp",width: 30,height: 30,);
    }
  }
}

class QrLoginPageController extends GetxController{

  String code;

  QrLoginPageController({required this.code});
  void login() async{
    EasyLoading.show();
    await AuthApi.qrCodeLogin(code);
    EasyLoading.showSuccess("Success".tr, duration: Duration(seconds: 3)).then((value) => Get.back());
  }
}