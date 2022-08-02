import 'package:flutter/material.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/wy_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String info;
  final bool? cancelable;
  final String? confirmBtn;
  final Function? onConfirm;

  ConfirmDialog({
    required this.title,
    required this.info,
    this.cancelable = true,
    this.confirmBtn = "CONFIRM",
    this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title,style: TextStyle(fontSize: 16, color: Colors.white),),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Text("$info" ,style: TextStyle(color: Colors.white,fontSize: 14)),
          ),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("$confirmBtn", style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),),
            ),
            height: 40,
            onTap: ()=> onConfirm == null ? Navigator.pop(context,true) : onConfirm!.call(),
          )
        ],
      ),
    );
  }

  static Future<bool?> show(BuildContext context, String title, String info, {bool cancelable = true}) async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black26,
      barrierDismissible: cancelable,
      builder: (BuildContext context) {
        return ConfirmDialog(title: title, info: info, cancelable: cancelable);
      }
    );
  }
}