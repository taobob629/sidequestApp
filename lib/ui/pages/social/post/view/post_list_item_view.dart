// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/utils/my_swiper_pagination.dart';

import '../../../../../api/user_api.dart';
import '../../../../../config/app_color.dart';
import '../../../../../config/icon_font.dart';
import '../../../../../controller/user_controller.dart';
import '../../../../../model/post_item_model.dart';
import '../../../../../utils/navigator_helper.dart';
import '../../../../../utils/toast_utils.dart';
import '../../../../../widget/cs_photo_viewer.dart';
import '../../../../../widget/image_util.dart';
import '../../../../../widget/level.dart';
import '../../../../../widget/like_button/like_button.dart';
import '../../../../im/im_util.dart' as imUtil;
import '../post_detail_page.dart';
import '../post_list_controller.dart';
import '../release_post_controller.dart';
import 'gift_animation.dart';
import 'gift_suc_anim.dart';
import 'give_gifts_dialog.dart';

class PostListItemView extends GetView<PostListController> {
  PostListItemView({
    Key? key,
    required this.model,
    this.onTap,
    this.onDelete,
    this.isSelf = false,
    // this.ifShowCaseView = false,
    this.index = 0,
  }) : super(key: key) {
    if (!Get.isRegistered<PostListController>()) {
      Get.put(PostListController());
    }
  }

  // bool ifShowCaseView;
  int index;
  final PostItemModel model;
  bool isSelf = false;
  Function()? onTap;
  Function()? onDelete;
  var followStr = "Follow".obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 6.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isSelf) {
                      NavigatorHelper.toOtherProfile(model.memberId);
                    }
                  },
                  child: ClipOval(
                    child: ImageUtil.networkImage(
                      url: model.head,
                      fit: BoxFit.cover,
                      width: 40.w,
                      height: 40.w,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              model.nickname,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        3.verticalSpace,
                        Text(
                          controller.dealDateTime(model.addTime),
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
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
                  ),
              ],
            ),
            12.verticalSpace,
            model.type == TYPE_DEFAULT
                ? Text(
                    model.content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : imUtil.buildGroupInviteWidget(
                    context, model.content, model.imageList.first),
            if (model.imageList.isNotEmpty)
              Container(
                height: 210.h,
                margin: EdgeInsets.only(top: 15.h),
                child: Swiper(
                  itemCount: model.imageList.length,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: SwiperCustomPagination(
                        builder: (context, config) => MySwiperPagination(
                              config.activeIndex,
                              model.imageList.length,
                            )),
                  ),
                  itemBuilder: (c, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: model.type == TYPE_INVITE
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff313033)),
                            clipBehavior: Clip.antiAlias,
                            child: QrImage(
                              foregroundColor: Colors.white,
                              data: jsonEncode(
                                  Map()..['gid'] = model.imageList[i]),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.dialog(
                                  CsPhotoViewer(
                                    photoList: model.imageList,
                                    tapIndex: model.imageList
                                        .indexOf(model.imageList[i]),
                                  ),
                                  useSafeArea: false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xff313033),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: ImageUtil.networkImage(
                                url: model.imageList[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            15.verticalSpace,
            Row(
              children: [
                Obx(() => badges.Badge(
                      showBadge: model.newPraise.value > 0,
                      badgeContent: Text(
                        '${model.newPraise.value}',
                        style: TextStyle(fontSize: 10.sp),
                      ),
                      position: BadgePosition.topEnd(),
                      padding: EdgeInsets.all(3.r),
                      child: LikeButton(
                        // likeCount: model.praiseNum,
                        size: 24.w,
                        isLiked: model.isPraise.value,
                        animationDuration: Duration(milliseconds: 2000),
                        likeBuilder: (isLiked) => Image.asset(
                          ImageUtils.icon_dianzan,
                          color: model.isPraise.value ? Colors.pink : null,
                        ),
                        countBuilder: (count, isLiked, text) => Text(
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
                                model.isPraise.value = !model.isPraise.value;
                                if (model.isPraise.value) {
                                  model.praiseNum += 1;
                                } else {
                                  model.praiseNum -= 1;
                                }
                              }
                            });
                          } else {
                            Get.to(() => PostDetailPage(), arguments: model)!
                                .whenComplete(() => controller.onRefresh());
                          }
                          return !isLiked;
                        },
                      ),
                    )),
                24.horizontalSpace,
                badges.Badge(
                  showBadge: model.newComment.value > 0,
                  badgeContent: Text(
                    '${model.newComment.value}',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                  position: BadgePosition.topEnd(),
                  child: Image.asset(
                    ImageUtils.icon_pinlun,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                // 24.horizontalSpace,
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTapDown: (details) async {
                //     if (!isSelf) {
                //       var heartNum = await Get.bottomSheet(
                //           GiveGiftsDialog(
                //             receiverId: model.uid.toString(),
                //             postId: model.id.toString(),
                //             avatar: model.head,
                //           ),
                //           ignoreSafeArea: true);
                //       if (heartNum != null) {
                //         Future.delayed(Duration(milliseconds: 300)).then(
                //               (v) {
                //             SmartDialog.show(
                //               builder: (builder) => GiftSucAnim(heartNum),
                //               displayTime: Duration(seconds: 2),
                //             );
                //           },
                //         );
                //       }
                //     }
                //   },
                //   child: Image.asset(
                //     ImageUtils.icon_liwu,
                //     width: 24.w,
                //     height: 24.w,
                //   ),
                // ),
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
          ],
        ),
      ),
    );
  }
}
