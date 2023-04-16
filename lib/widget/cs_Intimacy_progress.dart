// ignore_for_file: must_be_immutable

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/icon_font.dart';

class CsIntimacyProgress extends StatelessWidget {
  CsIntimacyProgress({Key? key, this.firstAvatar = "", this.secondAvatar = "", this.lv = "", this.currentIntimacy = 0, this.maxIntimacy = 1000}) : super(key: key);

  String firstAvatar = "";
  String secondAvatar = "";
  String lv = "";
  int currentIntimacy = 0;
  int maxIntimacy = 1000;

  @override
  Widget build(BuildContext context) {
    if (maxIntimacy == 0) {
      maxIntimacy = 1000;
    }
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        image: DecorationImage(image: AssetImage("assets/images/profile/icon_intimacy_bg.webp"), fit: BoxFit.cover),
      ),
      child: Row(
        children: [
          6.horizontalSpace,
          Container(
            height: 24.h,
            width: 44.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: ExtendedImage.network(
                    firstAvatar,
                    border: Border.all(color: Colors.white, width: 1),
                    shape: BoxShape.circle,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ExtendedImage.network(
                    secondAvatar,
                    border: Border.all(color: Colors.white, width: 1),
                    shape: BoxShape.circle,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                Image.asset("assets/images/icon_loveship.webp", width: 12.w, height: 12.h)
              ],
            ),
          ),
          Container(
            width: 30.w,
            alignment: Alignment.center,
            child: Text(
              "$lv",
              style: TextStyle(fontSize: 10.sp, color: Colors.white, fontFamily: FONT_LIGHT),
            ),
          ),
          Expanded(
              child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 6.h,
                decoration: BoxDecoration(color: Color(0xFFB0B7FA), borderRadius: BorderRadius.circular(3.r)),
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
                                  Color(0xFFF7DDAE),
                                  Color(0xFFF1A067),
                                ]),
                                borderRadius: BorderRadius.circular(3.r)),
                          ),
                        ),
                        Positioned(
                          left: (currentIntimacy / maxIntimacy < 13 / 190.0) ? 0 : null,
                          right: (currentIntimacy / maxIntimacy < 13 / 190.0) ? null : 0,
                          height: 13,
                          child: Image.asset("assets/images/profile/icon_love_progress.webp", height: 13),
                        )
                      ],
                    ),
                  ),
                  Spacer(flex: maxIntimacy - currentIntimacy)
                ],
              )
            ],
          )),
          Container(
            width: 70.w,
            alignment: Alignment.center,
            child: Text(
              "$currentIntimacy/$maxIntimacy",
              style: TextStyle(fontSize: 9.sp, color: Colors.white, fontFamily: FONT_LIGHT),
            ),
          ),
        ],
      ),
    );
  }
}
