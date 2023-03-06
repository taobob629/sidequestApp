import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/frame/social/post/contorller/post_detail_controller.dart';

import 'post_comments_page.dart';

class PostDetailPage extends StatelessWidget {
  PostDetailPage({Key? key}) : super(key: key);
  final t = Get.put(PostDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageTitle(title: "Post Detail"),
        elevation: 0,
      ),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
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
                                t.postItem.value.head,
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
                                          t.postItem.value.nickname,
                                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          t.postItem.value.createTime.toDateStr,
                                          style: TextStyle(color: Color(0xff808388), fontSize: 14, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    t.postItem.value.content,
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
                      if (t.postItem.value.imageList.isNotEmpty)
                        GridView.count(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 15),
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: min(t.postItem.value.imageList.length, 3),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: t.postItem.value.imageList.length == 1 ? 345 / 195 : 1,
                          children: t.postItem.value.imageList
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
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                pinned: true,
                leading: Container(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 120.w,
                      child: TabBar(
                        controller: t.tabController,
                        isScrollable: false,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white38,
                        indicatorColor: Color(0xFFFFCB0D),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3,
                        indicatorPadding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                        labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "din"),
                        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "din"),
                        tabs: [
                          Obx(
                            () => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Image.asset(
                                  "assets/images/profile/icon_pinlun.webp",
                                  width: 16,
                                ),
                              ),
                              Text(
                                t.postItem.value.commentNum.toString(),
                                style: TextStyle(
                                  color: Color(0xff808388),
                                  fontSize: 11.sp,
                                ),
                              )
                            ]),
                          ),
                          Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "assets/images/profile/icon_dianzan.webp",
                                      width: 16,
                                      color: t.postItem.value.isPraise == 1 ? Colors.pink : null,
                                    ),
                                  ),
                                  Text(
                                    t.postItem.value.praiseNum.toString(),
                                    style: TextStyle(
                                      color: Color(0xff808388),
                                      fontSize: 11.sp,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(controller: t.tabController, children: [PostCommentsPage(), Container()])),
    );
  }
}
