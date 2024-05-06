/**
    author:mac
    创建日期:2023/3/2
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/user_info_model.dart';
import '../config/icon_font.dart';
import '../controller/user_controller.dart';
import '../ui/pages/profile/grade/index.dart';

class GameLevelWidget extends StatelessWidget {
  int level = 0;
  var userId;
  var isAuth;
  double height;

  GameLevelWidget({
    this.level = 1,
    this.userId,
    this.isAuth = TYPE_VIP,
    this.height = 24,
  });

  var user = Get.find<UserController>().userProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => userId == user.pwId ? Get.to(() => GradePage()) : null,
      child: isAuth != TYPE_VIP
          ? userIcon(level, height: height)
          : Image.asset(
              isAuth == TYPE_VIP ? 'assets/images/lv$level' : 'assets/images/titles_$level',
              height: 15.w,
            ),
    );
  }
}

userIcon(int level, {double height = 24}) {
  return Container(
    height: height,
    width: height * 3,
    constraints: BoxConstraints(maxWidth: height * 3),
    padding: EdgeInsets.symmetric(horizontal: height / 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(height / 2)),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: getColors(level))),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/${getUserImg(level)}',
          height: height - 2,
          width: height - 2,
        ),
        Spacer(),
        Text(
          getUserText(level),
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: FONT_MEDIUM,
          ),
        ),
      ],
    ),
  );
}

getUserImg(int level) {
  if (level > 9) {
    return 'SVIP${level - 9 + 1}';
  }
  return 'VIP$level';
}

getUserText(int level) {
  if (level > 9) {
    return 'SVIP${level - 9 + 1}';
  }
  return 'VIP$level';
}

getColors(int level) {
  switch (level) {
    case 0:
    case 1:
      return [
        Color(0xffEDFEF6),
        Color(0xff5B6F75),
        // Color(0xffEDFEF6),
      ];
    case 2:
      return [
        Color(0xffF9EDFE),
        Color(0xff8F8AF4),
      ];
    case 3:
    case 4:
      return [
        Color(0xffFEEDFE),
        Color(0xffCD8AF4),
      ];
    case 5:
      return [
        Color(0xffD5EEFF),
        Color(0xff64BEEC),
      ];
    case 6:
    case 7:
    case 8:
      return [
        Color(0xffF8D5FF),
        Color(0xffA197FB),
      ];
    case 9:
    case 10:
    case 11:
    case 12:
      return [
        Color(0xffF5CD63),
        Color(0xffFFCF80),
        Color(0xffFFA1A1),
      ];
    default:
      return [
        Color(0xffF5CD63),
        Color(0xffFFCF80),
        Color(0xffFF6F6F),
      ];
  }
}
