import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/utils/index.dart';

import '../../../playwith/balance/widget/tips_dialog.dart';
import '../../game/game_home_page.dart';
import '../play_order/rating_comment_page.dart';
import 'other_profile_page.dart';

class OtherDashboardPage extends StatelessWidget {
  const OtherDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = OtherProfileController.find;
    return Obx(() => ListView(
          padding: EdgeInsets.zero,
          children: [
            Visibility(
              visible: t.player.value.trophies.isNotEmpty,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text("Badge".tr,
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.white))
                        ],
                      ),
                    ),
                    Container(
                      height: 65,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        children: t.player.value.trophies
                            .map((e) => Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColor.itemBg,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTapDown: (detail) {
                                          Get.dialog(TipsDialog(
                                            offset: detail.globalPosition,
                                            tips: '${e.tips}',
                                          ));
                                        },
                                        child: ImageUtil.networkImage(
                                          url: e.iconLightImage,
                                          width: 36.w,
                                          height: 36.h,
                                        ),
                                      ),
                                      Text(e.iconName,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white))
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text("Services  ".tr,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.white))
                      ],
                    ),
                  ),
                  ...t.player.value.games
                      .map((game) => GestureDetector(
                            onTap: () =>
                                Get.to(() => GameHomePage(), arguments: {
                              "liveid": t.player.value.uid,
                              "skillId": game.serviceItem[0].skillid,
                              "gameId": game.id,
                              "avatar": t.player.value.avatar,
                              "nickName": t.player.value.nickName,
                              "sex": t.player.value.sex,
                              "age": t.player.value.age,
                              "uk": t.player.value.uk,
                              "price": game.serviceItem.first.price,
                              "unit": game.serviceItem.first.unit,
                            }),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 16),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: Color(0xFF292F3F)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 12),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: ImageUtil.networkImage(
                                              url: game.thumb,
                                              width: 96,
                                              height: 90,
                                              fit: BoxFit.cover)),
                                      Expanded(
                                          child: SizedBox(
                                        height: 90,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(game.name,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    if (game.serviceItem
                                                        .isNotEmpty) ...[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            game.level
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: AppColor
                                                                    .textC3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          13.horizontalSpace,
                                                          Image(
                                                            image: AssetImage(
                                                                'assets/images/ic_balance_money.webp'),
                                                            width: 15,
                                                            height: 15,
                                                          ),
                                                          3.horizontalSpace,
                                                          Text.rich(TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        '${double.parse(game.serviceItem.first.price).floor()}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 16
                                                                            .sp,
                                                                        fontFamily:
                                                                            FONT_MEDIUM)),
                                                                TextSpan(
                                                                    text:
                                                                        '/${game.serviceItem.first.unit}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 8
                                                                            .sp,
                                                                        fontFamily:
                                                                            FONT_MEDIUM)),
                                                              ])),
                                                        ],
                                                      )
                                                    ]
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Visibility(
                                                    visible: game
                                                        .gameVoice.isNotEmpty,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    maintainSize: true,
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () {
                                                        OtherProfileController
                                                            .find.audioManager
                                                            .play(
                                                                game.gameVoice);
                                                      },
                                                      child: Container(
                                                        height: 30.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15.r),
                                                            topRight:
                                                                Radius.circular(
                                                                    15.r),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15.r),
                                                          ),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0xFF6B5BFF),
                                                              Color(0xFF7643E3)
                                                            ],
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color(
                                                                    0x29632BDA),
                                                                offset: Offset(
                                                                    0, 3.5),
                                                                blurRadius: 8,
                                                                spreadRadius:
                                                                    0.5),
                                                            BoxShadow(
                                                                color: Color(
                                                                    0x29FFFFFF),
                                                                offset: Offset(
                                                                    0, -1.5),
                                                                blurRadius: 10,
                                                                spreadRadius:
                                                                    0.5),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                                "assets/images/profile/icon_voice_play.webp",
                                                                width: 20,
                                                                height: 20),
                                                            8.horizontalSpace,
                                                            Image.asset(
                                                                "assets/images/profile/icon_voice_progress.webp",
                                                                height: 13.h,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  EditPlayBtn(
                                                    isEdit: t.isSelf,
                                                    onTap: () {
                                                      if (game.serviceItem
                                                              .length ==
                                                          1) {
                                                        t.editService(
                                                            game,
                                                            game.serviceItem
                                                                .first);
                                                      } else {
                                                        game.ifShow.value =
                                                            !game.ifShow.value;
                                                      }
                                                    },
                                                  ).marginOnly(bottom: 13)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                  if (game.ifShow.value) ...[
                                    ...game.serviceItem.map((service) {
                                      return Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: AppColor.itemBg,
                                                    width: 1))),
                                        padding: EdgeInsets.only(left: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(service.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/ic_balance_money.webp'),
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                3.horizontalSpace,
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          '${double.parse(service.price).floor()}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.sp,
                                                          fontFamily:
                                                              FONT_MEDIUM)),
                                                  TextSpan(
                                                      text: '/${service.unit}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8.sp,
                                                          fontFamily:
                                                              FONT_MEDIUM)),
                                                ])),
                                                10.horizontalSpace,
                                                EditPlayBtn(
                                                  isEdit: t.isSelf,
                                                  onTap: () {
                                                    t.editService(
                                                        game, service);
                                                  },
                                                ),
                                                10.horizontalSpace,
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    })
                                  ]
                                ],
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          ],
        ));
  }
}

class EditPlayBtn extends StatelessWidget {
  EditPlayBtn({Key? key, this.isEdit = false, this.onTap}) : super(key: key);
  bool isEdit = false;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: 52,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColor.yellow,
        ),
        alignment: Alignment.center,
        child: Text(
          isEdit ? "EDIT" : "PLAY",
          style: TextStyle(
              fontSize: 12,
              color: AppColor.tabBackGround,
              fontWeight: FontWeight.bold,
              fontFamily: FONT_MEDIUM),
        ),
      ),
    );
  }
}
