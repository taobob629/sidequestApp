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

class HomeHorizontalWidget extends StatelessWidget {
  late String label;
  late List<String> items;
  Function()? onTapMore;
  Function()? onTapItems;

  HomeHorizontalWidget(this.label, this.items, {this.onTapMore, this.onTapItems});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                28.horizontalSpace,
                Text(
                  label,
                  style:
                      TextStyle(color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                    onPressed: onTapMore,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColor.yellow,
                      size: 17,
                    )),
              ],
            ),
            // 10.verticalSpace,
            Container(
              padding: EdgeInsets.only(left: 10, right: 10).r,
              height: 140.w,
              child: ListView.separated(
                itemCount: items.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var item = items[index];
                  return Container(
                    width: 138.w,
                    height: 138.w,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().radius(20)),
                        ),
                        child: Image.network(
                          item,
                          fit: BoxFit.fill,
                        )),
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
    );
  }
}
