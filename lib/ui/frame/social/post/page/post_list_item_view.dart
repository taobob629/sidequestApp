import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';

class PostListItemView extends StatelessWidget {
  PostListItemView({Key? key, required this.model}) : super(key: key);
  final PostItemModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.itemBg, width: 1))),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: ExtendedImage.network(
                    model.head,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              model.nickname,
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              model.createTime.toDateStr,
                              style: TextStyle(color: Color(0xff808388), fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Text(
                        model.content,
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: null,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          if (model.imageList.isNotEmpty)
            GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15),
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: min(model.imageList.length, 3),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: model.imageList.length == 1 ? 345 / 195 : 1,
              children: model.imageList
                  .map((imgUrl) => Container(
                        // margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xff313033)),
                        clipBehavior: Clip.antiAlias,
                        child: ExtendedImage.network(
                          imgUrl,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList(),
            ),
          Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/images/profile/icon_pinlun.webp",
                          width: 16,
                        ),
                      ),
                      Text(
                        model.commentNum.toString(),
                        style: TextStyle(
                          color: Color(0xff808388),
                          fontSize: 11.sp,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  // onTap: () => t.praisePost(model),
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            "assets/images/profile/icon_dianzan.webp",
                            width: 16,
                            color: model.isPraise == 1 ? Colors.pink : null,
                          ),
                        ),
                        Text(
                          model.praiseNum.toString(),
                          style: TextStyle(
                            color: Color(0xff808388),
                            fontSize: 11.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/images/profile/icon_liwu.webp",
                          width: 16,
                        ),
                      ),
                      // Text(
                      //   model.commentNum.toString(),
                      //   style: TextStyle(
                      //     color: Color(0xff808388),
                      //     fontSize: 11.sp,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
