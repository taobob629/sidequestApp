/**
    author:mac
    创建日期:2023/3/2
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/image_util.dart';

import '../../model/user_info_model.dart';

class GameLevelWidget extends StatelessWidget {
  int level = 0;
  var userId;
  var isAuth;

  GameLevelWidget({this.level = 1, this.userId, this.isAuth =TYPE_VIP });
  var user = Get.find<UserController>().userProfile;

  @override
  Widget build(BuildContext context) {
    var isauth = user.isAuth;
    return isauth != TYPE_VIP
        ? Container()
        : GestureDetector(
            onTap: () => userId == user.pwId ? Get.toNamed(AppPages.Grade) : null,
            child: ImageUtil.assetImage(
                (isAuth == TYPE_VIP ? 'play/lv$level' : 'play/titles_$level'),
                imageType: IMG_WEBP,height: 15.w));
  }
}
