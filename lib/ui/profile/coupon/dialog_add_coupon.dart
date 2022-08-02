import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/coupon_api.dart';
import 'package:wy/ui/common/wy_dialog.dart';

import '../../common/colorful_button.dart';

class AddCouponDialog extends StatelessWidget {

  AddCouponDialog();

  final controller = Get.put(AddCouponDialogController());

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Add Voucher",style: TextStyle(fontSize: 16, color: Colors.white),),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white10
            ),
            child: TextField(
              maxLines: 1,
              controller: controller.codeController,
              cursorColor: Colors.white70,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onSubmitted: (text) => {},
              decoration: InputDecoration(
                hintText: "Input your voucher code",
                hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 0)
              ),
            ),
          ),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("CONFIRM", style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),),
            ),
            height: 40,
            onTap: () => controller.add()
          )
        ],
      )
    );
    /*
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFFC3C02),width: 3),
        borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
        decoration: BoxDecoration(
          color: Color(0xcc000000)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Add Voucher",style: TextStyle(fontSize: 16, color: Colors.white),),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white10
              ),
              child: TextField(
                maxLines: 1,
                controller: controller.codeController,
                cursorColor: Colors.white70,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onSubmitted: (text) => {},
                decoration: InputDecoration(
                  hintText: "Input your voucher code",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 0)
                ),
              ),
            ),
            ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("CONFIRM", style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),),
              ),
              height: 40,
              onTap: () => controller.add()
            )
          ],
        ),
      ),
    );*/
  }

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddCouponDialog();
      }
    );
  }
}

class AddCouponDialogController extends GetxController{
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

  void add() async{
    String code = codeController.text;
    if(code.isEmpty){
      EasyLoading.showInfo("Please input your voucher code");
      return;
    }
    EasyLoading.show();
    String? msg =  await CouponApi.add(code);
    Get.back(result: msg);
  }
}