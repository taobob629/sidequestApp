/**
    author:mac
    创建日期:2023/2/10
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/ui/login/choose_game/controller.dart';
import 'package:wy/utils/image_util.dart';

class GameWidget extends GetView<ChooseGamePageController> {
  late SimpleGameModel item;

  GameWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>controller.updateSelectedGames(item),
      child: Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)).w,
                    child: ImageUtil.networkImage(url: item.icon ?? '')),
                10.verticalSpace,
                Text(
                  '${item.name}',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontSize: 10.sp, overflow: TextOverflow.ellipsis),
                )
              ],
            )),
        Positioned(
            top: 0,
            right: 0,
            child: Obx(()=>Visibility(
              visible: controller.selected_games.contains(item),
              child: ImageUtil.assetImage('ic_checked', height: 20),
            ))),
      ],
    ),);
  }
}
