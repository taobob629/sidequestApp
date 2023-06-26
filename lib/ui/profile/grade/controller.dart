/*
  controoler
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/model/level_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/utils.dart';

class GradeController extends GetxController {
  RxBool _isLoadding = RxBool(true);

  bool get isLoadding => _isLoadding.value;

  set isLoadding(bool value) {
    _isLoadding.value = value;
  }

  UserController userController = Get.find<UserController>();
  late LevelModel model;
  late int isauth;

  @override
  void onInit() {
    super.onInit();
    isauth = userController.userProfile.isAuth;
    initData();
  }

  //获取等级数据
  initData() async {
    model = await UserApi.level(isauth);
    isLoadding = false;
  }

  String centerImg() {
    var img;
    int level = model.userLevel;
    if (!isVip()) {
      switch (level) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        img = 'assets/images/grade/VIP$level.webp';
        break;
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        img = 'assets/images/grade/SVIP${(level-9)+1}.webp';
          break;
      }
    } else {
      if (level == 0) {
        img = 'assets/images/play/v_lv1.webp';
      } else {
        img = 'assets/images/play/v_lv$level.webp';
      }
    }
    return img;
  }

  curLevelImg() {
    if (model.userLevel == 0) {
      if (isauth == TYPE_VIP)
        return 'assets/images/play/${isauth == TYPE_VIP ? '' : ''}lv1.webp';
    }
    return 'assets/images/play/${isauth == TYPE_VIP ? '' : ''}lv${model.userLevel}.webp';
  }

  nextLevelImg(){
    if (model.userLevel == 0) {
      if (isauth == TYPE_VIP)
        return 'assets/images/play/${isauth == TYPE_VIP ? '' : ''}lv1.webp';
    }
    return 'assets/images/play/${isauth == TYPE_VIP ? '' : ''}lv${model.userLevel+1}.webp';
  }

 bool isTopLevel(){
    // if(isauth == TYPE_VIP){
    //   return model.userLevel>=5;
    // }
    return model.userLevel>=5;
 }
 bool isVip(){
    return false;
    return isauth == TYPE_VIP;
 }
}
