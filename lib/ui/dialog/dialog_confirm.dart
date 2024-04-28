import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colorful_button.dart';
import '../../common/wy_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String info;
  final bool? cancelable;
  final String? confirmBtn;
  final String? concelBtn;
  final Function? onConfirm;

  ConfirmDialog(
      {required this.title,
      required this.info,
      this.cancelable = true,
      this.confirmBtn = "CONFIRM",
      this.concelBtn,
      this.onConfirm});

  @override
  Widget build(BuildContext context) {
    if (title.contains('Cancel Subscription') || title.contains('取消订阅')) {
      return view2(context);
    } else {
      return view1(context);
    }
  }

  ///可滚动
  Widget view2(BuildContext context) {
    return WyDialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text("$info",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ),
            Row(
              children: [
                if (concelBtn != null)
                  Flexible(
                      child: ColorfulButton(
                          height: 40,
                          onTap: () => Navigator.pop(context, true),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "$concelBtn",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "DIN"),
                            ),
                          ))),
                if (concelBtn != null)
                  Container(
                    width: 16,
                  ),
                Flexible(
                    child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "$confirmBtn".tr,
                      style: TextStyle(
                          color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                    ),
                  ),
                  height: 40,
                  onTap: () => onConfirm == null
                      ? Navigator.pop(context, true)
                      : onConfirm!.call(),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  ///不可滚动
  Widget view1(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Text("$info",
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Row(
            children: [
              if (concelBtn != null)
                Flexible(
                    child: ColorfulButton(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "$concelBtn",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "DIN"),
                          ),
                        ),
                        height: 40,
                        onTap: () => Navigator.pop(context, true))),
              if (concelBtn != null)
                Container(
                  width: 16,
                ),
              Flexible(
                  child: ColorfulButton(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "$confirmBtn".tr,
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                  ),
                ),
                height: 40,
                onTap: () => onConfirm == null
                    ? Navigator.pop(context, true)
                    : onConfirm!.call(),
              ))
            ],
          )
        ],
      ),
    );
  }

  static Future<bool?> show(BuildContext context, String title, String info,
      {bool cancelable = true}) async {
    return await showDialog<bool>(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: cancelable,
        builder: (BuildContext context) {
          return ConfirmDialog(
              title: title, info: info, cancelable: cancelable);
        });
  }
}
