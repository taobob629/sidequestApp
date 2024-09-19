/**
    author:mac
    创建日期:2023/2/10
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../image_utils.dart';
import '../../../../../model/game_model.dart';
import '../controller.dart';

class GameWidget extends StatelessWidget {
  final controller = Get.put(ChooseGamePageController());

  late SimpleGameModel item;

  GameWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.updateSelectedGames(item),
      child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)).w,
                      child: Image.network(item.icon ?? '')),
                  10.verticalSpace,
                  Text(
                    '${item.name}',
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              )),
          Positioned(
              top: 0,
              right: 0,
              child: Obx(() => Visibility(
                    visible: controller.selected_games.contains(item),
                    child: Image.asset(ImageUtils.ic_checked, height: 20),
                  ))),
        ],
      ),
    );
  }
}
