import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/wy_dialog.dart';

import 'colorful_button.dart';

class CheckingDialog extends StatelessWidget {

  final String tips;
  CheckingDialog({required this.tips});

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("$tips",style: TextStyle(fontSize: 16, color: Colors.white),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("CANCEL", style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),),
            ),
            height: 40,
            onTap: () => Get.back(result: true)
          )
        ],
      ),
    );
  }

  static Future<bool?> show(BuildContext context, String tips) async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black26,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CheckingDialog(tips: tips,);
      }
    );
  }
}