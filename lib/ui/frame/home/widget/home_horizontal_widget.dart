/*
  home_horizontal_widget
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/ui/index/tab_headlines_page.dart';
import 'package:get/get.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/navigator_helper.dart';

class HomeHorizontalWidget extends GetView<TabHeadlinesPageController> {
  late String label;
  late List<SimpleGameModel> items;
  Function()? onTapMore;
  Function()? onTapItems;

  HomeHorizontalWidget(this.label, this.items, {this.onTapMore, this.onTapItems});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Obx(
      () => Visibility(
        visible: controller.topPlayers.isNotEmpty,
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: 16).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  16.horizontalSpace,
                  Text(
                    label,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: onTapMore,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 17,
                      )),
                ],
              ),
              // 10.verticalSpace,
              Container(
                //padding: EdgeInsets.only(left: 15).r,
                height: 110.w,
                child: ListView.separated(
                  itemCount: items.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    var item = items[index];
                    return InkWell(
                      onTap: () => NavigatorHelper.toOtherProfile(item.id),
                      child: Container(
                        margin: EdgeInsets.only(left: index == 0 ? 10 : 0).w,
                        width: 104.w,
                        height: 104.w,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().radius(10).r),
                            ),
                            child: ImageUtil.networkImage(url: '${item.image}', fit: BoxFit.cover)),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => SizedBox(
                    width: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
