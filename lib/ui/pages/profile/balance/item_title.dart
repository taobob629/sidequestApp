import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget? customSubTitle;
  final Widget? actions;
  final double? marginTop;

  ItemTitle({
    required this.title,
    required this.subTitle,
    this.customSubTitle,
    this.actions,
    this.marginTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: Get.width),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: marginTop ?? 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.white, fontFamily: "DIN", fontSize: 20),
            ),
            customSubTitle ??
                Text(
                  subTitle,
                  style: TextStyle(
                      color: Colors.white54, fontFamily: "DIN", fontSize: 18),
                ),
            Spacer(),
            actions ?? Container()
          ],
        ));
  }
}
