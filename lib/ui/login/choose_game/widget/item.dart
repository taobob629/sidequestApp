/**
    author:mac
    创建日期:2023/2/10
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/utils/image_util.dart';
import 'package:get/get.dart';

class GameWidget extends StatelessWidget {
  late SimpleGameModel item;

  GameWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                ImageUtil.assetImage('default_logo',
                    width: (Get.width - 50.w) / 3,
                    height: (Get.width - 50.w) / 3 * 68 / 52,
                    fit: BoxFit.fill),
                10.verticalSpace,
                Text(
                  '${item.name}',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                )
              ],
            )),
        Positioned(top: 0, right: 0, child: ImageUtil.assetImage('ic_checked', height: 20)),
      ],
    );
  }
}
