import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/frame/social/post/contorller/post_list_controller.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../../utils/global_key_constants.dart';
import '../../../../../widget/cs_photo_viewer.dart';
import '../../../../../widget/like_button/like_button.dart';
import '../../../../controller/user_controller.dart';

class PostListPage extends StatelessWidget {
  PostListPage({Key? key}) : super(key: key);

  final t = Get.put(PostListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// post 列表
          Obx(() => SmartRefresher(
            controller: t.refreshController,
            onRefresh: t.onRefresh,
            onLoading: t.loadMore,
            enablePullUp: true,
            enablePullDown: true,
            child: WaterfallFlow.builder(
              padding: EdgeInsets.all(5.0.r),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.r,
                mainAxisSpacing: 10.r,
              ),
              itemBuilder: (BuildContext c, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.toNamed(AppPages.PostDetail,
                      arguments: t.list[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: hexColor('1B1A1E'),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: hexColor('3FFFFFFF'),
                          blurRadius: 2,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (t.list[index].imageList.isNotEmpty)
                          GestureDetector(
                            onTap: () => Get.dialog(
                              CsPhotoViewer(
                                photoList: t.list[index].imageList,
                                tapIndex: t.list[index].imageList
                                    .indexOf(t.list[index].imageList[0]),
                              ),
                              useSafeArea: false,
                            ),
                            child: ExtendedImage.network(
                              t.list[index].imageList[0],
                              fit: BoxFit.cover,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.r),
                                topLeft: Radius.circular(8.r),
                              ),
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 8.h,
                          ),
                          child: Text(
                            t.list[index].content,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            4.horizontalSpace,
                            ExtendedImage.network(
                              t.list[index].head,
                              fit: BoxFit.cover,
                              width: 16.w,
                              height: 16.w,
                              shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            2.horizontalSpace,
                            Text(
                              t.list[index].nickname,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Obx(() => badges.Badge(
                              showBadge: t.list[index].newPraise.value > 0,
                              badgeContent: Text(
                                '${t.list[index].newPraise.value}',
                                style: TextStyle(fontSize: 10.sp),
                              ),
                              position: badges.BadgePosition.topEnd(),
                              padding: EdgeInsets.all(3.r),
                              child: LikeButton(
                                likeCount: t.list[index].praiseNum,
                                size: 16.sp,
                                isLiked: t.list[index].isPraise.value,
                                animationDuration:
                                Duration(milliseconds: 2000),
                                likeBuilder: (isLiked) => Image.asset(
                                  ImageUtils.icon_dianzan,
                                  width: 16,
                                  color: t.list[index].isPraise.value
                                      ? Colors.pink
                                      : hexColor('80ffffff'),
                                ),
                                countBuilder: (count, isLiked, text) =>
                                    Text(
                                      t.list[index].praiseNum.toString(),
                                      style: TextStyle(
                                        color: hexColor('80ffffff'),
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                onTap: (bool isLiked) async {
                                  if (UserController
                                      .find.userProfile.pwId !=
                                      t.list[index].uid) {
                                    PostListController.find
                                        .praisePost(t.list[index])
                                        .then((value) {
                                      if (value) {
                                        t.list[index].isPraise.value =
                                        !t.list[index].isPraise.value;
                                        if (t.list[index].isPraise.value) {
                                          t.list[index].praiseNum += 1;
                                        } else {
                                          t.list[index].praiseNum -= 1;
                                        }
                                      }
                                    });
                                  } else {
                                    Get.toNamed(AppPages.PostDetail,
                                        arguments: t.list[index])!;
                                  }
                                  return !isLiked;
                                },
                              ),
                            )),
                            4.horizontalSpace,
                          ],
                        ),
                        4.verticalSpace,
                      ],
                    ),
                  ),
                );
              },
              itemCount: t.list.length,
            ),
          ),),

          // child: CustomScrollView(
          //   slivers: [
          //     Obx(() {
          //       return SliverList(
          //           delegate: SliverChildBuilderDelegate(
          //                   (BuildContext context, int index) {
          //                 return PostListItemView(
          //                   model: t.list[index],
          //                   isSelf: UserController.find.userProfile.pwId ==
          //                       t.list[index].uid,
          //                   // ifShowCaseView: true,
          //                   index: index,
          //                   onTap: () {
          //                     Get.toNamed(AppPages.PostDetail,
          //                         arguments: t.list[index])!
          //                         .whenComplete(() => t.onRefresh());
          //                   },
          //                 );
          //               }, childCount: t.list.length));
          //     })
          //   ],
          // )),

          /// post 发帖按钮
          Positioned(
            right: 20,
            bottom: 15,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppPages.ReleasePost)?.then((value) {
                    t.onRefresh();
                  });
                },
                child: Showcase(
                  key: GlobalKeyConstants.socialPublishKey,
                  description: 'Click to publish your post',
                  targetShapeBorder: CircleBorder(),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            colors: [Color(0XFFCFAB21), Color(0XFFED5A24)]),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 0.5,
                              offset: Offset(0, 1.5))
                        ]),
                    child: Image.asset(
                      "assets/images/ic_edit_new.webp",
                      width: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
