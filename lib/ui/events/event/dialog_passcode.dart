import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/wy_dialog.dart';

class PasscodeDialog extends StatelessWidget {

  final int passcode;

  PasscodeDialog({required this.passcode});

  final controller = Get.put(PasscodeDialogController());

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Team Passcode".tr,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Please remember your team passcode and send it to your team members.".tr,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text("$passcode", style: TextStyle(fontSize: 32, color: Colors.white),),
          ),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "COPY".tr,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                ),
              ),
            height: 40,
            onTap: () {
              Clipboard.setData(ClipboardData(text: passcode.toString()));
              Get.back();
            }
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
            Text("Team Passcode", style: TextStyle(fontSize: 16, color: Colors.white),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Please remember your team passcode and send it to your team members.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text("$passcode", style: TextStyle(fontSize: 32, color: Colors.white),),
            ),
            ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("COPY", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),),
              ),
              height: 40,
              onTap: () {
                Clipboard.setData(ClipboardData(text: passcode.toString()));
                Get.back();
              }
            )
          ],
        ),
      ),
    );*/
  }
}

class PasscodeDialogController extends GetxController{



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}