/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/widget/gradient_button.dart';

import 'controller.dart';

class SplashPage extends GetView<SplashPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/im/splash.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment(1, -0.5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Experience gaming like never before\n and PLAY YOUR WAY with SideQuest.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            11.verticalSpace,
            Text(
              'Join a community of gamers, enjoy gaming time in store, and get coaching to take your skills to the next level.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 194, 192, 195),
                fontSize: 13.sp,
              ),
            ),
            30.verticalSpace,
            Container(
              margin: EdgeInsets.all(20).w,
              child: GradientButton(
                  height: 44.h,
                  borderRadius: BorderRadius.all(Radius.circular(16)).w,
                  tapCallback: () => controller.toRegister(),
                  child: Text('Get Started'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp))),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 40.h).r,
              child: GradientButton(
                  height: 44.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)).w,
                      border: Border.all(color: Colors.grey, width: 1)),
                  tapCallback: () => controller.toLogin(),
                  child: Text('I already have an account'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp))),
            ),
          ],
        ),
      ),
    );
  }
}
