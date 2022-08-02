import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/wy_dialog.dart';

import 'colorful_button.dart';

class InputDialog extends StatelessWidget {

  final controller = Get.put(InputDialogController());

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Pin Required",style: TextStyle(fontSize: 16, color: Colors.white),),
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
                hintText: "Input your pin",
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
            onTap: () => Get.back(result: controller.codeController.text)
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
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
        decoration: BoxDecoration(
          color: Color(0xcc000000)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Pin Required",style: TextStyle(fontSize: 16, color: Colors.white),),
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
                  hintText: "Input your pin",
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
              onTap: () => Get.back(result: controller.codeController.text)
            )
          ],
        ),
      ),
    );*/
  }
}

class InputDialogController extends GetxController{
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


}