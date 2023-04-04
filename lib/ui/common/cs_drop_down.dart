import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/app_color.dart';

class DropDownModel {
  String title = "";
}

class CsDropDownDialog extends StatelessWidget {
  CsDropDownDialog({
    Key? key,
    required this.optionContext,
    required this.onTap,
    this.ancesterHeight = 0,
    this.itemList = const [],
  }) : super(key: key);

  final BuildContext optionContext;
  double ancesterHeight = 0;

  List<DropDownModel> itemList = [];

  final Function(int index) onTap;

  final _cellHeight = 40.h;

  @override
  Widget build(BuildContext context) {
    final RenderBox box = optionContext.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.bottomLeft(Offset.zero),
    );
    double viewHeight = min(240, _cellHeight * itemList.length);
    double? positionTop = target.dy;
    double? positionBottom = Get.height - target.dy;

    if (target.dy + viewHeight >= Get.height) {
      positionTop = null;
    } else {
      positionBottom = null;
    }
    debugPrint("left:${target.dx} top:${target.dy}, paddingTop:${MediaQuery.of(Get.context!).padding.top}");
    return Stack(
      children: [
        Positioned(
            left: target.dx,
            top: positionTop,
            bottom: positionBottom,
            child: Container(
              height: viewHeight,
              width: box.size.width,
              decoration: BoxDecoration(
                color: AppColor.itemBg2,
              ),
              // decoration: CommonWidget.whiteShadowDecoration,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: ((context, index) {
                    final item = itemList[index];
                    return InkWell(
                      child: Container(
                        height: _cellHeight,
                        alignment: Alignment.center,
                        child: Text(
                          item.title,
                          style: TextStyle(color: AppColor.colorB9C9, fontSize: 14.sp),
                        ),
                      ),
                      onTap: () {
                        onTap(index);
                        Get.back();
                      },
                    );
                  })),
            )),
      ],
    );
  }
}
