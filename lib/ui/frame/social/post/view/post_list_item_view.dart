// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';
import 'package:wy/ui/frame/social/post/contorller/post_list_controller.dart';
import 'package:wy/ui/frame/social/post/contorller/release_post_controller.dart';
import 'package:wy/ui/frame/social/post/more_fun_widget.dart';
import 'package:wy/ui/im/im_util.dart';
import 'package:wy/utils/global_key_constants.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/cs_photo_viewer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:wy/widget/like_button/like_button.dart';
import '../../../../controller/user_controller.dart';
import 'gift_suc_anim.dart';
import 'give_gifts_dialog.dart';

class PostListItemView extends GetView<PostListController> {
  PostListItemView({
    Key? key,
    required this.model,
    this.onTap,
    this.onDelete,
    this.isSelf = false,
    this.ifShowCaseView = false,
    this.index = 0,
  }) : super(key: key);

  bool ifShowCaseView;
  int index;
  final PostItemModel model;
  bool isSelf = false;
  Function()? onTap;
  Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: AppColor.itemBg, width: 1))),
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // if (!isSelf) {
                      NavigatorHelper.toOtherProfile(model.uid);
                      // }
                    },
                    child: ClipOval(
                      child: ImageUtil.networkImage(
                        url: model.head,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  model.nickname,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 120.w,
                                child: Text(
                                  model.addTime.toDateStr,
                                  style: TextStyle(
                                      color: Color(0xff808388),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        ),
                        model.type == TYPE_DEFAULT
                            ? Text(
                                model.content,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                // maxLines: null,
                                // overflow: TextOverflow.ellipsis,
                              )
                            : buildGroupInviteWidget(
                                context, model.content, model.imageList.first),
                        15.horizontalSpace
                      ],
                    ),
                  )),
                  if (isSelf && onDelete != null)
                    GestureDetector(
                      onTap: () => onDelete?.call(),
                      child: Container(
                        child: Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
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
                    .map((imgUrl) => (model.type == TYPE_INVITE)
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff313033)),
                            clipBehavior: Clip.antiAlias,
                            child: QrImage(
                              foregroundColor: Colors.white,
                              data: jsonEncode(Map()..['gid'] = imgUrl),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.dialog(
                                  CsPhotoViewer(
                                    photoList: model.imageList,
                                    tapIndex: model.imageList.indexOf(imgUrl),
                                  ),
                                  useSafeArea: false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xff313033)),
                              clipBehavior: Clip.antiAlias,
                              child: ImageUtil.networkImage(
                                url: imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                    .toList(),
              ),
            Container(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: index == 0
                        ? Showcase(
                            key: GlobalKeyConstants.socialCommentKey,
                            description: 'Comment on this post'.tr,
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      "assets/images/profile/icon_pinlun.webp",
                                      width: 16,
                                    ),
                                  ),
                                  badges.Badge(
                                    showBadge: model.newComment.value > 0,
                                    badgeContent: Text(
                                      '${model.newComment.value}',
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                    position: BadgePosition.topEnd(),
                                    child: Text(
                                      model.commentNum.toString(),
                                      style: TextStyle(
                                        color: Color(0xff808388),
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Image.asset(
                                    "assets/images/profile/icon_pinlun.webp",
                                    width: 16,
                                  ),
                                ),
                                badges.Badge(
                                  showBadge: model.newComment.value > 0,
                                  badgeContent: Text(
                                    '${model.newComment.value}',
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                  position: BadgePosition.topEnd(),
                                  child: Text(
                                    model.commentNum.toString(),
                                    style: TextStyle(
                                      color: Color(0xff808388),
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Expanded(
                    child: index == 0
                        ? Showcase(
                            key: GlobalKeyConstants.socialLikeKey,
                            description: 'Like this post'.tr,
                            child: Container(
                              alignment: Alignment.center,
                              child: Obx(() => badges.Badge(
                                    showBadge: model.newPraise.value > 0,
                                    badgeContent: Text(
                                      '${model.newPraise.value}',
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                    position: BadgePosition.topEnd(end: 14.w),
                                    padding: EdgeInsets.all(3.r),
                                    child: LikeButton(
                                      likeCount: model.praiseNum,
                                      size: 16.sp,
                                      isLiked: model.isPraise.value,
                                      animationDuration:
                                          Duration(milliseconds: 2000),
                                      likeBuilder: (isLiked) => Image.asset(
                                        "assets/images/profile/icon_dianzan.webp",
                                        width: 16,
                                        color: model.isPraise.value
                                            ? Colors.pink
                                            : null,
                                      ),
                                      countBuilder: (count, isLiked, text) =>
                                          Text(
                                        model.praiseNum.toString(),
                                        style: TextStyle(
                                          color: Color(0xff808388),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      onTap: (bool isLiked) async {
                                        if (!isSelf) {
                                          PostListController.find
                                              .praisePost(model)
                                              .then((value) {
                                            if (value) {
                                              model.isPraise.value =
                                                  !model.isPraise.value;
                                              if (model.isPraise.value) {
                                                model.praiseNum += 1;
                                              } else {
                                                model.praiseNum -= 1;
                                              }
                                            }
                                          });
                                        } else {
                                          Get.toNamed(AppPages.PostDetail,
                                                  arguments: model)!
                                              .whenComplete(
                                                  () => controller.onRefresh());
                                        }
                                        return !isLiked;
                                      },
                                    ),
                                  )),
                            ))
                        : Container(
                            alignment: Alignment.center,
                            child: Obx(() => badges.Badge(
                                  showBadge: model.newPraise.value > 0,
                                  badgeContent: Text(
                                    '${model.newPraise.value}',
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                  position: BadgePosition.topEnd(),
                                  padding: EdgeInsets.all(3.r),
                                  child: LikeButton(
                                    likeCount: model.praiseNum,
                                    size: 16.sp,
                                    isLiked: model.isPraise.value,
                                    animationDuration:
                                        Duration(milliseconds: 2000),
                                    likeBuilder: (isLiked) => Image.asset(
                                      "assets/images/profile/icon_dianzan.webp",
                                      width: 16,
                                      color: model.isPraise.value
                                          ? Colors.pink
                                          : null,
                                    ),
                                    countBuilder: (count, isLiked, text) =>
                                        Text(
                                      model.praiseNum.toString(),
                                      style: TextStyle(
                                        color: Color(0xff808388),
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    onTap: (bool isLiked) async {
                                      if (!isSelf) {
                                        PostListController.find
                                            .praisePost(model)
                                            .then((value) {
                                          if (value) {
                                            model.isPraise.value =
                                                !model.isPraise.value;
                                            if (model.isPraise.value) {
                                              model.praiseNum += 1;
                                            } else {
                                              model.praiseNum -= 1;
                                            }
                                          }
                                        });
                                      } else {
                                        Get.toNamed(AppPages.PostDetail,
                                                arguments: model)!
                                            .whenComplete(
                                                () => controller.onRefresh());
                                      }
                                      return !isLiked;
                                    },
                                  ),
                                )),
                          ),
                  ),
                  Visibility(
                    visible: UserController.find.online.value,
                    child: Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) async {
                          if (!isSelf) {
                            var heartNum = await Get.bottomSheet(
                                GiveGiftsDialog(
                                  receiverId: model.uid.toString(),
                                  postId: model.id.toString(),
                                  avatar: model.head,
                                ),
                                ignoreSafeArea: true);
                            if (heartNum != null) {
                              Future.delayed(Duration(milliseconds: 300)).then(
                                (v) {
                                  SmartDialog.show(
                                    builder: (builder) => GiftSucAnim(heartNum),
                                    displayTime: Duration(seconds: 2),
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: index == 0
                            ? Showcase(
                                key: GlobalKeyConstants.socialRewardKey,
                                description: 'Reward this post'.tr,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Image.asset(
                                          "assets/images/profile/icon_liwu.webp",
                                          width: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Image.asset(
                                        "assets/images/profile/icon_liwu.webp",
                                        width: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     behavior: HitTestBehavior.translucent,
                  //     onTapDown: (detail) async {
                  //       final value = await Get.dialog(
                  //         MoreFunWidget(),
                  //         arguments: {
                  //           'offset': detail.globalPosition,
                  //           'nickName': model.nickname,
                  //           'id': model.id,
                  //           'pwId': model.uid,
                  //         },
                  //       );
                  //       if (value != null) {
                  //         PostListController.find.onRefresh();
                  //       }
                  //     },
                  //     child: Icon(
                  //       Icons.clear,
                  //       color: Color(0xff808388),
                  //       size: 16.sp,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
