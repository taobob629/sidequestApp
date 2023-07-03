/*
  banner
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/home/controller.dart';

class BannerWidget extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: Get.width,
        height: 300.h,
        child: Swiper(
          outer: true,
          viewportFraction: 0.8,
          scale: 0.95,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().radius(40)),
                  ),
                  child: Image.network(
                    "https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1666015473587.jpg",
                    fit: BoxFit.cover,
                    height: 300.h,
                  ),
                ),
                Positioned(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          //设置按下时的背景颜色
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          //默认不使用背景颜色
                          return Colors.white54;
                        }),
                      ),
                      child: Text(
                        'IAM17 flutter 天天更新',
                        style: TextStyle(
                            color: Color.fromARGB(255, 6, 6, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 19.sp),
                      ),
                      onPressed: () {}),
                  bottom: 30.w,
                  left: 30.w,
                  right: 30.w,
                )
              ],
            );
          },
          itemCount: 3,
          pagination: SwiperPagination(
              builder: RectSwiperPaginationBuilder(
                  color: AppColor.greyAF,
                  activeColor: AppColor.yellow,
                  size: Size(10, 10),
                  activeSize: Size(18, 10))),
        ),
      ),
    );
  }
}
