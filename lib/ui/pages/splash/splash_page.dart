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
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/main_page.dart';
import 'package:sq_hub_app/ui/pages/splash/splash_page_ctr.dart';

import '../../../widget/gradient_button.dart';

class SplashPage extends StatelessWidget {

  final controller = Get.put(SplashPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageUtils.splash_logo, scale: 3,),
            40.verticalSpace,
            Text(
              'Thousands of games, tasty food and lots of fun to be had',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            15.verticalSpace,
            Text(
              'Play anywhere, anytime, hundreds of games, drozens of stores, unlimited coaches, infinite fun!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 194, 192, 195),
                fontSize: 13.sp,
              ),
            ),
            80.verticalSpace,
            Container(
              margin: const EdgeInsets.all(20).w,
              child: GradientButton(
                  height: 44.h,
                  borderRadius: const BorderRadius.all(Radius.circular(40)).w,
                  tapCallback: () => Get.offAll(() => MainPage()),
                  child: Text('Get Started'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp))),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 40.h).r,
              child: GradientButton(
                  height: 44.h,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40)).w,
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
