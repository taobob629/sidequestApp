/*
  banner
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
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
            return ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().radius(40)),
              ),
              child: Image.network(
                "https://via.placeholder.com/350x150",
                fit: BoxFit.fill,
              ),
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
