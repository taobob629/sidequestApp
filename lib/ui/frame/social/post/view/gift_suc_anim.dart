import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../widget/cs_Intimacy_progress_gift.dart';
import '../../../../controller/user_controller.dart';

class GiftSucAnim extends StatefulWidget {
  String result;

  GiftSucAnim(this.result);

  @override
  State<GiftSucAnim> createState() => _GiftSucAnimState();
}

class _GiftSucAnimState extends State<GiftSucAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late int maxIntimacy;
  late int currentIntimacy;
  late String intimacyLevel;
  late String avatar;

  @override
  void initState() {
    super.initState();
    // 创建动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // 创建动画
    _animation = Tween<double>(begin: 0, end: 1.0).animate(_controller);

    // 启动动画
    _controller.forward();

    try {
      Map<String, dynamic> json = parseDataString(widget.result);
      maxIntimacy = json['maxIntimacy'];
      currentIntimacy = json['currentIntimacy'];
      intimacyLevel = json['intimacyLevel'];
      avatar = json['avatar'];
    } catch (e) {
      showToast(e.toString());
    }
  }

  Map<String, dynamic> parseDataString(String dataString) {
    final Map<String, dynamic> data = {};

    final RegExp regExp = RegExp(r"(\w+): ([^,}]+)");
    final Iterable<Match> matches = regExp.allMatches(dataString);

    for (Match match in matches) {
      final String key = match.group(1)!;
      final String valueString = match.group(2)!;

      if (valueString.startsWith("https://")) {
        data[key] = valueString;
      } else if (valueString.toLowerCase().startsWith("lv")) {
        data[key] = valueString;
      } else {
        data[key] = int.parse(valueString);
      }
    }

    return data;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (c, child) => Transform.scale(
        scale: _animation.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, 40.h),
              child: Image.asset(
                ImageUtils.friendship_img,
                width: 258.w,
                height: 60.h,
              ),
            ),
            Stack(
              children: [
                Image.asset(
                  ImageUtils.gift_bg,
                  width: Get.width - 80.w,
                ),
                Positioned(
                  top: 130.h,
                  left: 0,
                  right: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ExtendedImage.network(
                            avatar,
                            border: Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.circle,
                            width: 44.w,
                            height: 44.h,
                            fit: BoxFit.cover,
                          ),
                          6.horizontalSpace,
                          ExtendedImage.network(
                            UserController.find.userProfile.avatar,
                            border: Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.circle,
                            width: 44.w,
                            height: 44.h,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/images/icon_loveship.webp",
                        width: 21.w,
                        height: 21.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 250.w,
              child: CsIntimacyProgressGift(
                lv: intimacyLevel,
                currentIntimacy: currentIntimacy,
                maxIntimacy: maxIntimacy,
              ),
            )
          ],
        ),
      ),
    );
  }
}
