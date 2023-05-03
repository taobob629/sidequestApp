import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/pay_api.dart';
import 'package:wy/ui/common/wy_dialog.dart';

import '../../utils/toast_utils.dart';
import '../login/forget_page.dart';
import 'colorful_button.dart';

class PasswordDialog extends StatelessWidget {

  final controller = Get.put(PasswordDialogController());

  late final String title;

  PasswordDialog({this.title = "Input your payment pin"});

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title.tr, style: TextStyle(fontSize: 16, color: Colors.white),),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white10
            ),
            child: TextField(
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))//设置只允许输入数字
              ],
              keyboardType: TextInputType.number,
              controller: controller.codeController,
              cursorColor: Colors.white70,
              textAlign: TextAlign.start,
              obscureText: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onSubmitted: (text) => {},
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 0)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap:()=> Get.to(()=>ForgetPage(type: 2,)),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Forgotten?".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "CONFIRM".tr,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                ),
              ),
            height: 40,
            onTap: () => controller.check()
          )
        ],
      ),
    );
    /*
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFFC3C02),width: 3),
        borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: Color(0xcc000000)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 16, color: Colors.white),),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white10
              ),
              child: TextField(
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))//设置只允许输入数字
                ],
                keyboardType: TextInputType.number,
                controller: controller.codeController,
                cursorColor: Colors.white70,
                textAlign: TextAlign.start,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onSubmitted: (text) => {},
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 0)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap:()=> Get.to(()=>ForgetPage(type: 2,)),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Forgotten?",
                    style: TextStyle(color: Colors.white,fontSize: 14,),
                  ),
                ),
              ),
            ),
            ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("CONFIRM", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),),
              ),
              height: 40,
              onTap: () => controller.check()
            )
          ],
        ),
      ),
    );*/
  }
}

class PasswordDialogController extends GetxController{
  late TextEditingController codeController;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    codeController.dispose();
  }

  void check() async{
    String code = codeController.text;
    if(code.isEmpty){
      showToast("Please input your payment pin".tr);
      return;
    }
    showLoading();
    bool check = await PayApi.checkPassword(code);
    dismissLoading();
    if(check){
      codeController.text = "";
      Get.back(result: check);
    }else{
      showToast("Wrong payment pin".tr);
    }
  }
}