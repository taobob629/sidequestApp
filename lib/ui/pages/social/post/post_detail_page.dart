import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/string_ext.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_comments_page.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_detail_controller.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_favorators_page.dart';
import 'package:sq_hub_app/ui/pages/social/post/release_post_controller.dart';

import '../../../../../../widget/cs_photo_viewer.dart';
import '../../../../../common/page_title.dart';
import '../../../../../config/app_color.dart';
import '../../../../../config/icon_font.dart';
import '../../../../utils/navigator_helper.dart';
import '../more_fun_widget.dart';

Widget buildGroupInviteWidget(BuildContext context, var content, String gid) {
  // RegExpMatch? match = exp.firstMatch(content);
  // var gid = match?.group(1) ?? '';
  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text: content,
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    TextSpan(
        text: ' Join Now '.tr,
        recognizer: TapGestureRecognizer()..onTap = () {},
        style: TextStyle(
            letterSpacing: 2,
            wordSpacing: 1,
            fontFamily: FONT_MEDIUM,
            decoration: TextDecoration.underline,
            // backgroundColor: Colors.red,
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.bold)),
  ]));
}

class PostDetailPage extends StatelessWidget {
  PostDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Get.put(PostDetailController());

    return WillPopScope(
      onWillPop: () {
        // PostListController.find.onRefresh();
        Get.back(result: "Reload");
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: PageTitle(title: "".tr),
          elevation: 0,
        ),
        body: Obx(() => NestedScrollView(
              controller: t.scrollController,
              physics: t.canScroll
                  ? ClampingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColor.itemBg, width: 1))),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => NavigatorHelper.toOtherProfile(
                                      t.postItem.value.uid),
                                  child: ClipOval(
                                    child: Image.network(
                                      t.postItem.value.head,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              child: Text(
                                                t.postItem.value.nickname,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              t.postItem.value.createTime
                                                  .toDateStr,
                                              style: TextStyle(
                                                  color: Color(0xff808388),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      t.postItem.value.type == TYPE_INVITE
                                          ? buildGroupInviteWidget(
                                              context,
                                              t.postItem.value.content,
                                              t.postItem.value.imageList.first)
                                          : Text(
                                              t.postItem.value.content,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              // maxLines: null,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                      10.verticalSpace
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
                              crossAxisCount:
                                  min(t.postItem.value.imageList.length, 3),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio:
                                  t.postItem.value.imageList.length == 1
                                      ? 345 / 195
                                      : 1,
                              children: t.postItem.value.imageList
                                  .map((imgUrl) => t.postItem.value.type ==
                                          TYPE_INVITE
                                      ? Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Color(0xff313033)),
                                          clipBehavior: Clip.antiAlias,
                                          // child: QrImage(
                                          //   foregroundColor: Colors.white,
                                          //   data: imgUrl,
                                          // ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Get.dialog(
                                                CsPhotoViewer(
                                                  photoList: t
                                                      .postItem.value.imageList,
                                                  tapIndex: t
                                                      .postItem.value.imageList
                                                      .indexOf(imgUrl),
                                                ),
                                                useSafeArea: false);
                                          },
                                          child: Container(
                                            // margin: EdgeInsets.only(top: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Color(0xff313033)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              imgUrl,
                                              fit: BoxFit.cover,
                                            ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120.w,
                              child: TabBar(
                                controller: t.tabController,
                                isScrollable: false,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white38,
                                indicatorColor: Color(0xFFFFCB0D),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorWeight: 3,
                                indicatorPadding: EdgeInsets.only(
                                    bottom: 0, left: 10, right: 10),
                                labelPadding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 8),
                                labelStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "din"),
                                unselectedLabelStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "din"),
                                tabs: [
                                  Obx(
                                    () => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Image.asset(
                                              ImageUtils.icon_pinlun,
                                              width: 16,
                                            ),
                                          ),
                                          Text(
                                            t.postItem.value.commentNum
                                                .toString(),
                                            style: TextStyle(
                                              color: Color(0xff808388),
                                              fontSize: 11.sp,
                                            ),
                                          )
                                        ]),
                                  ),
                                  Obx(() => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Image.asset(
                                              ImageUtils.icon_dianzan,
                                              width: 16,
                                              color: t.postItem.value.isPraise
                                                      .value
                                                  ? Colors.pink
                                                  : null,
                                            ),
                                          ),
                                          Text(
                                            t.postItem.value.praiseNum
                                                .toString(),
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
                            Container(
                              margin: EdgeInsets.only(
                                right: 15.w,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTapDown: (detail) => Get.dialog(
                                  MoreFunWidget(),
                                  arguments: {
                                    'offset': detail.globalPosition,
                                    'nickName': t.postItem.value.nickname,
                                    'id': t.postItem.value.id,
                                    'pwId': t.postItem.value.uid,
                                  },
                                ).then((value) => Get.back(result: true)),
                                child: Icon(
                                  Icons.more_vert_outlined,
                                  color: Color(0xff808388),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: t.tabController,
                children: [
                  PostCommentsPage(),
                  PostFavoratorsPage(),
                ],
              ),
            )),
      ),
    );
  }
}
