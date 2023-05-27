import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/icon_font.dart';

class CsIntimacyProgressGift extends StatelessWidget {
  CsIntimacyProgressGift({
    Key? key,
    this.lv = "",
    this.currentIntimacy = 0,
    this.maxIntimacy = 1000,
  }) : super(key: key);

  String lv = "";
  int currentIntimacy = 0;
  int maxIntimacy = 1000;

  @override
  Widget build(BuildContext context) {
    if (maxIntimacy == 0) {
      maxIntimacy = 1000;
    }
    return Row(
      children: [
        Text(
          "$lv",
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
          ),
        ),
        6.horizontalSpace,
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(3.r)),
              ),
              Row(
                children: [
                  Expanded(
                    flex: currentIntimacy == 0 ? 1 : currentIntimacy,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 13,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFFFFA06E),
                                  Color(0xFFFF2CB9),
                                ]),
                                borderRadius: BorderRadius.circular(3.r)),
                          ),
                        ),
                        Positioned(
                          left: (currentIntimacy / maxIntimacy < 13 / 190.0)
                              ? 0
                              : null,
                          right: (currentIntimacy / maxIntimacy < 13 / 190.0)
                              ? null
                              : 0,
                          height: 13,
                          child: Image.asset(
                              "assets/images/profile/icon_love_progress.webp",
                              height: 13),
                        )
                      ],
                    ),
                  ),
                  Spacer(flex: maxIntimacy - currentIntimacy)
                ],
              )
            ],
          ),
        ),
        6.horizontalSpace,
        Text(
          "$currentIntimacy/$maxIntimacy",
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
          ),
        ),
      ],
    );
  }
}