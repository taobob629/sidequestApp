import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/utils/utils.dart';

class ItemTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget? actions;

  ItemTitle({required this.title, required this.subTitle, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: Get.width),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
