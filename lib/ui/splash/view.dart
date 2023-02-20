/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_config.dart';
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
                image: NetworkImage(splashBg),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Thousands of games,tasty food\n and lots of fun to be had',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            11.verticalSpace,
            Text(
              'Play anywhere,any time,hundreds of games,\n dozens ofd  stores,unlimited coaches,infinite fun',
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
                  height: 40,
                  borderRadius: BorderRadius.all(Radius.circular(16)).w,
                  tapCallback: () => controller.toRegister(),
                  child:
                      Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 16.sp))),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16).r,
              child: GradientButton(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)).w,
                      border: Border.all(color: Colors.grey, width: 1)),
                  tapCallback: () => controller.toLogin(),
                  child: Text('I already have an account',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp))),
            ),
          ],
        ),
      ),
    );
  }
}
