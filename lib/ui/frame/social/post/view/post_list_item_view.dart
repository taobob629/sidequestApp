// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';
import 'package:wy/ui/frame/social/post/contorller/post_list_controller.dart';
import 'package:wy/ui/frame/social/post/view/gift_animation.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/cs_photo_viewer.dart';

import 'give_gifts_dialog.dart';

class PostListItemView extends StatelessWidget {
  PostListItemView({Key? key, required this.model, this.onTap, this.onDelete, this.isSelf = false}) : super(key: key);
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
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.itemBg, width: 1))),
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
                    .map((imgUrl) => GestureDetector(
                          onTap: () {
                            Get.dialog(
                                CsPhotoViewer(
                                  photoList: model.imageList,
                                  tapIndex: model.imageList.indexOf(imgUrl),
                                ),
                                useSafeArea: false);
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xff313033)),
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
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        if (!isSelf) {
                          PostListController.find.praisePost(model).then((value) {
                            if (value) {
                              model.isPraise.value = !model.isPraise.value;
                              if (model.isPraise.value) {
                                model.praiseNum += 1;
                              } else {
                                model.praiseNum -= 1;
                              }
                            }
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Image.asset(
                                    "assets/images/profile/icon_dianzan.webp",
                                    width: 16,
                                    color: model.isPraise.value ? Colors.pink : null,
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
                            )),
                      ),
                    ),
                  ),
                  Expanded(
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
                                showHearts(context, details.globalPosition, heartNum);
                              },
                            );
                          }
                        }
                      },
                      child: Container(
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
